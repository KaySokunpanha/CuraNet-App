import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Metadata for medical record uploads
class RecordMetadata {
  final String recordType;
  final DateTime recordDate;
  final String? hospitalName;
  final String? doctorName;
  final String? notes;

  RecordMetadata({
    required this.recordType,
    required this.recordDate,
    this.hospitalName,
    this.doctorName,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordType': recordType,
      'recordDate': recordDate.toIso8601String(),
      if (hospitalName != null) 'hospitalName': hospitalName,
      if (doctorName != null) 'doctorName': doctorName,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Result of a file upload operation
class UploadResult {
  final bool success;
  final String? fileId;
  final String? error;

  UploadResult({required this.success, this.fileId, this.error});
}

/// Service for uploading medical records to backend
class RecordUploadService {
  final AuthService _authService = AuthService();

  /// Get access token with automatic refresh if expired
  Future<String?> _getAccessToken() async {
    // Don't skip refresh - let it auto-refresh if token is expired
    return await _authService.getAccessToken(skipRefresh: false);
  }

  /// Make an HTTP request with automatic token refresh on 401
  Future<http.Response> _makeAuthenticatedRequest({
    required Future<http.Response> Function(String token) requestBuilder,
    String operationName = 'Request',
  }) async {
    var token = await _getAccessToken();

    if (token == null) {
      throw Exception('Not authenticated. Please login again.');
    }

    // First attempt
    var response = await requestBuilder(token);

    // If 401, refresh token and retry once
    if (response.statusCode == 401) {
      print('⚠️ Got 401 on $operationName, refreshing token and retrying...');

      // Force token refresh
      token = await _authService.getAccessToken(skipRefresh: false);

      if (token == null) {
        throw Exception('Session expired. Please login again.');
      }

      print('🔄 Retrying $operationName with refreshed token...');

      // Retry the request with new token
      response = await requestBuilder(token);

      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }
    }

    return response;
  }

  /// Upload a file with metadata to the server
  Future<UploadResult> uploadFile({
    required String filename,
    required Uint8List fileBytes,
    required String mimeType,
    required RecordMetadata metadata,
  }) async {
    print('📤 Starting upload for: $filename (${fileBytes.length} bytes)');

    // Convert file to Base64
    final base64Data = base64Encode(fileBytes);

    print('📦 Base64 size: ${base64Data.length} chars');

    // Prepare tags with metadata
    final tags = {
      ...metadata.toJson(),
      'uploadedAt': DateTime.now().toIso8601String(),
      'source': 'mobile_app',
    };

    // Generate description from metadata
    final descriptionParts = <String>[];
    descriptionParts.add('Type: ${_formatRecordType(metadata.recordType)}');
    if (metadata.hospitalName != null) {
      descriptionParts.add('Hospital: ${metadata.hospitalName}');
    }
    if (metadata.doctorName != null) {
      descriptionParts.add('Doctor: ${metadata.doctorName}');
    }
    if (metadata.notes != null) {
      descriptionParts.add('Notes: ${metadata.notes}');
    }
    final description = descriptionParts.join(' | ');

    // Build request body
    final requestBody = {
      'filename': filename,
      'fileData': base64Data,
      'mimeType': mimeType,
      'description': description,
      'tags': tags,
    };

    print('🌐 Sending upload request to server...');

    // Use the authenticated request helper with automatic retry
    final response = await _makeAuthenticatedRequest(
      operationName: 'File Upload',
      requestBuilder: (token) => http
          .post(
            Uri.parse('${ApiConstants.baseUrl}/api/uploads/file'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: 60)), // 60 second timeout for large files
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('✅ Upload successful!');
      return UploadResult(success: true, fileId: data['data']?['fileId']);
    } else {
      // Log the error for debugging
      print('❌ Upload failed: ${response.statusCode} - ${response.body}');

      try {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          errorBody['error'] ??
              errorBody['message'] ??
              'Upload failed (${response.statusCode})',
        );
      } catch (e) {
        throw Exception('Upload failed: Status ${response.statusCode}');
      }
    }
  }

  /// Get list of user's uploaded files
  Future<List<Map<String, dynamic>>> getMyRecords({
    int limit = 50,
    int offset = 0,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/api/uploads/files').replace(
      queryParameters: {'limit': limit.toString(), 'offset': offset.toString()},
    );

    final response = await _makeAuthenticatedRequest(
      operationName: 'Get Records',
      requestBuilder: (token) =>
          http.get(uri, headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['files'] ?? []);
    } else {
      throw Exception('Failed to fetch records');
    }
  }

  /// Delete a record by file ID
  Future<bool> deleteRecord(String fileId) async {
    final response = await _makeAuthenticatedRequest(
      operationName: 'Delete Record',
      requestBuilder: (token) => http.delete(
        Uri.parse('${ApiConstants.baseUrl}/api/uploads/file/$fileId'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return response.statusCode == 200;
  }

  /// Download a file by ID
  Future<Map<String, dynamic>> downloadFile(String fileId) async {
    final response = await _makeAuthenticatedRequest(
      operationName: 'Download File',
      requestBuilder: (token) => http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/uploads/file/$fileId?base64=true',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to download file');
    }
  }

  /// Check for duplicate file using checksum
  Future<bool> isDuplicate(Uint8List fileBytes) async {
    // Simple hash check - in production, use proper SHA-256
    final simpleHash =
        fileBytes.length.toString() +
        fileBytes.take(100).fold<int>(0, (a, b) => a + b).toString();

    // For now, just return false - real implementation would check against server
    return false;
  }

  String _formatRecordType(String type) {
    switch (type.toLowerCase()) {
      case 'labreport':
        return 'Lab Report';
      case 'prescription':
        return 'Prescription';
      case 'dischargesummary':
        return 'Discharge Summary';
      case 'scanxraymri':
        return 'Scan/X-Ray/MRI';
      default:
        return 'Other';
    }
  }

  /// Get all uploaded files for the current user
  Future<List<Map<String, dynamic>>> getMyFiles({
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'cached_my_files';

    if (!forceRefresh && prefs.containsKey(cacheKey)) {
      final cached = prefs.getString(cacheKey);
      if (cached != null) {
        final List<dynamic> list = jsonDecode(cached);
        return List<Map<String, dynamic>>.from(list);
      }
    }

    try {
      final response = await _makeAuthenticatedRequest(
        operationName: 'Get My Files',
        requestBuilder: (token) => http.get(
          Uri.parse('${ApiConstants.baseUrl}/api/uploads/my-files'),
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['data'] ?? data['files'] ?? [];

        final result = List<Map<String, dynamic>>.from(files);
        // Cache the result
        await prefs.setString(cacheKey, jsonEncode(result));
        return result;
      } else {
        print('Failed to get files: ${response.statusCode} - ${response.body}');
        // Try returning cache if API fail
        if (prefs.containsKey(cacheKey)) {
          final cached = prefs.getString(cacheKey);
          if (cached != null) {
            final List<dynamic> list = jsonDecode(cached);
            return List<Map<String, dynamic>>.from(list);
          }
        }
        return [];
      }
    } catch (e) {
      // Try cache on network error
      if (prefs.containsKey(cacheKey)) {
        final cached = prefs.getString(cacheKey);
        if (cached != null) {
          final List<dynamic> list = jsonDecode(cached);
          return List<Map<String, dynamic>>.from(list);
        }
      }
      print('Error getting files: $e');
      return [];
    }
  }
}
