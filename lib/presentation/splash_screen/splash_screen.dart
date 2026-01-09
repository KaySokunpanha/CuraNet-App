import '../../core/app_export.dart';
import '../../services/auth_service.dart';
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
  final AuthService _authService = AuthService();

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
    final reducedMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;

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
  void _navigateToNextScreen() async {
    try {
      // Check if user is logged in with timeout to prevent hanging
      final isAuthenticated = await _authService.isLoggedIn().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('Auth check timed out, assuming not logged in');
          return false;
        },
      );

      if (!mounted) return;

      if (isAuthenticated) {
        // User is logged in, go directly to dashboard
        Navigator.pushReplacementNamed(context, '/main-screen');
      } else {
        // User is not logged in, show onboarding flow
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    } catch (e) {
      print('Navigation error: $e');
      if (mounted) {
        // On error, go to onboarding (safer default)
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
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
          width: 50.w,
          height: 50.w,
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/CuraNet.png',
                    width: 45.w,
                    height: 45.w,
                    fit: BoxFit.contain,
                  ),
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
                      child: Container(color: Colors.white),
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
