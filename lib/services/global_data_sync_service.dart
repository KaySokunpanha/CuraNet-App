import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'health_service.dart';
import 'care_service.dart';
import 'record_upload_service.dart';

class GlobalDataSyncService {
  final AuthService _authService = AuthService();
  final HealthService _healthService = HealthService();
  final CareService _careService = CareService();
  final RecordUploadService _uploadService = RecordUploadService();

  static final GlobalDataSyncService _instance =
      GlobalDataSyncService._internal();

  factory GlobalDataSyncService() {
    return _instance;
  }

  GlobalDataSyncService._internal();

  /// Syncs all critical data from backend to local cache
  /// This should be called when app starts and internet is available
  Future<void> syncAllData() async {
    print('🔄 GlobalSync: Starting full data sync...');

    // 1. Check Connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      print('❌ GlobalSync: No internet connection. Skipping sync.');
      return;
    }

    // 2. Check Authentication
    final token = await _authService.getAccessToken();
    if (token == null) {
      print('⚠️ GlobalSync: User not authenticated. Skipping sync.');
      return;
    }

    try {
      final stopwatch = Stopwatch()..start();

      // 3. Fetch All Data in Parallel
      // We use forceRefresh: true to ensure we get fresh data from backend
      // and update the SharedPreferences cache.
      await Future.wait([
        // Care Service Data
        _careService.getHealthProfile(forceRefresh: true),
        _careService.getVitals(forceRefresh: true),
        _careService.getEmergencyCard(forceRefresh: true),

        // Health Service Data (Dashboard & Records)
        _healthService.getProfile(forceRefresh: true),
        _healthService.getEncounters(forceRefresh: true),
        _healthService.getAppointments(forceRefresh: true),
        _healthService.getObservations(forceRefresh: true),

        // Uploaded Records
        _uploadService.getMyFiles(forceRefresh: true),
      ]);

      stopwatch.stop();
      print('✅ GlobalSync: Completed in ${stopwatch.elapsedMilliseconds}ms');

      // Optional: Save a timestamp of last sync
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'last_global_sync',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('❌ GlobalSync: Error during sync: $e');
    }
  }
}
