import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../services/health_service.dart';
import '../../services/care_service.dart';
import '../../services/auth_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final HealthService _healthService = HealthService();
  final CareService _careService = CareService();
  final AuthService _authService = AuthService();

  late TabController _tabController;

  // bool _isLoading = true; // Unused for now as we just show content
  // String _errorMessage = ''; // Unused

  // --- Identity Data ---
  String _healthId = '';
  String _email = '';
  String _phone = '';
  String _firstName = '';
  String _lastName = '';
  String _displayName = '';
  String? _dateOfBirth;
  String? _gender;
  String? _bloodGroup;
  String? _address;
  String? _emergencyContact;
  String? _emergencyPhone;
  // String? _profilePhoto; // Placeholder for future

  // --- Care Data ---
  List<String> _allergies = [];
  List<dynamic> _medications = [];
  List<Map<String, dynamic>> _vitals = [];
  Map<String, dynamic>? _emergencyCard;
  // List<dynamic> _appointments = []; // Removed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    // setState(() => _isLoading = true);
    await Future.wait([_loadProfile(), _loadCareData()]);
    // if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadProfile() async {
    try {
      // Use cached data first if available (Global Sync should have populated it)
      // Standard pattern: Fetch returns cache immediately if valid
      final result = await _healthService.getProfile();
      if (result['success'] == true && mounted) {
        final data = result['data'];
        final user = data['user'];
        final profile = data['profile'];

        setState(() {
          _healthId = user['healthId'] ?? '';
          _email = user['email'] ?? '';
          _phone = user['phone'] ?? '';

          if (profile != null) {
            _firstName = profile['firstName'] ?? '';
            _lastName = profile['lastName'] ?? '';
            _displayName = profile['displayName'] ?? '';
            _dateOfBirth = profile['dateOfBirth'];
            _gender = profile['gender'];
            _bloodGroup = profile['bloodGroup'];
            _address = _parseAddress(profile['address']);
            _emergencyContact = profile['emergencyContact'];
            _emergencyPhone = profile['emergencyPhone'];
            // Allergies often in profile too, but we'll prioritize CareService for structured data if available
            _allergies = _parseJsonArray(profile['allergies']);
          }
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> _loadCareData() async {
    try {
      final vitals = await _careService.getVitals();
      final meds = await _careService.getMedications();
      final emergency = await _careService.getEmergencyCard();

      if (mounted) {
        setState(() {
          _vitals = vitals;
          _medications = meds;
          _emergencyCard = emergency;
        });
      }
    } catch (e) {
      print('Error loading care data: $e');
    }
  }

  // --- Helpers ---
  String _getInitials() {
    if (_firstName.isEmpty && _lastName.isEmpty) {
      return _displayName.isNotEmpty ? _displayName[0].toUpperCase() : 'U';
    }
    return '${_firstName.isNotEmpty ? _firstName[0] : ''}${_lastName.isNotEmpty ? _lastName[0] : ''}'
        .toUpperCase();
  }

  String _getDisplayName() {
    if (_displayName.isNotEmpty) return _displayName;
    if (_firstName.isNotEmpty || _lastName.isNotEmpty) {
      return '$_firstName $_lastName'.trim();
    }
    return _email;
  }

  String _calculateAge(String? dateStr) {
    if (dateStr == null) return '--';
    try {
      final dob = DateTime.parse(dateStr);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return '$age Yrs';
    } catch (e) {
      return '--';
    }
  }

  String _parseAddress(dynamic addressJson) {
    if (addressJson == null) return 'Not set';
    if (addressJson is String) return addressJson;
    if (addressJson is Map) {
      final parts = <String>[];
      if (addressJson['street'] != null) parts.add(addressJson['street']);
      if (addressJson['city'] != null) parts.add(addressJson['city']);
      return parts.isEmpty ? 'Not set' : parts.join(', ');
    }
    return 'Not set';
  }

  List<String> _parseJsonArray(dynamic jsonData) {
    if (jsonData == null) return [];
    if (jsonData is List) return jsonData.map((e) => e.toString()).toList();
    return [];
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _authService.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.authentication,
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F7FA), // Match Health Dashboard background
      /*
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      */
      // Custom AppBar implies we might want a clean full screen look or standard app bar.
      // User ref implies a clean header. We will use a Column structure.
      body: Column(
        children: [
          // --- Identity Layer ---
          _buildIdentityHeader(isDark),

          // --- Control Bar ---
          Container(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: isDark
                  ? Colors.white
                  : const Color(0xFF1976D2), // Match Health ID blue
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1976D2),
              indicatorWeight: 3,
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Health'),
                Tab(text: 'Medications'),
                Tab(text: 'Vitals'),
                Tab(text: 'Emergency'),
                Tab(text: 'Care Plans'),
                Tab(text: 'Vaccines'),
              ],
            ),
          ),

          // --- Care Layer (Content) ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHealthTab(isDark),
                _buildMedicationsTab(isDark),
                _buildVitalsTab(isDark),
                _buildEmergencyTab(isDark),
                _buildCarePlansTab(isDark),
                _buildVaccinesTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button removed as per request
              const SizedBox(
                width: 48,
              ), // Spacer to balance if needed, or just let standard layout handle it
              const Text(
                'Patient Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ), // Dark icon
                onSelected: (value) {
                  if (value == 'edit') {
                    // Navigate to Edit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          currentProfile: {
                            'user': {
                              'healthId': _healthId,
                              'email': _email,
                              'phone': _phone,
                            },
                            'profile': {
                              'firstName': _firstName,
                              'lastName': _lastName,
                              'displayName': _displayName,
                              'dateOfBirth': _dateOfBirth,
                              'gender': _gender,
                              'bloodGroup': _bloodGroup,
                              'address': _address,
                              'emergencyContact': _emergencyContact,
                              'emergencyPhone': _emergencyPhone,
                              'allergies': _allergies,
                              'medications': _medications,
                            },
                          },
                        ),
                      ),
                    ).then((_) => _loadAllData());
                  } else if (value == 'logout') {
                    _showLogoutDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Profile'),
                  ),
                  const PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // White border
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue[100],
              child: Text(
                _getInitials(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name & ID
          Text(
            _getDisplayName(),
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Patient ID: $_healthId',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // Pill stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPillStat(_calculateAge(_dateOfBirth), 'Age'),
              const SizedBox(width: 12),
              _buildPillStat(_bloodGroup ?? '-', 'Blood'),
              const SizedBox(width: 12),
              _buildPillStat(_gender ?? '-', 'Gender'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB VIEWS ---

  Widget _buildHealthTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          isDark,
          'Basic Info',
          Icons.info_outline,
          Colors.blue,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Phone', _phone, isDark),
              _buildInfoRow('Email', _email, isDark),
              _buildInfoRow('Address', _address ?? 'Not set', isDark),
              _buildInfoRow(
                'Emergency Contact',
                '$_emergencyContact ($_emergencyPhone)',
                isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          isDark,
          'Allergies',
          Icons.warning_amber_rounded,
          Colors.orange,
          _allergies.isEmpty
              ? Text(
                  'No known allergies',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                )
              : Wrap(
                  spacing: 8,
                  children: _allergies
                      .map(
                        (a) => Chip(
                          label: Text(a),
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.orange),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          isDark,
          'Notes',
          Icons.note,
          Colors.grey,
          const Text(
            'No additional notes.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark,
            'Current Medications',
            Icons.medication,
            Colors.purple,
            _medications.isEmpty
                ? _buildPlaceholderContent('No medications recorded', isDark)
                : Column(
                    children: _medications
                        .map(
                          (med) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    med.toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark,
            'Medication Reminders',
            Icons.alarm,
            Colors.amber,
            _buildPlaceholderContent('No reminders set', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsTab(bool isDark) {
    // Extract vital values
    String getValue(String code) {
      try {
        final observation = _vitals.firstWhere(
          (obs) => obs['code'] == code,
          orElse: () => {},
        );
        if (observation.isNotEmpty && observation['value'] != null) {
          final val = observation['value'];
          if (val is Map)
            return '${val['value']}'; // Just value, unit separate if needed
          return val.toString();
        }
      } catch (_) {}
      return '--';
    }

    // Codes based on CareScreen logic
    final heartRate = getValue('8867-4');
    final bp = getValue('85354-9');
    final weight = getValue('29463-7');
    final spO2 = getValue('2708-6');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildVitalGridCard(
                  isDark,
                  'Heart Rate',
                  heartRate,
                  'bpm',
                  Icons.favorite,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVitalGridCard(
                  isDark,
                  'Blood Pressure',
                  bp,
                  'mmHg',
                  Icons.compress,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildVitalGridCard(
                  isDark,
                  'SpO2',
                  spO2,
                  '%',
                  Icons.air,
                  Colors.teal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVitalGridCard(
                  isDark,
                  'Weight',
                  weight,
                  'kg',
                  Icons.monitor_weight,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'History',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Graph Visualization Coming Soon',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Common Widgets ---
  Widget _buildSectionCard(
    bool isDark,
    String title,
    IconData icon,
    Color color,
    Widget content,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalGridCard(
    bool isDark,
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'NORMAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ), // Dummy status
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }

  // --- New Tabs ---
  Widget _buildEmergencyTab(bool isDark) {
    if (_emergencyContact == null && _emergencyCard == null) {
      return Center(
        child: Text('No emergency data', style: TextStyle(color: Colors.grey)),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark,
            'Primary Emergency Contact',
            Icons.contact_phone,
            Colors.red,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_emergencyContact != null) ...[
                  Text(
                    _emergencyContact!,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_emergencyPhone != null)
                    Text(
                      _emergencyPhone!,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                ] else
                  Text(
                    'No emergency contact set',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_emergencyCard?['shareLink'] != null)
            _buildSectionCard(
              isDark,
              'Active Emergency Share',
              Icons.share_location,
              Colors.orange,
              const Text('Active share link available'),
            ),
        ],
      ),
    );
  }

  Widget _buildCarePlansTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark,
            'Doctor\'s Instructions',
            Icons.assignment,
            Colors.teal,
            _buildPlaceholderContent('No care instructions', isDark),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark,
            'Daily Goals',
            Icons.check_circle_outline,
            Colors.teal,
            _buildPlaceholderContent('No goals set', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinesTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark,
            'Immunization Record',
            Icons.vaccines,
            Colors.green,
            _buildPlaceholderContent('No vaccination records found', isDark),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark,
            'Upcoming',
            Icons.calendar_today,
            Colors.green,
            _buildPlaceholderContent('No upcoming vaccinations', isDark),
          ),
        ],
      ),
    );
  }

  // --- Helpers for Placeholders ---
  Widget _buildPlaceholderContent(String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: GoogleFonts.inter(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
