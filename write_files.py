import os

files = {
    r"g:\Project\curanet\lib\core\app_export.dart": r"""import 'package:flutter/material.dart';

// Export core packages
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

// Export utilities
// export 'utils/image_constant.dart';
// export 'utils/size_utils.dart';
// export 'utils/validation_functions.dart';

// Export theme
export '../theme/app_theme.dart';

// Export widgets
export '../widgets/custom_app_bar.dart';
export '../widgets/custom_bottom_bar.dart';
export '../widgets/custom_icon_widget.dart';
// export '../widgets/custom_image_widget.dart';
export '../widgets/custom_error_widget.dart';

// Export routes
export '../routes/app_routes.dart';

// Global keys
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
""",
    r"g:\Project\curanet\lib\main.dart": r"""import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuraNet',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\authentication_screen\authentication_screen.dart": r"""import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'widgets/biometric_auth_widget.dart';
import 'widgets/email_auth_widget.dart';
import 'widgets/phone_auth_widget.dart';
import 'widgets/social_auth_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  AuthenticationScreenState createState() => AuthenticationScreenState();
}

class AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isLogin = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo and Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services_rounded,
                        size: 48,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'CuraNet',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Lifetime Health Identity',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Auth Type Tabs
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Register'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Auth Methods
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginTab(context),
                    _buildRegisterTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context) {
    return Column(
      children: [
        const PhoneAuthWidget(isLogin: true),
        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        const SocialAuthWidget(),
        const SizedBox(height: 24),
        const BiometricAuthWidget(),
      ],
    );
  }

  Widget _buildRegisterTab(BuildContext context) {
    return Column(
      children: [
        const PhoneAuthWidget(isLogin: false),
        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        const SocialAuthWidget(),
      ],
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\health_dashboard\health_dashboard.dart": r"""import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'widgets/health_id_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_activity_list.dart';
import 'widgets/speed_dial_menu.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Health Dashboard',
        subtitle: 'Welcome back, John Doe',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
              child: Text(
                'JD',
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HealthIdCard(),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const QuickActionsGrid(),
              const SizedBox(height: 24),
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const RecentActivityList(),
            ],
          ),
        ),
      ),
      floatingActionButton: const SpeedDialMenu(),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.healthId,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.healthId) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\medical_records_screen\medical_records_screen.dart": r"""import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'widgets/record_card.dart';
