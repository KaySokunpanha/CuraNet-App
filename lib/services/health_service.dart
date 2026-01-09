import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class HealthService {
  // Cache keys
  static const String _profileCacheKey = 'cached_profile';
  static const String _profileTimestampKey = 'profile_timestamp';
  static const String _encountersCacheKey = 'cached_encounters';
  static const String _encountersTimestampKey = 'encounters_timestamp';
  static const String _appointmentsCacheKey = 'cached_appointments';
  static const String _appointmentsTimestampKey = 'appointments_timestamp';

  // Cache duration in minutes - data stays fresh for 30 minutes
  static const int _cacheDuration = 30;

  // Get access token
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Check if cached data is still valid
  bool _isCacheValid(int? timestamp) {
    if (timestamp == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    final difference = now - timestamp;
    return difference <
        (_cacheDuration * 60 * 1000); // Convert minutes to milliseconds
  }

  // Check if cache should be refreshed in background (after 5 minutes)
  bool _shouldRefreshInBackground(int? timestamp) {
    if (timestamp == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    final difference = now - timestamp;
    return difference > (5 * 60 * 1000); // Refresh after 5 minutes
  }

  // Get user profile (health profile data)
  Future<Map<String, dynamic>> getProfile({bool forceRefresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Always return cached data immediately if available
      final cachedData = prefs.getString(_profileCacheKey);
      final timestamp = prefs.getInt(_profileTimestampKey);

      // If cache is valid and not forcing refresh, return cached data
      if (!forceRefresh && cachedData != null && _isCacheValid(timestamp)) {
        // Check if we should refresh in background (after 5 minutes)
        if (_shouldRefreshInBackground(timestamp)) {
          // Refresh in background without blocking UI
          _refreshProfileInBackground();
        }
        return jsonDecode(cachedData);
      }

      // If forcing refresh or cache expired, fetch fresh data
      final token = await _getAccessToken();
      if (token == null) {
        // Return cached data if available even when not authenticated
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.healthProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Cache the response
        await prefs.setString(_profileCacheKey, jsonEncode(data));
        await prefs.setInt(
          _profileTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        return data;
      } else {
        // Return cached data if API fails
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      // Return cached data if available on network error
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(_profileCacheKey);
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
      } catch (_) {}

      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Refresh profile in background without blocking UI
  Future<void> _refreshProfileInBackground() async {
    try {
      final token = await _getAccessToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.healthProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileCacheKey, jsonEncode(data));
        await prefs.setInt(
          _profileTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e) {
      // Silently fail background refresh
    }
  }

  // Get patient appointments
  Future<Map<String, dynamic>> getAppointments({
    bool forceRefresh = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Always return cached data immediately if available
      final cachedData = prefs.getString(_appointmentsCacheKey);
      final timestamp = prefs.getInt(_appointmentsTimestampKey);

      // If cache is valid and not forcing refresh, return cached data
      if (!forceRefresh && cachedData != null && _isCacheValid(timestamp)) {
        // Check if we should refresh in background (after 5 minutes)
        if (_shouldRefreshInBackground(timestamp)) {
          // Refresh in background without blocking UI
          _refreshAppointmentsInBackground();
        }
        return jsonDecode(cachedData);
      }

      final token = await _getAccessToken();
      if (token == null) {
        // Return cached data if available even when not authenticated
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.patientAppointments),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Cache the response
        await prefs.setString(_appointmentsCacheKey, jsonEncode(data));
        await prefs.setInt(
          _appointmentsTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        return data;
      } else {
        // Return cached data if API fails
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get appointments',
        };
      }
    } catch (e) {
      // Return cached data if available on network error
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(_appointmentsCacheKey);
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
      } catch (_) {}

      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Refresh appointments in background without blocking UI
  Future<void> _refreshAppointmentsInBackground() async {
    try {
      final token = await _getAccessToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.patientAppointments),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_appointmentsCacheKey, jsonEncode(data));
        await prefs.setInt(
          _appointmentsTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e) {
      // Silently fail background refresh
    }
  }

  // Get encounters (medical visits/consultations)
  Future<Map<String, dynamic>> getEncounters({
    bool forceRefresh = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Always return cached data immediately if available
      final cachedData = prefs.getString(_encountersCacheKey);
      final timestamp = prefs.getInt(_encountersTimestampKey);

      // If cache is valid and not forcing refresh, return cached data
      if (!forceRefresh && cachedData != null && _isCacheValid(timestamp)) {
        // Check if we should refresh in background (after 5 minutes)
        if (_shouldRefreshInBackground(timestamp)) {
          // Refresh in background without blocking UI
          _refreshEncountersInBackground();
        }
        return jsonDecode(cachedData);
      }

      final token = await _getAccessToken();
      if (token == null) {
        // Return cached data if available even when not authenticated
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.encountersList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Cache the response
        await prefs.setString(_encountersCacheKey, jsonEncode(data));
        await prefs.setInt(
          _encountersTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        return data;
      } else {
        // Return cached data if API fails
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get encounters',
        };
      }
    } catch (e) {
      // Return cached data if available on network error
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(_encountersCacheKey);
        if (cachedData != null) {
          return jsonDecode(cachedData);
        }
      } catch (_) {}

      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Refresh encounters in background without blocking UI
  Future<void> _refreshEncountersInBackground() async {
    try {
      final token = await _getAccessToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.encountersList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_encountersCacheKey, jsonEncode(data));
        await prefs.setInt(
          _encountersTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e) {
      // Silently fail background refresh
    }
  }

  // Clear all cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileCacheKey);
    await prefs.remove(_profileTimestampKey);
    await prefs.remove(_encountersCacheKey);
    await prefs.remove(_encountersTimestampKey);
    await prefs.remove(_appointmentsCacheKey);
    await prefs.remove(_appointmentsTimestampKey);
  }

  // Get observations (lab results, vitals, measurements)
  Future<Map<String, dynamic>> getObservations({
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'cached_observations';
    const timestampKey = 'observations_timestamp';

    // Always return cached data immediately if available
    final cachedData = prefs.getString(cacheKey);
    final timestamp = prefs.getInt(timestampKey);

    // If cache is valid and not forcing refresh, return cached data
    if (!forceRefresh && cachedData != null && _isCacheValid(timestamp)) {
      // Background refresh check
      if (_shouldRefreshInBackground(timestamp)) {
        _refreshObservationsInBackground();
      }
      return jsonDecode(cachedData);
    }

    try {
      final token = await _getAccessToken();
      if (token == null) {
        if (cachedData != null) return jsonDecode(cachedData);
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.observationsList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Cache the response
        await prefs.setString(cacheKey, jsonEncode(data));
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        return data;
      } else {
        if (cachedData != null) return jsonDecode(cachedData);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get observations',
        };
      }
    } catch (e) {
      if (cachedData != null) return jsonDecode(cachedData);
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Refresh observations in background
  Future<void> _refreshObservationsInBackground() async {
    try {
      final token = await _getAccessToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.observationsList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_observations', jsonEncode(data));
        await prefs.setInt(
          'observations_timestamp',
          DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e) {}
  }

  // Get recent activity (combined encounters, appointments, and observations)
  Future<Map<String, dynamic>> getRecentActivity() async {
    try {
      // Fetch encounters, appointments in parallel
      final results = await Future.wait([getEncounters(), getAppointments()]);

      final encountersResult = results[0];
      final appointmentsResult = results[1];

      List<Map<String, dynamic>> activities = [];

      // Add encounters with their observations
      if (encountersResult['encounters'] != null) {
        final encounters = encountersResult['encounters'] as List;

        for (var encounter in encounters) {
          // Add main encounter as activity
          activities.add({
            'type': 'encounter',
            'title': _getEncounterTitle(encounter),
            'subtitle': encounter['reason'] ?? 'Medical Visit',
            'doctor': 'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
            'date': encounter['startTime'] ?? encounter['createdAt'],
            'id': encounter['id'],
            'icon': 'medical_visit',
          });

          // Add individual observations from this encounter
          if (encounter['observations'] != null &&
              encounter['observations'] is List) {
            final observations = encounter['observations'] as List;
            for (var obs in observations) {
              final code = obs['code']?.toString().toLowerCase() ?? '';

              if (code == 'vitals') {
                activities.add({
                  'type': 'vitals',
                  'title': 'Vital Signs Recorded',
                  'subtitle': _getVitalsSubtitle(obs),
                  'doctor':
                      'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'id': '${encounter['id']}_vitals',
                  'icon': 'vitals',
                });
              } else if (code == 'prescription') {
                activities.add({
                  'type': 'prescription',
                  'title': 'Prescription Issued',
                  'subtitle': _getPrescriptionSubtitle(obs),
                  'doctor':
                      'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'id': '${encounter['id']}_prescription',
                  'icon': 'prescription',
                });
              } else if (code == 'diagnosis' || code == 'assessment') {
                activities.add({
                  'type': 'diagnosis',
                  'title': 'Diagnosis Recorded',
                  'subtitle': _getDiagnosisSubtitle(obs),
                  'doctor':
                      'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'id': '${encounter['id']}_diagnosis',
                  'icon': 'diagnosis',
                });
              } else if (code.startsWith('lab_')) {
                activities.add({
                  'type': 'lab_test',
                  'title': 'Lab Test Result',
                  'subtitle': code.replaceAll('_', ' ').toUpperCase(),
                  'doctor':
                      'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'id': '${encounter['id']}_${code}',
                  'icon': 'lab_test',
                });
              }
            }
          }
        }
      }

      // Add appointments to activity list
      if (appointmentsResult['success'] && appointmentsResult['data'] != null) {
        final appointmentsData = appointmentsResult['data'];
        final appointments = appointmentsData['appointments'] as List? ?? [];

        for (var appointment in appointments) {
          final status =
              appointment['status']?.toString().toUpperCase() ?? 'PENDING';
          String title = 'Appointment Scheduled';

          if (status == 'CONFIRMED') {
            title = 'Appointment Confirmed';
          } else if (status == 'CANCELLED') {
            title = 'Appointment Cancelled';
          } else if (status == 'REJECTED') {
            title = 'Appointment Rejected';
          }

          activities.add({
            'type': 'appointment',
            'title': title,
            'subtitle': appointment['reason'] ?? 'Consultation',
            'doctor': 'Dr. ${appointment['doctorName'] ?? 'Unknown'}',
            'date': appointment['appointmentDate'] ?? appointment['createdAt'],
            'id': appointment['id'],
            'icon': 'appointment',
            'status': status,
          });
        }
      }

      // Sort by date (most recent first) and take only last 10 activities
      activities.sort((a, b) {
        final dateA = DateTime.tryParse(a['date'] ?? '');
        final dateB = DateTime.tryParse(b['date'] ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });

      // Limit to last 10 activities
      final recentActivities = activities.take(10).toList();

      return {'success': true, 'data': recentActivities};
    } catch (e) {
      print('Error getting recent activity: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Helper function to get encounter title
  String _getEncounterTitle(Map<String, dynamic> encounter) {
    final reason = encounter['reason']?.toString() ?? '';
    if (reason.isNotEmpty) {
      // Remove common prefixes and format
      String cleanedReason = reason
          .replaceAll(
            RegExp(
              r'^(follow_up|routine|emergency|consultation)\s*-?\s*',
              caseSensitive: false,
            ),
            '',
          )
          .trim();

      if (cleanedReason.isNotEmpty) {
        // Capitalize first letter
        return cleanedReason[0].toUpperCase() + cleanedReason.substring(1);
      }
    }
    return 'Medical Visit';
  }

  // Helper function to get vitals subtitle
  String _getVitalsSubtitle(Map<String, dynamic> obs) {
    try {
      final valueStr = obs['valueString'];
      if (valueStr != null) {
        final vitalsData = jsonDecode(valueStr);
        if (vitalsData['bloodPressure'] != null) {
          return 'BP: ${vitalsData['bloodPressure']}';
        } else if (vitalsData['temperature'] != null) {
          return 'Temp: ${vitalsData['temperature']}°C';
        }
      }
    } catch (e) {}
    return 'Health metrics recorded';
  }

  // Helper function to get prescription subtitle
  String _getPrescriptionSubtitle(Map<String, dynamic> obs) {
    try {
      final valueStr = obs['valueString'];
      if (valueStr != null) {
        final prescData = jsonDecode(valueStr);
        if (prescData['medications'] != null &&
            prescData['medications'] is List) {
          final meds = prescData['medications'] as List;
          if (meds.isNotEmpty) {
            return '${meds.length} medication${meds.length > 1 ? 's' : ''} prescribed';
          }
        }
      }
    } catch (e) {}
    return 'Medications prescribed';
  }

  // Helper function to get diagnosis subtitle
  String _getDiagnosisSubtitle(Map<String, dynamic> obs) {
    try {
      final valueStr = obs['valueString'];
      if (valueStr != null) {
        final diagData = jsonDecode(valueStr);
        if (diagData['condition'] != null) {
          return diagData['condition'].toString();
        }
      }
    } catch (e) {}
    return 'Health condition assessed';
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.healthProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data; // Backend returns {success: true, data: {...}}
      } else {
        return {
          'success': false,
          'message':
              data['error'] ?? data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Send email OTP
  Future<Map<String, dynamic>> sendEmailOtp(String email) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.healthProfile}/send-email-otp',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Verify email OTP
  Future<Map<String, dynamic>> verifyEmailOtp(String email, String otp) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.healthProfile}/verify-email-otp',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Failed to verify OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
