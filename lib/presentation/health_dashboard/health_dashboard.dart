import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../services/health_service.dart';
import '../../services/auth_service.dart';
import 'widgets/health_id_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_activity_list.dart';
import 'widgets/speed_dial_menu.dart';

class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  final _healthService = HealthService();
  final _authService = AuthService();

  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>>? _recentActivity;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCachedDataSync();
    _loadDashboardData();
  }

  // Load cached data synchronously first to avoid showing "Loading..."
  void _loadCachedDataSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load profile from cache
      final cachedProfile = prefs.getString('cached_profile');
      if (cachedProfile != null) {
        final profileData = jsonDecode(cachedProfile);
        if (profileData['success'] && mounted) {
          setState(() {
            final data = profileData['data'];
            _userProfile = {...?data['user'], 'healthProfile': data['profile']};
          });
        }
      }

      // Load recent activity from cached encounters and appointments
      final cachedEncounters = prefs.getString('cached_encounters');
      final cachedAppointments = prefs.getString('cached_appointments');

      List<Map<String, dynamic>> activities = [];

      // Process cached encounters
      if (cachedEncounters != null) {
        final encountersData = jsonDecode(cachedEncounters);
        if (encountersData['encounters'] != null) {
          final encounters = encountersData['encounters'] as List;

          for (var encounter in encounters.take(5)) {
            activities.add({
              'type': 'encounter',
              'title': _getEncounterTitle(encounter),
              'subtitle': encounter['reason'] ?? 'Medical Visit',
              'doctor': 'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
              'date': encounter['startTime'] ?? encounter['createdAt'],
            });

            // Add observations
            if (encounter['observations'] != null &&
                encounter['observations'] is List) {
              final observations = encounter['observations'] as List;
              for (var obs in observations) {
                final code = obs['code']?.toString().toLowerCase() ?? '';

                if (code == 'vitals') {
                  activities.add({
                    'type': 'vitals',
                    'title': 'Vital Signs Recorded',
                    'subtitle': 'Health metrics recorded',
                    'doctor':
                        'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                  });
                } else if (code == 'prescription') {
                  activities.add({
                    'type': 'prescription',
                    'title': 'Prescription Issued',
                    'subtitle': 'Medications prescribed',
                    'doctor':
                        'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                  });
                } else if (code == 'diagnosis' || code == 'assessment') {
                  activities.add({
                    'type': 'diagnosis',
                    'title': 'Diagnosis Recorded',
                    'subtitle': 'Health condition assessed',
                    'doctor':
                        'Provider ID: ${encounter['providerId'] ?? 'Unknown'}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                  });
                }
              }
            }
          }
        }
      }

      // Process cached appointments
      if (cachedAppointments != null) {
        final appointmentsData = jsonDecode(cachedAppointments);
        if (appointmentsData['success'] && appointmentsData['data'] != null) {
          final appointments =
              appointmentsData['data']['appointments'] as List? ?? [];

          for (var appointment in appointments.take(3)) {
            final status =
                appointment['status']?.toString().toUpperCase() ?? 'PENDING';
            String title = 'Appointment Scheduled';

            if (status == 'CONFIRMED') {
              title = 'Appointment Confirmed';
            } else if (status == 'CANCELLED') {
              title = 'Appointment Cancelled';
            }

            activities.add({
              'type': 'appointment',
              'title': title,
              'subtitle': appointment['reason'] ?? 'Consultation',
              'doctor': 'Dr. ${appointment['doctorName'] ?? 'Unknown'}',
              'date':
                  appointment['appointmentDate'] ?? appointment['createdAt'],
              'status': status,
            });
          }
        }
      }

      // Sort by date and take last 10
      activities.sort((a, b) {
        final dateA = DateTime.tryParse(a['date'] ?? '');
        final dateB = DateTime.tryParse(b['date'] ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });

      if (mounted && activities.isNotEmpty) {
        setState(() {
          _recentActivity = activities.take(10).toList();
        });
      }

      // Load user data from auth service
      final userData = await _authService.getUserData();
      if (userData != null && mounted) {
        setState(() {
          _userProfile = {...?_userProfile, ...?userData};
        });
      }
    } catch (e) {
      print('Error loading cached data: $e');
    }
  }

  String _getEncounterTitle(Map<String, dynamic> encounter) {
    final reason = encounter['reason']?.toString() ?? '';
    if (reason.isNotEmpty) {
      String cleanedReason = reason
          .replaceAll(
            RegExp(
              r'^(follow_up|routine|emergency|consultation)\\s*-?\\s*',
              caseSensitive: false,
            ),
            '',
          )
          .trim();

      if (cleanedReason.isNotEmpty) {
        return cleanedReason[0].toUpperCase() + cleanedReason.substring(1);
      }
    }
    return 'Medical Visit';
  }

  Future<void> _loadDashboardData() async {
    try {
      // Get user data from local storage first
      final userData = await _authService.getUserData();

      // Fetch profile and recent activity from backend (will return cached data instantly)
      final results = await Future.wait([
        _healthService.getProfile(),
        _healthService.getRecentActivity(),
      ]);

      final profileResult = results[0];
      final activityResult = results[1];

      print('📊 Profile Result: $profileResult');
      if (profileResult['success'] && profileResult['data'] != null) {
        print('👤 User Data: ${profileResult['data']['user']}');
        print('🏥 Health Profile: ${profileResult['data']['profile']}');
      }

      if (mounted) {
        setState(() {
          if (profileResult['success']) {
            final profileData = profileResult['data'];
            _userProfile = {
              ...?userData,
              ...?profileData['user'],
              'healthProfile': profileData['profile'],
            };
            print('✅ Final User Profile: $_userProfile');
          } else {
            _userProfile = userData;
          }

          if (activityResult['success']) {
            _recentActivity = List<Map<String, dynamic>>.from(
              activityResult['data'] ?? [],
            );
          } else {
            _recentActivity = [];
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load dashboard data';
        });
      }
    }
  }

  String _getUserName() {
    if (_userProfile == null) return 'Loading...';

    final healthProfile = _userProfile!['healthProfile'];
    if (healthProfile != null) {
      final firstName = healthProfile['firstName'] ?? '';
      final lastName = healthProfile['lastName'] ?? '';
      if (firstName.isNotEmpty) {
        return '$firstName $lastName'.trim();
      }
    }

    // Fallback to email
    final email = _userProfile!['email'];
    if (email != null && !email.toString().contains('@curanet.placeholder')) {
      return email.split('@')[0];
    }

    return 'User';
  }

  String _getUserInitials() {
    final name = _getUserName();
    if (name == 'Loading...' || name == 'User') return 'U';

    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String? _getHealthId() {
    return _userProfile?['healthId'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(_errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadDashboardData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // Header with greeting and notification
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting,',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getUserName(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.grey[800],
                                  size: 24,
                                ),
                              ),
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Health ID Card
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: HealthIdCard(
                        healthId: _getHealthId(),
                        userName: _getUserName(),
                        healthProfile: _userProfile?['healthProfile'],
                      ),
                    ),
                  ),

                  // Quick Actions
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  const QuickActionsGrid(),

                  // Recent Activity Header
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activity',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  RecentActivityList(activities: _recentActivity ?? []),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2196F3).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {},
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

}