import 'widgets/filter_modal.dart';
import 'widgets/empty_state_widget.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Mock data
  final List<Map<String, dynamic>> _records = [
    {
      'id': '1',
      'title': 'Blood Test Report',
      'doctor': 'Dr. Sarah Smith',
      'date': '2023-10-15',
      'type': 'Lab Report',
      'hospital': 'City General Hospital',
    },
    {
      'id': '2',
      'title': 'Vaccination Record',
      'doctor': 'Dr. James Wilson',
      'date': '2023-09-20',
      'type': 'Vaccination',
      'hospital': 'Community Clinic',
    },
    {
      'id': '3',
      'title': 'MRI Scan - Knee',
      'doctor': 'Dr. Emily Chen',
      'date': '2023-08-10',
      'type': 'Radiology',
      'hospital': 'Ortho Care Center',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRecords = _records.where((record) {
      final query = _searchQuery.toLowerCase();
      return record['title'].toLowerCase().contains(query) ||
             record['doctor'].toLowerCase().contains(query) ||
             record['type'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Medical Records',
        variant: CustomAppBarVariant.search,
        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const FilterModal(),
              );
            },
          ),
        ],
      ),
      body: filteredRecords.isEmpty
          ? const EmptyStateWidget(
              message: 'No records found',
              icon: Icons.folder_off,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                final record = filteredRecords[index];
                return RecordCard(
                  title: record['title'],
                  doctor: record['doctor'],
                  date: record['date'],
                  type: record['type'],
                  hospital: record['hospital'],
                  onTap: () {
                    // Navigate to details
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new record
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.records,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.records) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\medical_records_screen\widgets\empty_state_widget.dart": r"""import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\onboarding_flow\onboarding_flow.dart": r"""import 'package:flutter/material.dart';
import 'widgets/onboarding_slide_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Welcome to CuraNet',
      'description': 'Your complete health identity in one secure place.',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Track Your Health',
      'description': 'Monitor vitals, medications, and appointments easily.',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'Secure Records',
      'description': 'Access your medical history anytime, anywhere.',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/authentication-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(
                    title: _slides[index]['title']!,
                    description: _slides[index]['description']!,
                    imagePath: _slides[index]['image']!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Next/Get Started Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\onboarding_flow\widgets\onboarding_slide_widget.dart": r"""import 'package:flutter/material.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingSlideWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for image if asset doesn't exist
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.image,
              size: 100,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\patient_record_view\patient_record_view.dart": r"""import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'widgets/patient_header.dart';
import 'widgets/patient_tabs.dart';
import 'widgets/clinical_overview_tab.dart';
import 'widgets/records_tab.dart';
import 'widgets/prescriptions_tab.dart';
import 'widgets/vitals_tab.dart';

class PatientRecordView extends StatefulWidget {
  const PatientRecordView({super.key});

  @override
  State<PatientRecordView> createState() => _PatientRecordViewState();
}

class _PatientRecordViewState extends State<PatientRecordView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Patient Record',
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const PatientHeader(),
          PatientTabs(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ClinicalOverviewTab(),
                RecordsTab(),
                PrescriptionsTab(),
                VitalsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.care,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.care) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\presentation\splash_screen\splash_screen.dart": r"""import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// Splash screen for the healthcare application
/// Implements "Medical Precision" design philosophy
/// Displays animated logo and performs initialization tasks
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _performInitialization();
  }

  void _setupAnimations() {
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );

    // Check for reduced motion preference
    final reducedMotion = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;

    if (!reducedMotion) {
      _shimmerController.repeat();
    }
  }

  /// Perform critical background initialization tasks
  Future<void> _performInitialization() async {
    try {
      // Simulate HIPAA-compliant data initialization
      await Future.wait([
        _checkBiometricAvailability(),
        _loadEncryptedHealthRecordsCache(),
        _fetchSecurityCertificates(),
        _prepareOfflineDataSync(),
      ]);

      // Wait minimum 2 seconds for branding visibility
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isInitializing = false);
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        _showSecurityErrorModal();
      }
    }
  }

  /// Check biometric authentication availability
  Future<void> _checkBiometricAvailability() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Biometric check logic would go here
  }

  /// Load encrypted health records cache
  Future<void> _loadEncryptedHealthRecordsCache() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Cache loading logic would go here
  }

  /// Fetch security certificates for certificate pinning
  Future<void> _fetchSecurityCertificates() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Certificate fetching logic would go here
  }

  /// Prepare offline medical data synchronization
  Future<void> _prepareOfflineDataSync() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Sync preparation logic would go here
  }

  /// Navigate to appropriate screen based on authentication status
  void _navigateToNextScreen() {
    // Mock authentication status check
    final bool isAuthenticated = false; // Would check actual auth status
    final bool isNewUser = true; // Would check if user has completed onboarding

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/health-dashboard');
    } else if (isNewUser) {
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      Navigator.pushReplacementNamed(context, '/authentication-screen');
    }
  }

  /// Show security error modal if certificate pinning fails
  void _showSecurityErrorModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'security',
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Security Alert',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'Unable to establish secure connection. Please check your network and try again.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performInitialization();
            },
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1E3A8A), // Dark Medical Blue
                    const Color(0xFF1F2937), // Dark background
                  ]
                : [
                    const Color(0xFF0066CC), // Medical Blue
                    const Color(0xFF0052A3), // Darker Medical Blue
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer for vertical centering
              const Spacer(flex: 2),

              // Animated Logo with Shimmer Effect
              _buildAnimatedLogo(theme, isDark),

              SizedBox(height: 4.h),

              // App Name
              Text(
                'CuraNet',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 1.h),

              // Tagline
              Text(
                'Your Lifetime Health Identity',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),

              const Spacer(flex: 2),

              // Loading Indicator
              if (_isInitializing) _buildLoadingIndicator(theme),

              SizedBox(height: 6.h),

              // HIPAA Compliance Badge
              _buildComplianceBadge(theme),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Build animated logo with shimmer effect
  Widget _buildAnimatedLogo(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Logo Icon
              Center(
                child: CustomIconWidget(
                  iconName: 'medical_services',
                  color: isDark
                      ? const Color(0xFF3B8FE8)
                      : const Color(0xFF0066CC),
                  size: 15.w,
                ),
              ),

              // Shimmer Overlay
              if (!MediaQuery.of(context).disableAnimations)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          stops: [
                            _shimmerAnimation.value - 0.3,
                            _shimmerAnimation.value,
                            _shimmerAnimation.value + 0.3,
                          ],
                        ).createShader(bounds);
                      },
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Build loading indicator with progress text
  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Initializing secure connection...',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  /// Build HIPAA compliance badge
  Widget _buildComplianceBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'verified_user',
            color: Colors.white.withValues(alpha: 0.9),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'HIPAA Compliant',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
