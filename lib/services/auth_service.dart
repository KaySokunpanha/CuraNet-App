import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';
import '../core/app_export.dart';
import '../routes/app_routes.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';

  // Register new user
  Future<Map<String, dynamic>> register({
    String? email,
    required String password,
    required String role,
    String? name,
    String? phone,
  }) async {
    try {
      // Validate that at least email or phone is provided
      if (email == null && phone == null) {
        return {
          'success': false,
          'message': 'Either email or phone is required',
        };
      }

      final body = {
        'password': password,
        'role': role,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (name != null) 'name': name,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Login user
  Future<Map<String, dynamic>> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      // Validate that at least email or phone is provided
      if (email == null && phone == null) {
        return {
          'success': false,
          'message': 'Either email or phone is required',
        };
      }

      final body = {
        'password': password,
        'deviceFingerprint': 'flutter-app',
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save access token, refresh token and user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_accessTokenKey, data['accessToken']);

        // Save refresh token from cookie header if available
        final cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.contains('refreshToken=')) {
          final refreshToken = _extractRefreshTokenFromCookie(cookies);
          if (refreshToken != null) {
            await prefs.setString(_refreshTokenKey, refreshToken);
          }
        }

        // Calculate and save token expiry (15 minutes from now)
        final expiryTime = DateTime.now()
            .add(Duration(minutes: 14))
            .millisecondsSinceEpoch;
        await prefs.setInt(_tokenExpiryKey, expiryTime);

        await prefs.setString(_userDataKey, jsonEncode(data['user']));

        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Verify email with token
  Future<Map<String, dynamic>> verifyEmail(String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Verification failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        // Call logout endpoint
        await http.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.logout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Ignore errors during logout
    } finally {
      await _clearSession();
    }
  }

  // Force logout - clears session and navigates to login
  // Called when token refresh fails with 401
  Future<void> forceLogout() async {
    print('🚪 Session expired, forcing logout...');
    await _clearSession();

    // Navigate to login page if navigator is available
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        AppRoutes.authentication,
        (route) => false, // Remove all previous routes
      );
    }
  }

  // Clear all session data from storage
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenExpiryKey);
    await prefs.remove(_userDataKey);
  }

  // Get stored access token
  static bool _isRefreshing = false; // Prevent concurrent refresh calls

  Future<String?> getAccessToken({bool skipRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // If skipRefresh is true, just return the token without checking expiry
    if (skipRefresh) {
      return prefs.getString(_accessTokenKey);
    }

    // If already refreshing, just return current token to avoid loop
    if (_isRefreshing) {
      print('⏳ Token refresh in progress, returning current token');
      return prefs.getString(_accessTokenKey);
    }

    // Check if token is expired or about to expire
    final expiryTime = prefs.getInt(_tokenExpiryKey);
    if (expiryTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;

      // If token will expire in less than 2 minutes, refresh it
      if (now >= expiryTime - (2 * 60 * 1000)) {
        print('🔄 Token expired, refreshing...');
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          print('✅ Token refreshed successfully');
          return prefs.getString(_accessTokenKey);
        } else {
          // Token refresh failed - force logout
          print('❌ Token refresh failed, forcing logout');
          await forceLogout();
          return null;
        }
      }
    }

    return prefs.getString(_accessTokenKey);
  }

  // Refresh access token using refresh token
  Future<bool> _refreshAccessToken() async {
    // Prevent concurrent refresh calls
    if (_isRefreshing) {
      return false;
    }

    _isRefreshing = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken == null) {
        print('❌ No refresh token found');
        _isRefreshing = false;
        return false;
      }

      final response = await http
          .post(
            Uri.parse(ApiConstants.baseUrl + '/api/auth/refresh'),
            headers: {
              'Content-Type': 'application/json',
              'Cookie': 'refreshToken=$refreshToken',
            },
          )
          .timeout(Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save new access token and expiry
        await prefs.setString(_accessTokenKey, data['accessToken']);
        final expiryTime = DateTime.now()
            .add(Duration(minutes: 14))
            .millisecondsSinceEpoch;
        await prefs.setInt(_tokenExpiryKey, expiryTime);

        _isRefreshing = false;
        return true;
      }

      print('❌ Token refresh failed: ${response.statusCode}');
      _isRefreshing = false;
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      _isRefreshing = false;
      return false;
    }
  }

  // Extract refresh token from Set-Cookie header
  String? _extractRefreshTokenFromCookie(String cookies) {
    final regex = RegExp(r'refreshToken=([^;]+)');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }

  // Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Check if user is logged in (quick check without network call)
  Future<bool> isLoggedIn() async {
    // Skip token refresh on login check to avoid network delays
    final token = await getAccessToken(skipRefresh: true);
    return token != null;
  }

  // Verify phone OTP
  Future<Map<String, dynamic>> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.verifyPhoneOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // For phone verification during registration
        return {
          'success': true,
          'userId': data['userId'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'OTP verification failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Resend phone OTP
  Future<Map<String, dynamic>> resendPhoneOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.resendPhoneOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to resend OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Request password reset
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Request failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
