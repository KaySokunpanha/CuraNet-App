import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/care_service.dart'; // Import CareService
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../widgets/custom_bottom_bar.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _carouselController;
  late Animation<Offset> _carouselSlideAnimation;
  late Animation<double> _fadeAnimation;

  // Page controller for carousel content
  final PageController _pageController = PageController();
  final ScrollController _tabScrollController = ScrollController();
  final CareService _careService = CareService();

  // State
  int _selectedCategoryIndex = 0;
  bool _isLoading = true;

  // Data State
  Map<String, dynamic>? _healthProfile;
  List<Map<String, dynamic>> _vitals = [];
  Map<String, dynamic>? _emergencyCard;
  List<dynamic> _medications = [];

  // Categories with Material Icons
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Health', 'icon': Icons.medical_information, 'color': Colors.blue},
    {'name': 'Medications', 'icon': Icons.medication, 'color': Colors.purple},
    {'name': 'Vitals', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'Emergency', 'icon': Icons.emergency, 'color': Colors.orange},
    {'name': 'Care Plans', 'icon': Icons.assignment, 'color': Colors.teal},
    {'name': 'Vaccines', 'icon': Icons.vaccines, 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();

    // Carousel animation - slides from bottom
    _carouselController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _carouselSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _carouselController,
            curve: Curves.easeOutCubic,
          ),
        );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _carouselController, curve: Curves.easeIn),
    );

    // Start animations immediately
    _carouselController.forward();

    // Load real data (uses cache if available)
    _fetchCareData();
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCareData() async {
    // Only show loading if we don't have cached data
    if (!_careService.hasCachedData) {
      setState(() => _isLoading = true);
    }

    try {
      final profile = await _careService.getHealthProfile();
      final vitals = await _careService.getVitals();
      final emergency = await _careService.getEmergencyCard();
      final meds = await _careService.getMedications();

      if (mounted) {
        setState(() {
          _healthProfile = profile;
          _vitals = vitals;
          _emergencyCard = emergency;
          _medications = meds;
          _isLoading = false;
        });

        // Start animation after data load
      }
    } catch (e) {
      print('Error loading care data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Pure math-based tab centering:
  /// scrollOffset = (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2)
  void _scrollToSelectedTab(int index) {
    if (!_tabScrollController.hasClients) return;

    final double screenWidth = MediaQuery.of(context).size.width;
    const double tabWidth = 128.0; // Tab width (120) + margin (8)
    final int lastIndex = _categories.length - 1;
    final double maxScrollExtent =
        _tabScrollController.position.maxScrollExtent;

    double targetOffset;

    if (index == 0) {
      // First tab: left edge
      targetOffset = 0.0;
    } else if (index == lastIndex) {
      // Last tab: right edge
      targetOffset = maxScrollExtent;
    } else {
      // Middle tabs: center using pure geometry
      targetOffset = (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);
    }

    _tabScrollController.animateTo(
      targetOffset.clamp(0.0, maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // Safe area padding at top
          SizedBox(height: MediaQuery.of(context).padding.top + 8),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            const SizedBox.shrink(),

          const SizedBox(height: 16),

          // Animated Carousel Tabs
          SlideTransition(
            position: _carouselSlideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildCategoryCarousel(isDark),
            ),
          ),

          const SizedBox(height: 8),

          // Sliding Content PageView
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                  // Auto-scroll carousel tabs to keep selected tab visible
                  _scrollToSelectedTab(index);
                },
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryContent(index, isDark);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem:
            CustomBottomBarItem.schedule, // Use schedule as placeholder
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.schedule) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }

  Widget _buildCategoryCarousel(bool isDark) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        controller: _tabScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // Smooth scrolling
        padding: EdgeInsets.zero, // No padding distortion
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;
          final color = category['color'] as Color;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _scrollToSelectedTab(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ), // Space between tabs
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color
                        : (isDark ? const Color(0xFF1F2937) : Colors.white),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? color
                          : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category['name'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryContent(int index, bool isDark) {
    final category = _categories[index];
    final color = category['color'] as Color;

    switch (index) {
      case 0:
        return _buildHealthSummary(isDark, color);
      case 1:
        return _buildMedications(isDark, color);
      case 2:
        return _buildVitals(isDark, color);
      case 3:
        return _buildEmergency(isDark, color);
      case 4:
        return _buildCarePlans(isDark, color);
      case 5:
        return _buildVaccines(isDark, color);
      default:
        return const SizedBox();
    }
  }

  Widget _buildHealthSummary(bool isDark, Color color) {
    // Correctly accessing allergies from health profile
    List<dynamic> allergies = [];
    if (_healthProfile?['allergies'] != null) {
      if (_healthProfile!['allergies'] is List) {
        allergies = _healthProfile!['allergies'];
      } else if (_healthProfile!['allergies'] is String) {
        try {
          allergies = jsonDecode(_healthProfile!['allergies']);
        } catch (_) {}
      }
    }

    final bloodGroup = _healthProfile?['bloodGroup'] ?? 'N/A';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            isDark: isDark,
            title: 'Blood Group',
            icon: Icons.bloodtype,
            color: Colors.red,
            child: Text(
              bloodGroup,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildListSection(
            isDark: isDark,
            title: 'Allergies',
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            items: allergies.map((e) => e.toString()).toList(),
            emptyMessage: 'No known allergies',
          ),
        ],
      ),
    );
  }

  Widget _buildMedications(bool isDark, Color color) {
    final medications = _medications;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            isDark: isDark,
            color: color,
            title: 'Current Medications',
            icon: Icons.medication,
            child: medications.isEmpty
                ? _buildPlaceholderContent('No medications recorded', isDark)
                : Column(
                    children: _medications
                        .map(
                          (med) => _buildListItem(
                            med.toString(), // Simplify for now, ideally parse object
                            Icons.circle,
                            color,
                            isDark,
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark: isDark,
            color: Colors.amber,
            title: 'Medication Reminders',
            icon: Icons.alarm,
            child: _buildPlaceholderContent('No reminders set', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildVitals(bool isDark, Color color) {
    // Helper to find latest value for a code
    String getValue(String code) {
      try {
        final observation = _vitals.firstWhere(
          (obs) => obs['code'] == code,
          orElse: () => {},
        );
        if (observation.isNotEmpty && observation['value'] != null) {
          final val = observation['value'];
          if (val is Map) return '${val['value']} ${val['unit'] ?? ''}';
          return val.toString();
        }
      } catch (_) {}
      return '--';
    }

    // Common LOINC codes
    final heartRate = getValue('8867-4');
    final bp = getValue('85354-9');
    final weight = getValue('29463-7');
    final spO2 = getValue('2708-6');
    // final temp = getValue('8310-5');
    // final sugar = getValue('2339-0'); // Random glucose

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildVitalCard(
                  'Heart Rate',
                  heartRate == '--' ? '-- bpm' : heartRate,
                  Icons.favorite,
                  Colors.red,
                  isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVitalCard(
                  'Blood Pressure',
                  bp == '--' ? '--/--' : bp,
                  Icons.compress,
                  Colors.blue,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildVitalCard(
                  'Weight',
                  weight == '--' ? '-- kg' : weight,
                  Icons.monitor_weight,
                  Colors.orange,
                  isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVitalCard(
                  'SpO2',
                  spO2 == '--' ? '-- %' : spO2,
                  Icons.air,
                  Colors.purple,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergency(bool isDark, Color color) {
    final emergencyContactName = _healthProfile?['emergencyContact'];
    final emergencyPhone = _healthProfile?['emergencyPhone'];
    final shareLink = _emergencyCard?['shareLink']; // If available

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark: isDark,
            title: 'Primary Emergency Contact',
            icon: Icons.contact_phone,
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (emergencyContactName != null) ...[
                  Text(
                    emergencyContactName,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (emergencyPhone != null)
                    Text(
                      emergencyPhone,
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
          // Add Emergency Share Card
          if (shareLink != null)
            _buildSectionCard(
              isDark: isDark,
              title: 'Active Emergency Share',
              icon: Icons.share_location,
              color: Colors.orange,
              child: const Text('Active share link available'),
            ),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _buildListSection({
    required bool isDark,
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    required String emptyMessage,
  }) {
    return _buildSectionCard(
      isDark: isDark,
      title: title,
      icon: icon,
      color: color,
      child: items.isEmpty
          ? _buildPlaceholderContent(emptyMessage, isDark)
          : Column(
              children: items
                  .map(
                    (item) => _buildListItem(item, Icons.circle, color, isDark),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildCarePlans(bool isDark, Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark: isDark,
            color: color,
            title: 'Doctor\'s Instructions',
            icon: Icons.assignment,
            child: _buildPlaceholderContent('No care instructions', isDark),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark: isDark,
            color: Colors.green,
            title: 'Diet Plan',
            icon: Icons.restaurant,
            child: _buildPlaceholderContent('No diet plan', isDark),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark: isDark,
            color: Colors.blue,
            title: 'Follow-up Appointments',
            icon: Icons.event,
            child: _buildPlaceholderContent('No upcoming follow-ups', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccines(bool isDark, Color color) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            isDark: isDark,
            color: color,
            title: 'Vaccination Records',
            icon: Icons.vaccines,
            child: _buildPlaceholderContent('No vaccination records', isDark),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark: isDark,
            color: Colors.amber,
            title: 'Upcoming Vaccines',
            icon: Icons.event_available,
            child: _buildPlaceholderContent('No upcoming vaccines', isDark),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            isDark: isDark,
            color: Colors.purple,
            title: 'Health Screenings',
            icon: Icons.fact_check,
            child: _buildPlaceholderContent('No screenings scheduled', isDark),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildSectionCard({
    required bool isDark,
    required Color color,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 8, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
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
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
