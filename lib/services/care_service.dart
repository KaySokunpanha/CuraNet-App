import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CareService {
  final AuthService _authService = AuthService();

  // Cache Keys
  static const String _healthProfileKey = 'cached_care_profile';
  static const String _vitalsKey = 'cached_vitals';
  static const String _emergencyKey = 'cached_emergency_card';

  // Check if we have cached data (synchronous check not easily possible with Async Prefs,
  // but we can preload or just rely on the methods being fast)
  // For avoiding spinner, we can use a separate variable or just rely on FutureBuilder/fast IO.
  // However, specifically to support "hasCachedData" behavior synchronously for UI:
  bool _hasLocalCache = false;
  bool get hasCachedData => _hasLocalCache;

  CareService() {
    _checkLocalCache();
  }

  void _checkLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_healthProfileKey)) {
      _hasLocalCache = true;
    }
  }

  // Get Health Profile (Blood group, Allergies, etc.)
  Future<Map<String, dynamic>?> getHealthProfile({
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Return cached data if not forcing refresh
    if (!forceRefresh && prefs.containsKey(_healthProfileKey)) {
      final cached = prefs.getString(_healthProfileKey);
      if (cached != null) {
        return jsonDecode(cached);
      }
    }

    try {
      final token = await _authService.getAccessToken();
      print('CareService: Fetching Health Profile');
      print('Token available: ${token != null}');

      if (token == null) return null;

      final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profile);
      print('Requesting: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Correct parsing: Backend returns { user: { healthProfile: ... } }
        final profile = data['user']?['healthProfile'];
        if (profile != null) {
          await prefs.setString(_healthProfileKey, jsonEncode(profile));
          _hasLocalCache = true;
        }
        return profile;
      }
      return null;
    } catch (e) {
      print('Error fetching health profile: $e');
      return null;
    }
  }

  // Get Vitals (Enhanced Observations)
  Future<List<Map<String, dynamic>>> getVitals({
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh && prefs.containsKey(_vitalsKey)) {
      final cached = prefs.getString(_vitalsKey);
      if (cached != null) {
        final List<dynamic> list = jsonDecode(cached);
        return List<Map<String, dynamic>>.from(list);
      }
    }

    try {
      final token = await _authService.getAccessToken();
      if (token == null) return [];

      final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/observations/by-category',
      );
      print('CareService: Fetching Vitals from $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'category': 'vital-signs'}),
      );

      print('Vitals Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Vitals Response: $data');

        List<Map<String, dynamic>> vitalsToCache = [];
        if (data['data'] is List) {
          vitalsToCache = List<Map<String, dynamic>>.from(data['data']);
        }

        // Cache (even if empty)
        await prefs.setString(_vitalsKey, jsonEncode(vitalsToCache));
        return vitalsToCache;
      }
      return [];
    } catch (e) {
      print('Error fetching vitals: $e');
      return [];
    }
  }

  // Get Emergency Card
  Future<Map<String, dynamic>?> getEmergencyCard({
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh && prefs.containsKey(_emergencyKey)) {
      final cached = prefs.getString(_emergencyKey);
      if (cached != null) {
        return jsonDecode(cached);
      }
    }

    try {
      final token = await _authService.getAccessToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/emergency/card'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          await prefs.setString(_emergencyKey, jsonEncode(data['data']));
        }
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching emergency card: $e');
      return null;
    }
  }

  // Get Medications (from Health Profile or separate endpoint if available)
  // Currently using profile's 'medications' field if available, or empty
  Future<List<dynamic>> getMedications({bool forceRefresh = false}) async {
    final profile = await getHealthProfile(forceRefresh: forceRefresh);
    if (profile != null && profile['medications'] != null) {
      if (profile['medications'] is List) {
        return profile['medications'];
      }
      // If It's a JSON string
      if (profile['medications'] is String) {
        try {
          return jsonDecode(profile['medications']);
        } catch (e) {
          return [];
        }
      }
    }
    return [];
  }
}