""",
    r"g:\Project\curanet\lib\widgets\custom_icon_widget.dart": r"""import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData = _iconMap[iconName];
    
    if (iconData == null) {
      return Icon(Icons.error, color: color, size: size);
    }

    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }

  static final Map<String, IconData> _iconMap = {
    'medical_services': Icons.medical_services,
    'verified_user': Icons.verified_user,
    'security': Icons.security,
    'arrow_back': Icons.arrow_back,
    'check': Icons.check,
    'close': Icons.close,
    'add': Icons.add,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'search': Icons.search,
    'home': Icons.home,
    'person': Icons.person,
    'settings': Icons.settings,
    'info': Icons.info,
    'warning': Icons.warning,
    'error': Icons.error,
    'chevron_right': Icons.chevron_right,
    'chevron_left': Icons.chevron_left,
    'expand_more': Icons.expand_more,
    'expand_less': Icons.expand_less,
    'more_vert': Icons.more_vert,
    'more_horiz': Icons.more_horiz,
    'menu': Icons.menu,
    'filter_list': Icons.filter_list,
    'sort': Icons.sort,
    'calendar_today': Icons.calendar_today,
    'access_time': Icons.access_time,
    'location_on': Icons.location_on,
    'phone': Icons.phone,
    'email': Icons.email,
    'lock': Icons.lock,
    'visibility': Icons.visibility,
    'visibility_off': Icons.visibility_off,
    'fingerprint': Icons.fingerprint,
    'g_mobiledata': Icons.g_mobiledata,
    'apple': Icons.apple,
    'facebook': Icons.facebook,
    'notifications': Icons.notifications,
    'notifications_none': Icons.notifications_none,
    'monitor_heart': Icons.monitor_heart,
    'medication': Icons.medication,
    'description': Icons.description,
    'folder': Icons.folder,
    'folder_open': Icons.folder_open,
    'credit_card': Icons.credit_card,
    'receipt': Icons.receipt,
    'local_hospital': Icons.local_hospital,
    'thermostat': Icons.thermostat,
    'monitor_weight': Icons.monitor_weight,
    'height': Icons.height,
    'bloodtype': Icons.bloodtype,
    'vaccines': Icons.vaccines,
    'healing': Icons.healing,
    'sick': Icons.sick,
    'coronavirus': Icons.coronavirus,
    'pregnant_woman': Icons.pregnant_woman,
    'child_care': Icons.child_care,
    'elderly': Icons.elderly,
    'wheelchair_pickup': Icons.wheelchair_pickup,
    'emergency': Icons.emergency,
    'call': Icons.call,
    'chat': Icons.chat,
    'video_call': Icons.video_call,
    'share': Icons.share,
    'download': Icons.download,
    'upload': Icons.upload,
    'print': Icons.print,
    'save': Icons.save,
    'logout': Icons.logout,
    'login': Icons.login,
  };
}
"""
}

for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Wrote {path}")
