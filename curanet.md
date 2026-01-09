CuraNet Mobile App - All Dart Files from Lib Folder



=== File 1: lib/core/app_export.dart ===

export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:google_fonts/google_fonts.dart';
export '../routes/app_routes.dart';
export '../widgets/custom_icon_widget.dart';
export '../widgets/custom_image_widget.dart';
export '../theme/app_theme.dart';




=== File 2: lib/main.dart ===

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  bool _hasShownError = false;


  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!_hasShownError) {
      _hasShownError = true;


      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        _hasShownError = false;
      });


      return CustomErrorWidget(
        errorDetails: details,
      );
    }
    return SizedBox.shrink();
  };


  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'curanet_mobile',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // 🚨 END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}




=== File 3: lib/presentation/authentication_screen/authentication_screen.dart ===

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/biometric_auth_card.dart';
import './widgets/email_auth_card.dart';
import './widgets/phone_auth_card.dart';
import './widgets/social_auth_card.dart';


/// Authentication Screen - Secure login with multiple methods
/// Implements biometric, phone/OTP, social, and email authentication
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});


  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}


class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isLoading = false;
  bool _biometricAttempted = false;


  @override
  void initState() {
    super.initState();
    // Attempt biometric authentication on screen load for returning users
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptBiometricAuth();
    });
  }


  /// Attempt biometric authentication automatically
  Future<void> _attemptBiometricAuth() async {
    if (_biometricAttempted) return;


    setState(() {
      _biometricAttempted = true;
    });


    // Simulate biometric check - in production, use local_auth package
    await Future.delayed(const Duration(milliseconds: 500));


    // For demo purposes, biometric fails and user can choose other methods
    // In production, successful biometric would navigate to dashboard
  }


  /// Handle biometric authentication
  Future<void> _handleBiometricAuth() async {
    setState(() => _isLoading = true);


    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));


      if (mounted) {
        // Success - navigate to dashboard
        Navigator.pushReplacementNamed(context, '/health-dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(
            'Biometric authentication failed. Please try another method.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  /// Handle phone/OTP authentication
  Future<void> _handlePhoneAuth() async {
    setState(() => _isLoading = true);


    try {
      // Simulate phone authentication flow
      await Future.delayed(const Duration(seconds: 1));


      if (mounted) {
        // In production, this would open OTP verification screen
        // For demo, directly navigate to dashboard
        Navigator.pushReplacementNamed(context, '/health-dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Phone authentication failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  /// Handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);


    try {
      // Simulate Google OAuth flow
      await Future.delayed(const Duration(seconds: 1));


      if (mounted) {
        Navigator.pushReplacementNamed(context, '/health-dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Google Sign-In failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  /// Handle Apple Sign-In (iOS) or Email Login (Android)
  Future<void> _handlePlatformAuth() async {
    setState(() => _isLoading = true);


    try {
      // Simulate platform-specific authentication
      await Future.delayed(const Duration(seconds: 1));


      if (mounted) {
        Navigator.pushReplacementNamed(context, '/health-dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(
          defaultTargetPlatform == TargetPlatform.iOS
              ? 'Apple Sign-In failed. Please try again.'
              : 'Email login failed. Please check your credentials.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  /// Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header section
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF3B8FE8),
                                const Color(0xFF00C9B7),
                              ]
                            : [
                                const Color(0xFF0066CC),
                                const Color(0xFF00A896),
                              ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // App logo
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'medical_services',
                              color: const Color(0xFF0066CC),
                              size: 10.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        // Title
                        Text(
                          'CuraNet Mobile',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Subtitle
                        Text(
                          'Secure Login',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Healthcare-grade security',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: 3.h),


                  // Authentication options
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Biometric authentication
                        BiometricAuthCard(
                          onTap: _handleBiometricAuth,
                          isLoading: _isLoading,
                        ),


                        SizedBox(height: 2.h),


                        // Phone/OTP authentication
                        PhoneAuthCard(
                          onTap: _handlePhoneAuth,
                          isLoading: _isLoading,
                        ),


                        SizedBox(height: 2.h),


                        // Social authentication options
                        SocialAuthCard(
                          provider: 'Google',
                          onTap: _handleGoogleSignIn,
                          isLoading: _isLoading,
                        ),


                        SizedBox(height: 2.h),


                        // Platform-specific authentication
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? SocialAuthCard(
                                provider: 'Apple',
                                onTap: _handlePlatformAuth,
                                isLoading: _isLoading,
                              )
                            : EmailAuthCard(
                                onTap: _handlePlatformAuth,
                                isLoading: _isLoading,
                              ),


                        SizedBox(height: 3.h),


                        // Sign up link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Navigate to sign up screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Sign up functionality coming soon'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text(
                              'New User? Sign Up',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),


                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Authenticating...',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}




=== File 4: lib/presentation/authentication_screen/widgets/biometric_auth_card.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Biometric authentication card widget
/// Displays Face ID/Touch ID option with icon and description
class BiometricAuthCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;


  const BiometricAuthCard({
    super.key,
    required this.onTap,
    required this.isLoading,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 12.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: (isDark
                          ? const Color(0xFF3B8FE8)
                          : const Color(0xFF0066CC))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'fingerprint',
                    color: isDark
                        ? const Color(0xFF3B8FE8)
                        : const Color(0xFF0066CC),
                    size: 8.w,
                  ),
                ),
              ),


              SizedBox(width: 4.w),


              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Face ID / Touch ID',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Quick and secure biometric login',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),


              SizedBox(width: 2.w),


              // Arrow icon
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




=== File 5: lib/presentation/authentication_screen/widgets/email_auth_card.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Email authentication card widget
/// Displays email/password login option for Android devices
class EmailAuthCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;


  const EmailAuthCard({
    super.key,
    required this.onTap,
    required this.isLoading,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 12.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: (isDark
                          ? const Color(0xFF60A5FA)
                          : const Color(0xFF3B82F6))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'email',
                    color: isDark
                        ? const Color(0xFF60A5FA)
                        : const Color(0xFF3B82F6),
                    size: 8.w,
                  ),
                ),
              ),


              SizedBox(width: 4.w),


              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Email Login',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Sign in with email and password',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),


              SizedBox(width: 2.w),


              // Arrow icon
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




=== File 6: lib/presentation/authentication_screen/widgets/phone_auth_card.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Phone/OTP authentication card widget
/// Displays phone number login option with country code selector
class PhoneAuthCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;


  const PhoneAuthCard({
    super.key,
    required this.onTap,
    required this.isLoading,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 12.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: (isDark
                          ? const Color(0xFF00C9B7)
                          : const Color(0xFF00A896))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'phone_android',
                    color: isDark
                        ? const Color(0xFF00C9B7)
                        : const Color(0xFF00A896),
                    size: 8.w,
                  ),
                ),
              ),


              SizedBox(width: 4.w),


              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Phone / OTP',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Login with phone number verification',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),


              SizedBox(width: 2.w),


              // Arrow icon
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




=== File 7: lib/presentation/authentication_screen/widgets/social_auth_card.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Social authentication card widget
/// Displays Google or Apple sign-in options with official branding
class SocialAuthCard extends StatelessWidget {
  final String provider; // 'Google' or 'Apple'
  final VoidCallback onTap;
  final bool isLoading;


  const SocialAuthCard({
    super.key,
    required this.provider,
    required this.onTap,
    required this.isLoading,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGoogle = provider == 'Google';


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 12.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: isGoogle
                      ? const Color(0xFFEA4335).withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isGoogle ? 'g_translate' : 'apple',
                    color: isGoogle ? const Color(0xFFEA4335) : Colors.black,
                    size: 8.w,
                  ),
                ),
              ),


              SizedBox(width: 4.w),


              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign in with $provider',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isGoogle
                          ? 'Use your Google account'
                          : 'Use your Apple ID',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),


              SizedBox(width: 2.w),


              // Arrow icon
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




=== File 8: lib/presentation/health_dashboard/health_dashboard.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/health_id_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/speed_dial_fab_widget.dart';


/// Health Dashboard - Primary hub for medical records management
/// Displays Health ID card, quick actions, and recent activity timeline
class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});


  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}


class _HealthDashboardState extends State<HealthDashboard> {
  bool _isRefreshing = false;
  int _notificationCount = 2;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header with greeting and notifications
              SliverToBoxAdapter(
                child: _buildHeader(theme),
              ),


              // Health ID Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: const HealthIdCardWidget(),
                ),
              ),


              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: const QuickActionsWidget(),
                ),
              ),


              // Recent Activity Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/medical-records-screen');
                        },
                        child: Text(
                          'View All',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              // Recent Activity Timeline
              const RecentActivityWidget(),


              // Bottom spacing for FAB
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.healthId,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.healthId) {
            Navigator.pushNamed(context, item.route);
          }
        },
        showEmergencyFab: false,
      ),
      floatingActionButton: const SpeedDialFabWidget(),
    );
  }


  /// Build header with greeting and notification bell
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Sarah Johnson',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'notifications_outlined',
                  size: 24,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _notificationCount = 0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Access requests viewed',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 4.w,
                      minHeight: 4.w,
                    ),
                    child: Center(
                      child: Text(
                        _notificationCount.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.w600,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }


  /// Handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });


    // Simulate data sync
    await Future.delayed(const Duration(seconds: 1));


    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Medical data synced successfully',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}




=== File 9: lib/presentation/health_dashboard/widgets/health_id_card_widget.dart ===

import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Health ID Card with 3D tilt effect and QR code
/// Displays patient's medical identification information
class HealthIdCardWidget extends StatelessWidget {
  const HealthIdCardWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Tilt(
      borderRadius: BorderRadius.circular(16),
      tiltConfig: const TiltConfig(
        angle: 10,
        enableGestureSensors: true,
      ),
      lightConfig: LightConfig(
        color: theme.colorScheme.primary.withValues(alpha: 0.3),
        minIntensity: 0.1,
        maxIntensity: 0.5,
      ),
      shadowConfig: ShadowConfig(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        minIntensity: 0.05,
        maxIntensity: 0.15,
      ),
      child: GestureDetector(
        onTap: () => _showFullScreenCard(context),
        onLongPress: () => _showShareOptions(context),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 25.h,
            maxHeight: 30.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardPatternPainter(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),


              // Card content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with logo and card type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'medical_services',
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'CuraNet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HEALTH ID',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: 2.h),


                    // Patient info and QR code
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile photo and info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Profile photo
                                Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: CustomImageWidget(
                                      imageUrl:
                                          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                                      width: 15.w,
                                      height: 15.w,
                                      fit: BoxFit.cover,
                                      semanticLabel:
                                          'Profile photo of Sarah Johnson, a woman with shoulder-length brown hair wearing a light blue top',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.5.h),


                                // Name
                                Text(
                                  'Sarah Johnson',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),


                                // Health ID number
                                Text(
                                  'ID: CN-2024-789456',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontFamily: 'monospace',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),


                                // Blood type and DOB
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'O+',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'DOB: 03/15/1985',
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),


                          // QR Code
                          Container(
                            width: 20.w,
                            height: 20.w,
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomImageWidget(
                              imageUrl:
                                  'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=CN-2024-789456',
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.contain,
                              semanticLabel:
                                  'QR code containing health ID CN-2024-789456 for quick scanning',
                            ),
                          ),
                        ],
                      ),
                    ),


                    // Footer with verified badge
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'verified',
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Verified Health ID',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Show full-screen card view
  void _showFullScreenCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HealthIdCardWidget(),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Show share options
  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'share',
                size: 24,
              ),
              title: const Text('Share Health ID'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health ID shared successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'download',
                size: 24,
              ),
              title: const Text('Download as Image'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health ID downloaded'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/// Custom painter for card background pattern
class _CardPatternPainter extends CustomPainter {
  final Color color;


  _CardPatternPainter({required this.color});


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;


    // Draw grid pattern
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }


    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




=== File 10: lib/presentation/health_dashboard/widgets/quick_actions_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Quick action buttons for common medical tasks
/// Provides thumb-friendly access to key features
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    final actions = [
      _QuickAction(
        icon: 'add_circle_outline',
        label: 'Add Record',
        color: theme.colorScheme.primary,
        onTap: () => _handleAddRecord(context),
      ),
      _QuickAction(
        icon: 'calendar_today',
        label: 'Schedule',
        color: theme.colorScheme.secondary,
        onTap: () => _handleSchedule(context),
      ),
      _QuickAction(
        icon: 'emergency',
        label: 'Emergency',
        color: theme.colorScheme.error,
        onTap: () => _handleEmergency(context),
      ),
      _QuickAction(
        icon: 'qr_code',
        label: 'Share ID',
        color: theme.colorScheme.tertiary,
        onTap: () => _handleShareId(context),
      ),
    ];


    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: _buildActionButton(context, action, theme),
            ),
          );
        }).toList(),
      ),
    );
  }


  /// Build individual action button
  Widget _buildActionButton(
    BuildContext context,
    _QuickAction action,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: action.color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: action.icon,
                    size: 24,
                    color: action.color,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                action.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Handle add record action
  void _handleAddRecord(BuildContext context) {
    Navigator.pushNamed(context, '/medical-records-screen');
  }


  /// Handle schedule appointment action
  void _handleSchedule(BuildContext context) {
    Navigator.pushNamed(context, '/patient-record-view');
  }


  /// Handle emergency SOS action
  void _handleEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              size: 24,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: 2.w),
            const Text('Emergency SOS'),
          ],
        ),
        content: const Text(
          'This will share your location and medical information with emergency contacts. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Emergency alert sent to contacts'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Activate SOS'),
          ),
        ],
      ),
    );
  }


  /// Handle share health ID action
  void _handleShareId(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Health ID',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'qr_code_scanner',
                size: 24,
              ),
              title: const Text('Show QR Code'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR code displayed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'share',
                size: 24,
              ),
              title: const Text('Share via Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health ID link copied'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/// Quick action data model
class _QuickAction {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;


  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}




=== File 11: lib/presentation/health_dashboard/widgets/recent_activity_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Recent activity timeline showing medical record updates
/// Displays chronological feed with swipe-to-archive functionality
class RecentActivityWidget extends StatefulWidget {
  const RecentActivityWidget({super.key});


  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}


class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  final List<Map<String, dynamic>> _activities = [
    {
      "id": 1,
      "type": "record_upload",
      "title": "Lab Results Uploaded",
      "description":
          "Complete Blood Count (CBC) test results from City Hospital",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "icon": "science",
      "color": "primary",
      "category": "Lab",
    },
    {
      "id": 2,
      "type": "access_grant",
      "title": "Access Granted",
      "description": "Dr. Michael Chen can now view your medical records",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "icon": "verified_user",
      "color": "success",
      "category": "Access",
    },
    {
      "id": 3,
      "type": "appointment",
      "title": "Upcoming Appointment",
      "description": "Cardiology consultation with Dr. Sarah Williams",
      "timestamp": DateTime.now().add(const Duration(days: 2)),
      "icon": "event",
      "color": "secondary",
      "category": "Appointment",
    },
    {
      "id": 4,
      "type": "record_upload",
      "title": "Prescription Added",
      "description": "Medication prescription for hypertension management",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "icon": "medication",
      "color": "tertiary",
      "category": "Prescription",
    },
    {
      "id": 5,
      "type": "record_upload",
      "title": "X-Ray Imaging",
      "description": "Chest X-ray imaging uploaded from Radiology Center",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "icon": "medical_services",
      "color": "primary",
      "category": "Imaging",
    },
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final activity = _activities[index];
          return Dismissible(
            key: Key(activity["id"].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 4.w),
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'archive',
                size: 24,
                color: theme.colorScheme.error,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                _activities.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${activity["title"]} archived',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _activities.insert(index, activity);
                      });
                    },
                  ),
                ),
              );
            },
            child: _buildActivityItem(context, activity, theme),
          );
        },
        childCount: _activities.length,
      ),
    );
  }


  /// Build individual activity item
  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    ThemeData theme,
  ) {
    final Color activityColor = _getActivityColor(
      activity["color"] as String,
      theme,
    );


    return Container(
      margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleActivityTap(context, activity),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: activityColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: activity["icon"] as String,
                      size: 20,
                      color: activityColor,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),


                // Activity details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              activity["title"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: activityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              activity["category"] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: activityColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        activity["description"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatTimestamp(activity["timestamp"] as DateTime),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  /// Get activity color based on type
  Color _getActivityColor(String colorType, ThemeData theme) {
    switch (colorType) {
      case 'primary':
        return theme.colorScheme.primary;
      case 'secondary':
        return theme.colorScheme.secondary;
      case 'tertiary':
        return theme.colorScheme.tertiary;
      case 'success':
        return const Color(0xFF10B981);
      case 'error':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }


  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = timestamp.difference(now);


    if (difference.isNegative) {
      final absDifference = difference.abs();
      if (absDifference.inMinutes < 60) {
        return '${absDifference.inMinutes}m ago';
      } else if (absDifference.inHours < 24) {
        return '${absDifference.inHours}h ago';
      } else {
        return '${absDifference.inDays}d ago';
      }
    } else {
      if (difference.inHours < 24) {
        return 'In ${difference.inHours}h';
      } else {
        return 'In ${difference.inDays}d';
      }
    }
  }


  /// Handle activity item tap
  void _handleActivityTap(BuildContext context, Map<String, dynamic> activity) {
    final type = activity["type"] as String;


    if (type == "record_upload") {
      Navigator.pushNamed(context, '/medical-records-screen');
    } else if (type == "appointment") {
      Navigator.pushNamed(context, '/patient-record-view');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Viewing ${activity["title"]}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}




=== File 12: lib/presentation/health_dashboard/widgets/speed_dial_fab_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Speed dial floating action button for quick actions
/// Provides camera scan, voice input, and manual entry options
class SpeedDialFabWidget extends StatefulWidget {
  const SpeedDialFabWidget({super.key});


  @override
  State<SpeedDialFabWidget> createState() => _SpeedDialFabWidgetState();
}


class _SpeedDialFabWidgetState extends State<SpeedDialFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;


  final List<_SpeedDialAction> _actions = [
    _SpeedDialAction(
      icon: 'camera_alt',
      label: 'Camera Scan',
      color: const Color(0xFF0066CC),
    ),
    _SpeedDialAction(
      icon: 'mic',
      label: 'Voice Input',
      color: const Color(0xFF00A896),
    ),
    _SpeedDialAction(
      icon: 'edit',
      label: 'Manual Entry',
      color: const Color(0xFF3B82F6),
    ),
  ];


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );


    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.75,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));


    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  void _toggleSpeedDial() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleSpeedDial,
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),


        // Speed dial actions
        ..._actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return _buildSpeedDialItem(
            context,
            action,
            index,
            theme,
          );
        }),


        // Main FAB
        Padding(
          padding: EdgeInsets.all(4.w),
          child: FloatingActionButton(
            onPressed: _toggleSpeedDial,
            backgroundColor: theme.colorScheme.primary,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'close' : 'add',
                    size: 28,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  /// Build individual speed dial action item
  Widget _buildSpeedDialItem(
    BuildContext context,
    _SpeedDialAction action,
    int index,
    ThemeData theme,
  ) {
    final offset = (index + 1) * 70.0;


    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(0, -offset * _scaleAnimation.value),
            child: Padding(
              padding: EdgeInsets.only(right: 4.w, bottom: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Label
                  Material(
                    color: theme.colorScheme.surface,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      child: Text(
                        action.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),


                  // Action button
                  FloatingActionButton(
                    mini: true,
                    onPressed: () => _handleActionTap(context, action),
                    backgroundColor: action.color,
                    child: CustomIconWidget(
                      iconName: action.icon,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  /// Handle speed dial action tap
  void _handleActionTap(BuildContext context, _SpeedDialAction action) {
    _toggleSpeedDial();


    String message;
    switch (action.label) {
      case 'Camera Scan':
        message = 'Opening camera for document scanning...';
        break;
      case 'Voice Input':
        message = 'Voice input activated. Start speaking...';
        break;
      case 'Manual Entry':
        message = 'Opening manual entry form...';
        Navigator.pushNamed(context, '/medical-records-screen');
        return;
      default:
        message = '${action.label} activated';
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: action.color,
      ),
    );
  }
}


/// Speed dial action data model
class _SpeedDialAction {
  final String icon;
  final String label;
  final Color color;


  _SpeedDialAction({
    required this.icon,
    required this.label,
    required this.color,
  });
}




=== File 13: lib/presentation/medical_records_screen/medical_records_screen.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/medical_record_card_widget.dart';


/// Medical Records Screen - Comprehensive health record management
/// Supports timeline and grid views with advanced filtering
class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});


  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}


class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with TickerProviderStateMixin {
  // View mode toggle
  bool _isTimelineView = true;


  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  Set<String> _activeFilters = {};
  DateTimeRange? _dateRange;
  bool _showVerifiedOnly = false;


  // Refresh indicator
  bool _isRefreshing = false;


  // Mock medical records data
  final List<Map<String, dynamic>> _medicalRecords = [
    {
      "id": "1",
      "title": "Complete Blood Count (CBC)",
      "category": "Lab Results",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "thumbnail":
          "https://images.unsplash.com/photo-1705341964227-5105cfe8f82a",
      "semanticLabel":
          "Medical laboratory test results document with blood sample vials in background",
      "verified": true,
      "doctor": "Dr. Sarah Johnson",
      "facility": "City Medical Center",
      "description": "Routine blood work showing normal hemoglobin levels",
    },
    {
      "id": "2",
      "title": "Chest X-Ray Report",
      "category": "Imaging",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "thumbnail":
          "https://img.rocket.new/generatedImages/rocket_gen_img_17437f05f-1764703839638.png",
      "semanticLabel": "Chest X-ray radiograph showing clear lung fields",
      "verified": true,
      "doctor": "Dr. Michael Chen",
      "facility": "Radiology Associates",
      "description": "Clear lung fields, no abnormalities detected",
    },
    {
      "id": "3",
      "title": "Prescription - Amoxicillin",
      "category": "Prescriptions",
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "thumbnail":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1afc455cf-1765145409373.png",
      "semanticLabel":
          "Prescription medication bottle with white pills on medical document",
      "verified": true,
      "doctor": "Dr. Emily Rodriguez",
      "facility": "Family Health Clinic",
      "description": "500mg, 3 times daily for 7 days",
    },
    {
      "id": "4",
      "title": "Annual Physical Exam",
      "category": "Reports",
      "date": DateTime.now().subtract(const Duration(days: 30)),
      "thumbnail":
          "https://img.rocket.new/generatedImages/rocket_gen_img_12207411d-1765106903442.png",
      "semanticLabel":
          "Medical stethoscope on patient health examination report",
      "verified": true,
      "doctor": "Dr. James Wilson",
      "facility": "Wellness Medical Group",
      "description": "Comprehensive health assessment - all vitals normal",
    },
    {
      "id": "5",
      "title": "Lipid Panel Results",
      "category": "Lab Results",
      "date": DateTime.now().subtract(const Duration(days: 45)),
      "thumbnail":
          "https://img.rocket.new/generatedImages/rocket_gen_img_10d5df712-1765030396947.png",
      "semanticLabel":
          "Laboratory blood test tubes with cholesterol test results",
      "verified": false,
      "doctor": "Dr. Sarah Johnson",
      "facility": "City Medical Center",
      "description": "Cholesterol levels within normal range",
    },
    {
      "id": "6",
      "title": "MRI Scan - Knee",
      "category": "Imaging",
      "date": DateTime.now().subtract(const Duration(days: 60)),
      "thumbnail":
          "https://img.rocket.new/generatedImages/rocket_gen_img_165b2f345-1765118577209.png",
      "semanticLabel": "MRI scan image showing knee joint structure",
      "verified": true,
      "doctor": "Dr. Robert Martinez",
      "facility": "Advanced Imaging Center",
      "description": "Minor cartilage wear, no significant damage",
    },
  ];


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  // Filter records based on search, filters, and date range
  List<Map<String, dynamic>> get _filteredRecords {
    return _medicalRecords.where((record) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        final searchLower = _searchController.text.toLowerCase();
        final titleMatch =
            (record["title"] as String).toLowerCase().contains(searchLower);
        final categoryMatch =
            (record["category"] as String).toLowerCase().contains(searchLower);
        final doctorMatch =
            (record["doctor"] as String).toLowerCase().contains(searchLower);
        if (!titleMatch && !categoryMatch && !doctorMatch) return false;
      }


      // Category filter
      if (_activeFilters.isNotEmpty &&
          !_activeFilters.contains(record["category"])) {
        return false;
      }


      // Date range filter
      if (_dateRange != null) {
        final recordDate = record["date"] as DateTime;
        if (recordDate.isBefore(_dateRange!.start) ||
            recordDate.isAfter(_dateRange!.end)) {
          return false;
        }
      }


      // Verification filter
      if (_showVerifiedOnly && !(record["verified"] as bool)) {
        return false;
      }


      return true;
    }).toList();
  }


  // Group records by date for timeline view
  Map<String, List<Map<String, dynamic>>> get _groupedByDate {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var record in _filteredRecords) {
      final date = record["date"] as DateTime;
      final dateKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(record);
    }
    return grouped;
  }


  // Group records by category for grid view
  Map<String, List<Map<String, dynamic>>> get _groupedByCategory {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var record in _filteredRecords) {
      final category = record["category"] as String;
      grouped.putIfAbsent(category, () => []);
      grouped[category]!.add(record);
    }
    return grouped;
  }


  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }


  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        activeFilters: _activeFilters,
        dateRange: _dateRange,
        showVerifiedOnly: _showVerifiedOnly,
        onApplyFilters: (filters, dateRange, verifiedOnly) {
          setState(() {
            _activeFilters = filters;
            _dateRange = dateRange;
            _showVerifiedOnly = verifiedOnly;
          });
        },
      ),
    );
  }


  void _openRecordDetail(Map<String, dynamic> record) {
    // Navigate to document viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening ${record["title"]}',
          style: const TextStyle(fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }


  void _showCameraScanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Camera scanner opening...',
          style: TextStyle(fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header with search and filters
            _buildStickyHeader(theme),


            // View toggle (Timeline/Grid)
            _buildViewToggle(theme),


            // Content area
            Expanded(
              child: _filteredRecords.isEmpty
                  ? EmptyStateWidget(
                      category:
                          _activeFilters.isEmpty ? null : _activeFilters.first,
                      onAddRecord: _showCameraScanner,
                    )
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      color: theme.colorScheme.primary,
                      child: _isTimelineView
                          ? _buildTimelineView(theme)
                          : _buildGridView(theme),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.records,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.records) {
            Navigator.pushNamed(context, item.route);
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCameraScanner,
        backgroundColor: theme.colorScheme.primary,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Scan',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }


  Widget _buildStickyHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Medical Records',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),


          // Search bar
          Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search records...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'mic',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voice input activated'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
            ),
          ),
          SizedBox(height: 1.h),


          // Filter button
          InkWell(
            onTap: _showFilterModal,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _activeFilters.isNotEmpty ||
                        _dateRange != null ||
                        _showVerifiedOnly
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'filter_list',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Filters',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_activeFilters.isNotEmpty ||
                      _dateRange != null ||
                      _showVerifiedOnly) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_activeFilters.length + (_dateRange != null ? 1 : 0) + (_showVerifiedOnly ? 1 : 0)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildViewToggle(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _isTimelineView = true),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: _isTimelineView
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isTimelineView
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'view_timeline',
                      color: _isTimelineView
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Timeline',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _isTimelineView
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _isTimelineView = false),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: !_isTimelineView
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: !_isTimelineView
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'grid_view',
                      color: !_isTimelineView
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Grid',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: !_isTimelineView
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTimelineView(ThemeData theme) {
    final groupedRecords = _groupedByDate;
    final sortedDates = groupedRecords.keys.toList()
      ..sort((a, b) => b.compareTo(a));


    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final records = groupedRecords[dateKey]!;
        final date = records.first["date"] as DateTime;


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Text(
                _formatDateHeader(date),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),


            // Records for this date
            ...records.map((record) => Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: MedicalRecordCardWidget(
                    record: record,
                    onTap: () => _openRecordDetail(record),
                  ),
                )),
          ],
        );
      },
    );
  }


  Widget _buildGridView(ThemeData theme) {
    final groupedRecords = _groupedByCategory;
    final categories = groupedRecords.keys.toList();


    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final records = groupedRecords[category]!;


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _getCategoryIcon(category),
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    category,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${records.length}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),


            // Grid of records
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 0.85,
              ),
              itemCount: records.length,
              itemBuilder: (context, recordIndex) {
                return MedicalRecordCardWidget(
                  record: records[recordIndex],
                  onTap: () => _openRecordDetail(records[recordIndex]),
                  isGridView: true,
                );
              },
            ),


            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }


  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final recordDate = DateTime(date.year, date.month, date.day);


    if (recordDate == today) {
      return 'Today';
    } else if (recordDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }


  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Lab Results':
        return 'science';
      case 'Prescriptions':
        return 'medication';
      case 'Imaging':
        return 'medical_services';
      case 'Reports':
        return 'description';
      default:
        return 'folder';
    }
  }
}




=== File 14: lib/presentation/medical_records_screen/widgets/empty_state_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Empty state widget for medical records
class EmptyStateWidget extends StatelessWidget {
  final String? category;
  final VoidCallback onAddRecord;


  const EmptyStateWidget({
    super.key,
    this.category,
    required this.onAddRecord,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            CustomIconWidget(
              iconName: _getEmptyStateIcon(),
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              size: 30.w,
            ),
            SizedBox(height: 3.h),


            // Title
            Text(
              _getEmptyStateTitle(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),


            // Description
            Text(
              _getEmptyStateDescription(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),


            // Add button
            ElevatedButton.icon(
              onPressed: onAddRecord,
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Add First Record',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getEmptyStateIcon() {
    if (category == null) return 'folder_open';
    switch (category) {
      case 'Lab Results':
        return 'science';
      case 'Prescriptions':
        return 'medication';
      case 'Imaging':
        return 'medical_services';
      case 'Reports':
        return 'description';
      default:
        return 'folder_open';
    }
  }


  String _getEmptyStateTitle() {
    if (category == null) return 'No Medical Records';
    return 'No $category Found';
  }


  String _getEmptyStateDescription() {
    if (category == null) {
      return 'Start building your health history by adding your first medical record';
    }
    return 'Add your first ${category!.toLowerCase()} to start tracking your health data';
  }
}




=== File 15: lib/presentation/medical_records_screen/widgets/filter_modal_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Filter modal for medical records
class FilterModalWidget extends StatefulWidget {
  final Set<String> activeFilters;
  final DateTimeRange? dateRange;
  final bool showVerifiedOnly;
  final Function(Set<String>, DateTimeRange?, bool) onApplyFilters;


  const FilterModalWidget({
    super.key,
    required this.activeFilters,
    required this.dateRange,
    required this.showVerifiedOnly,
    required this.onApplyFilters,
  });


  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}


class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Set<String> _selectedCategories;
  late DateTimeRange? _selectedDateRange;
  late bool _verifiedOnly;


  final List<String> _categories = [
    'Lab Results',
    'Prescriptions',
    'Imaging',
    'Reports',
  ];


  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.activeFilters);
    _selectedDateRange = widget.dateRange;
    _verifiedOnly = widget.showVerifiedOnly;
  }


  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );


    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }


  void _clearAllFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedDateRange = null;
      _verifiedOnly = false;
    });
  }


  void _applyFilters() {
    widget.onApplyFilters(
      _selectedCategories,
      _selectedDateRange,
      _verifiedOnly,
    );
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),


            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Text(
                    'Filters',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Divider(
              color: theme.colorScheme.outline,
              height: 1,
            ),


            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category filters
                    Text(
                      'Categories',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ..._categories.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                        title: Text(
                          category,
                          style: theme.textTheme.bodyMedium,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),


                    SizedBox(height: 2.h),


                    // Date range
                    Text(
                      'Date Range',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    InkWell(
                      onTap: _selectDateRange,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'date_range',
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _selectedDateRange == null
                                    ? 'Select date range'
                                    : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: _selectedDateRange == null
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (_selectedDateRange != null)
                              IconButton(
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() => _selectedDateRange = null);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 2.h),


                    // Verification status
                    Text(
                      'Verification Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    SwitchListTile(
                      value: _verifiedOnly,
                      onChanged: (value) {
                        setState(() => _verifiedOnly = value);
                      },
                      title: Text(
                        'Show verified records only',
                        style: theme.textTheme.bodyMedium,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),


                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),


            // Apply button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}




=== File 16: lib/presentation/medical_records_screen/widgets/medical_record_card_widget.dart ===

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Medical record card widget with swipe actions
class MedicalRecordCardWidget extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onTap;
  final bool isGridView;


  const MedicalRecordCardWidget({
    super.key,
    required this.record,
    required this.onTap,
    this.isGridView = false,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return isGridView ? _buildGridCard(theme) : _buildTimelineCard(theme);
  }


  Widget _buildTimelineCard(ThemeData theme) {
    return Slidable(
      key: ValueKey(record["id"]),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing ${record["title"]}'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.share_rounded,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Archived ${record["title"]}'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.archive_rounded,
            label: 'Archive',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: record["thumbnail"] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                  semanticLabel: record["semanticLabel"] as String,
                ),
              ),
              SizedBox(width: 3.w),


              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with verification badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            record["title"] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (record["verified"] as bool) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'verified',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.5.h),


                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        record["category"] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),


                    // Doctor and facility
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            record["doctor"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),


                    // Date
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _formatDate(record["date"] as DateTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              // Arrow icon
              CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildGridCard(ThemeData theme) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: record["thumbnail"] as String,
                width: double.infinity,
                height: 15.h,
                fit: BoxFit.cover,
                semanticLabel: record["semanticLabel"] as String,
              ),
            ),


            // Content
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with verification
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          record["title"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (record["verified"] as bool)
                        CustomIconWidget(
                          iconName: 'verified',
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                    ],
                  ),
                  SizedBox(height: 1.h),


                  // Date
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          _formatDate(record["date"] as DateTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}




=== File 17: lib/presentation/onboarding_flow/onboarding_flow.dart ===

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import './widgets/onboarding_slide_widget.dart';


/// Onboarding Flow screen that introduces new users to the unified health identity platform
/// Implements 4-slide carousel with swipe gestures and skip functionality
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});


  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}


class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  // Onboarding slide data
  final List<Map<String, dynamic>> _slides = [
    {
      "title": "Your Health Records,\nScattered Everywhere",
      "description":
          "Medical records spread across multiple hospitals, clinics, and labs. Finding the right document when you need it most is a nightmare.",
      "imageUrl":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1bd0cc829-1764863494841.png",
      "semanticLabel":
          "Medical documents and files scattered across a desk with stethoscope and clipboard, representing fragmented health records",
      "backgroundColor": Color(0xFFE8F5F3),
    },
    {
      "title": "One Health ID,\nAll Your Records",
      "description":
          "Unified lifetime health identity that consolidates all medical records in one secure mobile app. Access everything instantly with a single tap.",
      "imageUrl":
          "https://images.unsplash.com/photo-1592392513912-fd639ff32e98",
      "semanticLabel":
          "Modern smartphone displaying digital health ID card with QR code and medical cross symbol on clean white background",
      "backgroundColor": Color(0xFFE8F5F3),
    },
    {
      "title": "You Control\nWho Sees What",
      "description":
          "Granular access control lets you decide exactly which records to share with healthcare providers. Approve or deny access requests in real-time.",
      "imageUrl":
          "https://img.rocket.new/generatedImages/rocket_gen_img_15af4787e-1764671673883.png",
      "semanticLabel":
          "Digital interface showing privacy controls with toggle switches and permission settings for medical data sharing",
      "backgroundColor": Color(0xFFE8F5F3),
    },
    {
      "title": "Trusted by Healthcare\nProfessionals",
      "description":
          "HIPAA compliant platform trusted by leading hospitals and clinics. Your health data is encrypted and secured with medical-grade protection.",
      "imageUrl":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1e4eeb096-1764668845076.png",
      "semanticLabel":
          "Healthcare professionals in white coats reviewing digital medical records on tablet in modern hospital setting",
      "backgroundColor": Color(0xFFE8F5F3),
    },
  ];


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }


  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/authentication-screen');
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: isDark
                          ? const Color(0xFF3B8FE8)
                          : const Color(0xFF0066CC),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Skip',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isDark
                            ? const Color(0xFF3B8FE8)
                            : const Color(0xFF0066CC),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // Page view with slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(
                    title: _slides[index]["title"] as String,
                    description: _slides[index]["description"] as String,
                    imageUrl: _slides[index]["imageUrl"] as String,
                    semanticLabel: _slides[index]["semanticLabel"] as String,
                    backgroundColor: _slides[index]["backgroundColor"] as Color,
                  );
                },
              ),
            ),


            // Bottom section with indicators and button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Page indicators
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: isDark
                          ? const Color(0xFF3B8FE8)
                          : const Color(0xFF0066CC),
                      dotColor: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                      spacing: 8,
                    ),
                  ),


                  const SizedBox(height: 32),


                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF3B8FE8)
                            : const Color(0xFF0066CC),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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




=== File 18: lib/presentation/onboarding_flow/widgets/onboarding_slide_widget.dart ===

import 'package:flutter/material.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';


/// Individual onboarding slide widget
/// Displays title, description, and illustration for each onboarding step
class OnboardingSlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String semanticLabel;
  final Color backgroundColor;


  const OnboardingSlideWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.semanticLabel,
    required this.backgroundColor,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),


            // Illustration
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                  semanticLabel: semanticLabel,
                ),
              ),
            ),


            const SizedBox(height: 48),


            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color:
                    isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                height: 1.2,
              ),
            ),


            const SizedBox(height: 16),


            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color:
                    isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),


            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}




=== File 19: lib/presentation/patient_record_view/patient_record_view.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/overview_tab_widget.dart';
import './widgets/patient_header_widget.dart';
import './widgets/patient_tabs_widget.dart';
import './widgets/prescription_writer_widget.dart';
import './widgets/prescriptions_tab_widget.dart';
import './widgets/records_tab_widget.dart';
import './widgets/vitals_tab_widget.dart';


/// Patient Record View Screen
/// Healthcare provider interface for accessing comprehensive patient medical history
/// with prescription writing capabilities and audit logging
class PatientRecordView extends StatefulWidget {
  const PatientRecordView({super.key});


  @override
  State<PatientRecordView> createState() => _PatientRecordViewState();
}


class _PatientRecordViewState extends State<PatientRecordView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showPrescriptionWriter = false;
  String _selectedPatientId = 'P-2024-001';
  String _selectedPatientName = 'Sarah Johnson';


  // Mock patient data
  final Map<String, dynamic> _patientData = {
    "patientId": "P-2024-001",
    "healthId": "ABHA-1234-5678-9012",
    "name": "Sarah Johnson",
    "age": 34,
    "gender": "Female",
    "bloodGroup": "O+",
    "phone": "+1 (555) 123-4567",
    "email": "sarah.johnson@email.com",
    "address": "123 Medical Plaza, Suite 400, New York, NY 10001",
    "profilePhoto":
        "https://img.rocket.new/generatedImages/rocket_gen_img_103b528db-1763293982935.png",
    "semanticLabel":
        "Professional headshot of a woman with long brown hair wearing a white blouse",
    "insurance": {
      "provider": "Blue Cross Blue Shield",
      "policyNumber": "BCBS-789456123",
      "validUntil": "2025-12-31"
    },
    "emergencyContact": {
      "name": "Michael Johnson",
      "relationship": "Spouse",
      "phone": "+1 (555) 987-6543"
    },
    "allergies": [
      {"name": "Penicillin", "severity": "High", "reaction": "Anaphylaxis"},
      {"name": "Latex", "severity": "Moderate", "reaction": "Skin rash"}
    ],
    "conditions": [
      {"name": "Type 2 Diabetes", "diagnosedDate": "2020-03-15"},
      {"name": "Hypertension", "diagnosedDate": "2019-08-22"}
    ],
    "currentMedications": [
      {
        "name": "Metformin",
        "dosage": "500mg",
        "frequency": "Twice daily",
        "prescribedBy": "Dr. Emily Chen",
        "startDate": "2020-03-15"
      },
      {
        "name": "Lisinopril",
        "dosage": "10mg",
        "frequency": "Once daily",
        "prescribedBy": "Dr. Robert Martinez",
        "startDate": "2019-08-22"
      }
    ],
    "recentVisits": [
      {
        "date": "2024-12-05",
        "type": "Follow-up",
        "provider": "Dr. Emily Chen",
        "department": "Endocrinology",
        "chiefComplaint": "Diabetes management review",
        "diagnosis": "Type 2 Diabetes - Well controlled",
        "notes":
            "Patient reports good adherence to medication. Blood glucose levels within target range.",
        "attachments": [
          {
            "type": "Lab Report",
            "name": "HbA1c Test Results",
            "url":
                "https://img.rocket.new/generatedImages/rocket_gen_img_1e6a6c261-1764677438459.png",
            "semanticLabel":
                "Medical laboratory report showing blood test results on white paper"
          }
        ]
      },
      {
        "date": "2024-11-20",
        "type": "Consultation",
        "provider": "Dr. Robert Martinez",
        "department": "Cardiology",
        "chiefComplaint": "Blood pressure monitoring",
        "diagnosis": "Hypertension - Stable",
        "notes":
            "Blood pressure readings improved. Continue current medication regimen.",
        "attachments": []
      }
    ],
    "vitalHistory": [
      {
        "date": "2024-12-05",
        "bloodPressure": "128/82",
        "heartRate": 72,
        "temperature": 98.4,
        "weight": 165,
        "height": 66,
        "bmi": 26.6,
        "oxygenSaturation": 98
      },
      {
        "date": "2024-11-20",
        "bloodPressure": "132/85",
        "heartRate": 75,
        "temperature": 98.6,
        "weight": 167,
        "height": 66,
        "bmi": 26.9,
        "oxygenSaturation": 97
      },
      {
        "date": "2024-11-05",
        "bloodPressure": "135/88",
        "heartRate": 78,
        "temperature": 98.5,
        "weight": 168,
        "height": 66,
        "bmi": 27.1,
        "oxygenSaturation": 98
      }
    ],
    "medicalRecords": [
      {
        "id": "REC-001",
        "date": "2024-12-05",
        "type": "Lab Report",
        "category": "Laboratory",
        "title": "HbA1c Test Results",
        "provider": "Dr. Emily Chen",
        "department": "Endocrinology",
        "imageUrl":
            "https://img.rocket.new/generatedImages/rocket_gen_img_1e6a6c261-1764677438459.png",
        "semanticLabel":
            "Medical laboratory report showing blood test results on white paper",
        "providerNotes":
            "HbA1c level at 6.8% shows excellent diabetes control. Patient maintaining target range.",
        "internalNotes":
            "Consider reducing follow-up frequency to quarterly visits if control remains stable."
      },
      {
        "id": "REC-002",
        "date": "2024-11-20",
        "type": "ECG Report",
        "category": "Imaging",
        "title": "Electrocardiogram",
        "provider": "Dr. Robert Martinez",
        "department": "Cardiology",
        "imageUrl":
            "https://images.unsplash.com/photo-1724395261682-c8b152dc5b9b",
        "semanticLabel":
            "Electrocardiogram printout showing heart rhythm waves on graph paper",
        "providerNotes":
            "Normal sinus rhythm. No significant abnormalities detected.",
        "internalNotes": "Patient cleared for moderate exercise program."
      },
      {
        "id": "REC-003",
        "date": "2024-10-15",
        "type": "Prescription",
        "category": "Prescription",
        "title": "Medication Renewal",
        "provider": "Dr. Emily Chen",
        "department": "Endocrinology",
        "imageUrl":
            "https://img.rocket.new/generatedImages/rocket_gen_img_10c420ab1-1764667685453.png",
        "semanticLabel":
            "Medical prescription form with handwritten medication details",
        "providerNotes": "Renewed Metformin 500mg for 90 days supply.",
        "internalNotes": "Patient requested mail-order pharmacy option."
      }
    ],
    "prescriptionHistory": [
      {
        "id": "RX-001",
        "date": "2024-12-05",
        "medication": "Metformin",
        "dosage": "500mg",
        "frequency": "Twice daily with meals",
        "duration": "90 days",
        "quantity": 180,
        "refills": 3,
        "prescribedBy": "Dr. Emily Chen",
        "pharmacy": "CVS Pharmacy - Main Street",
        "status": "Active",
        "notes": "Take with food to minimize gastrointestinal side effects"
      },
      {
        "id": "RX-002",
        "date": "2024-11-20",
        "medication": "Lisinopril",
        "dosage": "10mg",
        "frequency": "Once daily in morning",
        "duration": "90 days",
        "quantity": 90,
        "refills": 3,
        "prescribedBy": "Dr. Robert Martinez",
        "pharmacy": "CVS Pharmacy - Main Street",
        "status": "Active",
        "notes": "Monitor blood pressure regularly"
      },
      {
        "id": "RX-003",
        "date": "2024-08-15",
        "medication": "Atorvastatin",
        "dosage": "20mg",
        "frequency": "Once daily at bedtime",
        "duration": "90 days",
        "quantity": 90,
        "refills": 0,
        "prescribedBy": "Dr. Robert Martinez",
        "pharmacy": "CVS Pharmacy - Main Street",
        "status": "Completed",
        "notes": "Discontinued due to muscle pain side effects"
      }
    ],
    "auditLog": [
      {
        "timestamp": "2024-12-08 07:45:00",
        "action": "Viewed patient record",
        "provider": "Dr. Emily Chen",
        "department": "Endocrinology",
        "ipAddress": "192.168.1.100"
      },
      {
        "timestamp": "2024-12-05 14:30:00",
        "action": "Added lab results",
        "provider": "Dr. Emily Chen",
        "department": "Endocrinology",
        "ipAddress": "192.168.1.100"
      },
      {
        "timestamp": "2024-11-20 10:15:00",
        "action": "Prescribed medication",
        "provider": "Dr. Robert Martinez",
        "department": "Cardiology",
        "ipAddress": "192.168.1.105"
      }
    ]
  };


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


  void _togglePrescriptionWriter() {
    setState(() {
      _showPrescriptionWriter = !_showPrescriptionWriter;
    });
  }


  void _handleEmergencyOverride() {
    showDialog(
      context: context,
      builder: (context) => _buildEmergencyOverrideDialog(),
    );
  }


  void _handleShare() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing patient record with selected providers',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  void _handleEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => _buildEmergencyContactDialog(),
    );
  }


  Widget _buildEmergencyOverrideDialog() {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'emergency',
            color: theme.colorScheme.error,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            'Emergency Override',
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This action will bypass normal permission workflows and grant immediate access to all patient records.',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'All actions will be logged in the audit trail',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Emergency override activated'),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          child: Text('Activate Override'),
        ),
      ],
    );
  }


  Widget _buildEmergencyContactDialog() {
    final theme = Theme.of(context);
    final emergencyContact =
        _patientData['emergencyContact'] as Map<String, dynamic>;


    return AlertDialog(
      title: Text(
        'Emergency Contact',
        style: theme.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactInfoRow(
            theme,
            'person',
            'Name',
            emergencyContact['name'] as String,
          ),
          SizedBox(height: 2.h),
          _buildContactInfoRow(
            theme,
            'family_restroom',
            'Relationship',
            emergencyContact['relationship'] as String,
          ),
          SizedBox(height: 2.h),
          _buildContactInfoRow(
            theme,
            'phone',
            'Phone',
            emergencyContact['phone'] as String,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Calling emergency contact...'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          },
          child: Text('Call Now'),
        ),
      ],
    );
  }


  Widget _buildContactInfoRow(
      ThemeData theme, String iconName, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.recordDetail,
        title: _selectedPatientName,
        subtitle: 'Health ID: ${_patientData['healthId']}',
        onShare: _handleShare,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: theme.colorScheme.error,
              size: 24,
            ),
            onPressed: _handleEmergencyOverride,
            tooltip: 'Emergency Override',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'contact_emergency',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _handleEmergencyContact,
            tooltip: 'Emergency Contact',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Patient Header
              PatientHeaderWidget(patientData: _patientData),


              // Tabs
              PatientTabsWidget(tabController: _tabController),


              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    OverviewTabWidget(patientData: _patientData),
                    RecordsTabWidget(patientData: _patientData),
                    VitalsTabWidget(patientData: _patientData),
                    PrescriptionsTabWidget(patientData: _patientData),
                  ],
                ),
              ),
            ],
          ),


          // Prescription Writer Overlay
          if (_showPrescriptionWriter)
            PrescriptionWriterWidget(
              patientData: _patientData,
              onClose: _togglePrescriptionWriter,
            ),
        ],
      ),
      floatingActionButton: !_showPrescriptionWriter
          ? FloatingActionButton.extended(
              onPressed: _togglePrescriptionWriter,
              icon: CustomIconWidget(
                iconName: 'edit_note',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Write Prescription',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
      bottomNavigationBar: CustomProviderBottomBar(
        currentIndex: 1,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/health-dashboard');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/patient-record-view');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/authentication-screen');
          }
        },
      ),
    );
  }
}




=== File 20: lib/presentation/patient_record_view/widgets/overview_tab_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Overview tab widget displaying patient summary information
class OverviewTabWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;


  const OverviewTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Critical Alerts
          _buildCriticalAlerts(theme),
          SizedBox(height: 3.h),


          // Demographics
          _buildDemographicsCard(theme),
          SizedBox(height: 2.h),


          // Insurance
          _buildInsuranceCard(theme),
          SizedBox(height: 2.h),


          // Current Medications
          _buildCurrentMedicationsCard(theme),
          SizedBox(height: 2.h),


          // Recent Activity Timeline
          _buildRecentActivityTimeline(theme),
        ],
      ),
    );
  }


  Widget _buildCriticalAlerts(ThemeData theme) {
    final allergies = patientData['allergies'] as List;
    final conditions = patientData['conditions'] as List;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Critical Alerts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),


        // Allergies
        ...allergies.map((allergy) {
          final allergyMap = allergy as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ALLERGY: ',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            allergyMap['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Severity: ${allergyMap['severity']} | Reaction: ${allergyMap['reaction']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),


        // Conditions
        ...conditions.map((condition) {
          final conditionMap = condition as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'medical_information',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conditionMap['name'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Diagnosed: ${conditionMap['diagnosedDate']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }


  Widget _buildDemographicsCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demographics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
                theme, 'phone', 'Phone', patientData['phone'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(
                theme, 'email', 'Email', patientData['email'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(theme, 'location_on', 'Address',
                patientData['address'] as String),
          ],
        ),
      ),
    );
  }


  Widget _buildInsuranceCard(ThemeData theme) {
    final insurance = patientData['insurance'] as Map<String, dynamic>;


    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
                theme, 'business', 'Provider', insurance['provider'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(theme, 'badge', 'Policy Number',
                insurance['policyNumber'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(theme, 'calendar_today', 'Valid Until',
                insurance['validUntil'] as String),
          ],
        ),
      ),
    );
  }


  Widget _buildCurrentMedicationsCard(ThemeData theme) {
    final medications = patientData['currentMedications'] as List;


    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Medications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...medications.map((med) {
              final medication = med as Map<String, dynamic>;
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'medication',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            medication['name'] as String,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '${medication['dosage']} - ${medication['frequency']}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Prescribed by: ${medication['prescribedBy']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Since: ${medication['startDate']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _buildRecentActivityTimeline(ThemeData theme) {
    final visits = patientData['recentVisits'] as List;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...visits.map((visit) {
          final visitMap = visit as Map<String, dynamic>;
          final attachments = visitMap['attachments'] as List;


          return Card(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'event',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ),
                title: Text(
                  visitMap['type'] as String,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    Text(
                      visitMap['date'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${visitMap['provider']} - ${visitMap['department']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVisitDetailRow(theme, 'Chief Complaint',
                            visitMap['chiefComplaint'] as String),
                        SizedBox(height: 1.h),
                        _buildVisitDetailRow(theme, 'Diagnosis',
                            visitMap['diagnosis'] as String),
                        SizedBox(height: 1.h),
                        _buildVisitDetailRow(
                            theme, 'Notes', visitMap['notes'] as String),
                        if (attachments.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            'Attachments',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          ...attachments.map((attachment) {
                            final attachmentMap =
                                attachment as Map<String, dynamic>;
                            return Container(
                              margin: EdgeInsets.only(bottom: 1.h),
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CustomImageWidget(
                                      imageUrl: attachmentMap['url'] as String,
                                      width: 12.w,
                                      height: 12.w,
                                      fit: BoxFit.cover,
                                      semanticLabel:
                                          attachmentMap['semanticLabel']
                                              as String,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          attachmentMap['type'] as String,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          attachmentMap['name'] as String,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomIconWidget(
                                    iconName: 'chevron_right',
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }


  Widget _buildInfoRow(
      ThemeData theme, String iconName, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildVisitDetailRow(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}




=== File 21: lib/presentation/patient_record_view/widgets/patient_header_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Patient header widget displaying basic patient information
class PatientHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;


  const PatientHeaderWidget({
    super.key,
    required this.patientData,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Patient Photo
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: patientData['profilePhoto'] as String,
                width: 16.w,
                height: 16.w,
                fit: BoxFit.cover,
                semanticLabel: patientData['semanticLabel'] as String,
              ),
            ),
          ),
          SizedBox(width: 4.w),


          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientData['name'] as String,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      '${patientData['age']} yrs',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      patientData['gender'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      patientData['bloodGroup'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'ID: ${patientData['patientId']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),


          // Quick Actions
          Column(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling patient...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'phone',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                tooltip: 'Call Patient',
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sending message...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'message',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                tooltip: 'Message Patient',
              ),
            ],
          ),
        ],
      ),
    );
  }
}




=== File 22: lib/presentation/patient_record_view/widgets/patient_tabs_widget.dart ===

import 'package:flutter/material.dart';


/// Patient tabs widget for organizing patient data
class PatientTabsWidget extends StatelessWidget {
  final TabController tabController;


  const PatientTabsWidget({
    super.key,
    required this.tabController,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor: theme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Records'),
          Tab(text: 'Vitals'),
          Tab(text: 'Prescriptions'),
        ],
      ),
    );
  }
}




=== File 23: lib/presentation/patient_record_view/widgets/prescription_writer_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Prescription writer widget for healthcare providers
class PrescriptionWriterWidget extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final VoidCallback onClose;


  const PrescriptionWriterWidget({
    super.key,
    required this.patientData,
    required this.onClose,
  });


  @override
  State<PrescriptionWriterWidget> createState() =>
      _PrescriptionWriterWidgetState();
}


class _PrescriptionWriterWidgetState extends State<PrescriptionWriterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _refillsController = TextEditingController();
  final _notesController = TextEditingController();
  final _pharmacyController = TextEditingController();


  // Mock drug database
  final List<Map<String, dynamic>> _drugDatabase = [
    {
      "name": "Metformin",
      "commonDosages": ["500mg", "850mg", "1000mg"],
      "defaultFrequency": "Twice daily with meals",
      "interactions": ["Alcohol", "Iodinated contrast"],
      "warnings": "Monitor kidney function regularly"
    },
    {
      "name": "Lisinopril",
      "commonDosages": ["5mg", "10mg", "20mg", "40mg"],
      "defaultFrequency": "Once daily",
      "interactions": ["NSAIDs", "Potassium supplements"],
      "warnings": "May cause dry cough"
    },
    {
      "name": "Atorvastatin",
      "commonDosages": ["10mg", "20mg", "40mg", "80mg"],
      "defaultFrequency": "Once daily at bedtime",
      "interactions": ["Grapefruit juice", "Gemfibrozil"],
      "warnings": "Monitor liver enzymes"
    },
    {
      "name": "Amlodipine",
      "commonDosages": ["2.5mg", "5mg", "10mg"],
      "defaultFrequency": "Once daily",
      "interactions": ["Simvastatin"],
      "warnings": "May cause ankle swelling"
    },
    {
      "name": "Omeprazole",
      "commonDosages": ["20mg", "40mg"],
      "defaultFrequency": "Once daily before breakfast",
      "interactions": ["Clopidogrel"],
      "warnings": "Long-term use may affect bone density"
    },
  ];


  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? _selectedDrug;
  bool _showInteractionWarning = false;
  List<String> _detectedInteractions = [];


  @override
  void dispose() {
    _medicationController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _quantityController.dispose();
    _refillsController.dispose();
    _notesController.dispose();
    _pharmacyController.dispose();
    super.dispose();
  }


  void _searchDrug(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }


    setState(() {
      _searchResults = _drugDatabase
          .where((drug) => (drug['name'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }


  void _selectDrug(Map<String, dynamic> drug) {
    setState(() {
      _selectedDrug = drug;
      _medicationController.text = drug['name'] as String;
      _frequencyController.text = drug['defaultFrequency'] as String;
      _searchResults = [];
      _checkInteractions(drug);
    });
  }


  void _checkInteractions(Map<String, dynamic> drug) {
    final currentMedications = widget.patientData['currentMedications'] as List;
    final interactions = drug['interactions'] as List;
    final detectedInteractions = <String>[];


    for (final med in currentMedications) {
      final medication = med as Map<String, dynamic>;
      final medName = medication['name'] as String;
      if (interactions.any((interaction) => medName
          .toLowerCase()
          .contains((interaction as String).toLowerCase()))) {
        detectedInteractions.add(medName);
      }
    }


    setState(() {
      _showInteractionWarning = detectedInteractions.isNotEmpty;
      _detectedInteractions = detectedInteractions;
    });
  }


  void _submitPrescription() {
    if (_formKey.currentState!.validate()) {
      final theme = Theme.of(context);
      widget.onClose();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Prescription submitted successfully',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 90.w,
          constraints: BoxConstraints(maxHeight: 85.h),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit_note',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write Prescription',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'For ${widget.patientData['name']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),


              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drug Search
                        Text(
                          'Medication',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _medicationController,
                          decoration: InputDecoration(
                            hintText: 'Search medication...',
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: _medicationController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _medicationController.clear();
                                        _selectedDrug = null;
                                        _searchResults = [];
                                        _showInteractionWarning = false;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: _searchDrug,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter medication name';
                            }
                            return null;
                          },
                        ),


                        // Search Results
                        if (_searchResults.isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          Container(
                            constraints: BoxConstraints(maxHeight: 20.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final drug = _searchResults[index];
                                return ListTile(
                                  title: Text(drug['name'] as String),
                                  subtitle: Text(
                                    'Common dosages: ${(drug['commonDosages'] as List).join(', ')}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  onTap: () => _selectDrug(drug),
                                );
                              },
                            ),
                          ),
                        ],


                        // Interaction Warning
                        if (_showInteractionWarning) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.error
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomIconWidget(
                                  iconName: 'warning',
                                  color: theme.colorScheme.error,
                                  size: 24,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Drug Interaction Warning',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        'May interact with: ${_detectedInteractions.join(', ')}',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],


                        // Dosage Recommendations
                        if (_selectedDrug != null) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'info',
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Dosage Recommendations',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Wrap(
                                  spacing: 2.w,
                                  runSpacing: 1.h,
                                  children:
                                      (_selectedDrug!['commonDosages'] as List)
                                          .map((dosage) {
                                    return ActionChip(
                                      label: Text(dosage as String),
                                      onPressed: () {
                                        setState(() {
                                          _dosageController.text =
                                              dosage;
                                        });
                                      },
                                      backgroundColor:
                                          theme.colorScheme.surface,
                                      side: BorderSide(
                                        color: theme.colorScheme.primary,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  _selectedDrug!['warnings'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],


                        SizedBox(height: 2.h),


                        // Dosage
                        Text(
                          'Dosage',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _dosageController,
                          decoration: InputDecoration(
                            hintText: 'e.g., 500mg',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter dosage';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Frequency
                        Text(
                          'Frequency',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _frequencyController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Twice daily with meals',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter frequency';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Duration and Quantity
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  TextFormField(
                                    controller: _durationController,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., 30 days',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  TextFormField(
                                    controller: _quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., 60',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),


                        // Refills
                        Text(
                          'Refills',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _refillsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Number of refills',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of refills';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Pharmacy
                        Text(
                          'Pharmacy',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _pharmacyController,
                          decoration: InputDecoration(
                            hintText: 'Select pharmacy',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select pharmacy';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Notes
                        Text(
                          'Special Instructions',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Additional instructions for patient...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              // Actions
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onClose,
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitPrescription,
                        child: Text('Submit Prescription'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




=== File 24: lib/presentation/patient_record_view/widgets/prescriptions_tab_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Prescriptions tab widget displaying patient prescription history
class PrescriptionsTabWidget extends StatefulWidget {
  final Map<String, dynamic> patientData;


  const PrescriptionsTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  State<PrescriptionsTabWidget> createState() => _PrescriptionsTabWidgetState();
}


class _PrescriptionsTabWidgetState extends State<PrescriptionsTabWidget> {
  String _selectedStatus = 'All';
  final List<String> _statusTypes = ['All', 'Active', 'Completed'];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prescriptions = widget.patientData['prescriptionHistory'] as List;
    final filteredPrescriptions = _selectedStatus == 'All'
        ? prescriptions
        : prescriptions.where((prescription) {
            final prescriptionMap = prescription as Map<String, dynamic>;
            return prescriptionMap['status'] == _selectedStatus;
          }).toList();


    return Column(
      children: [
        // Status Filter
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: _statusTypes.map((status) {
              final isSelected = _selectedStatus == status;
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  backgroundColor: theme.colorScheme.surface,
                  selectedColor:
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                ),
              );
            }).toList(),
          ),
        ),


        // Prescriptions List
        Expanded(
          child: filteredPrescriptions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'medication',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No prescriptions found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: filteredPrescriptions.length,
                  itemBuilder: (context, index) {
                    final prescription =
                        filteredPrescriptions[index] as Map<String, dynamic>;
                    return _buildPrescriptionCard(theme, prescription);
                  },
                ),
        ),
      ],
    );
  }


  Widget _buildPrescriptionCard(
      ThemeData theme, Map<String, dynamic> prescription) {
    final isActive = prescription['status'] == 'Active';


    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'medication',
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescription['medication'] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        prescription['dosage'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    prescription['status'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),


            // Prescription Details
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                      theme, 'Frequency', prescription['frequency'] as String),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Duration', prescription['duration'] as String),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Quantity', '${prescription['quantity']} tablets'),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Refills', '${prescription['refills']} remaining'),
                ],
              ),
            ),
            SizedBox(height: 2.h),


            // Provider Info
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Prescribed by ${prescription['prescribedBy']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  prescription['date'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_pharmacy',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    prescription['pharmacy'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),


            // Notes
            if (prescription['notes'] != null) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: theme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        prescription['notes'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],


            // Actions
            if (isActive) ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Renewing prescription...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Renew'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Modifying prescription...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Modify'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}




=== File 25: lib/presentation/patient_record_view/widgets/records_tab_widget.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Records tab widget displaying patient medical records with provider annotations
class RecordsTabWidget extends StatefulWidget {
  final Map<String, dynamic> patientData;


  const RecordsTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  State<RecordsTabWidget> createState() => _RecordsTabWidgetState();
}


class _RecordsTabWidgetState extends State<RecordsTabWidget> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Laboratory',
    'Imaging',
    'Prescription'
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final records = widget.patientData['medicalRecords'] as List;
    final filteredRecords = _selectedCategory == 'All'
        ? records
        : records.where((record) {
            final recordMap = record as Map<String, dynamic>;
            return recordMap['category'] == _selectedCategory;
          }).toList();


    return Column(
      children: [
        // Category Filter
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),


        // Records List
        Expanded(
          child: filteredRecords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'folder_open',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No records found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    final record =
                        filteredRecords[index] as Map<String, dynamic>;
                    return _buildRecordCard(theme, record);
                  },
                ),
        ),
      ],
    );
  }


  Widget _buildRecordCard(ThemeData theme, Map<String, dynamic> record) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          _showRecordDetailDialog(theme, record);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Record Image Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: record['imageUrl'] as String,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                      semanticLabel: record['semanticLabel'] as String,
                    ),
                  ),
                  SizedBox(width: 4.w),


                  // Record Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            record['category'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          record['title'] as String,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          record['date'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${record['provider']} - ${record['department']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),


                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),


              // Provider Notes Section
              if (record['providerNotes'] != null) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'note_alt',
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Provider Notes',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        record['providerNotes'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],


              // Internal Notes Section (Healthcare Team Only)
              if (record['internalNotes'] != null) ...[
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'lock',
                            color: theme.colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Internal Notes (Team Only)',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        record['internalNotes'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }


  void _showRecordDetailDialog(ThemeData theme, Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 80.h,
            maxWidth: 90.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        record['title'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),


              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: record['imageUrl'] as String,
                          width: double.infinity,
                          height: 40.h,
                          fit: BoxFit.contain,
                          semanticLabel: record['semanticLabel'] as String,
                        ),
                      ),
                      SizedBox(height: 2.h),


                      // Record Details
                      _buildDetailRow(theme, 'Date', record['date'] as String),
                      SizedBox(height: 1.h),
                      _buildDetailRow(theme, 'Type', record['type'] as String),
                      SizedBox(height: 1.h),
                      _buildDetailRow(
                          theme, 'Category', record['category'] as String),
                      SizedBox(height: 1.h),
                      _buildDetailRow(
                          theme, 'Provider', record['provider'] as String),
                      SizedBox(height: 1.h),
                      _buildDetailRow(
                          theme, 'Department', record['department'] as String),
                    ],
                  ),
                ),
              ),


              // Actions
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Adding annotation...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: CustomIconWidget(
                          iconName: 'edit',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        label: Text('Annotate'),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sharing record...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text('Share'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}




=== File 26: lib/presentation/patient_record_view/widgets/vitals_tab_widget.dart ===

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';


/// Vitals tab widget displaying patient vital signs with trending charts
class VitalsTabWidget extends StatefulWidget {
  final Map<String, dynamic> patientData;


  const VitalsTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  State<VitalsTabWidget> createState() => _VitalsTabWidgetState();
}


class _VitalsTabWidgetState extends State<VitalsTabWidget> {
  String _selectedVital = 'Blood Pressure';
  final List<String> _vitalTypes = [
    'Blood Pressure',
    'Heart Rate',
    'Temperature',
    'Weight',
    'BMI',
    'Oxygen Saturation'
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vitalHistory = widget.patientData['vitalHistory'] as List;
    final latestVitals = vitalHistory.first as Map<String, dynamic>;


    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Latest Vitals Summary
          Text(
            'Latest Vitals',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildLatestVitalsGrid(theme, latestVitals),
          SizedBox(height: 3.h),


          // Vital Trend Chart
          Text(
            'Vital Trends',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),


          // Vital Type Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _vitalTypes.map((vital) {
                final isSelected = _selectedVital == vital;
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(vital),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedVital = vital;
                      });
                    },
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 2.h),


          // Chart
          _buildVitalChart(theme, vitalHistory),
          SizedBox(height: 3.h),


          // Vital History Table
          Text(
            'Vital History',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildVitalHistoryTable(theme, vitalHistory),
        ],
      ),
    );
  }


  Widget _buildLatestVitalsGrid(ThemeData theme, Map<String, dynamic> vitals) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2.h,
      crossAxisSpacing: 4.w,
      childAspectRatio: 1.5,
      children: [
        _buildVitalCard(
          theme,
          'Blood Pressure',
          vitals['bloodPressure'] as String,
          'mmHg',
          'favorite',
          Colors.red,
        ),
        _buildVitalCard(
          theme,
          'Heart Rate',
          '${vitals['heartRate']}',
          'bpm',
          'monitor_heart',
          Colors.pink,
        ),
        _buildVitalCard(
          theme,
          'Temperature',
          '${vitals['temperature']}',
          '°F',
          'thermostat',
          Colors.orange,
        ),
        _buildVitalCard(
          theme,
          'Weight',
          '${vitals['weight']}',
          'lbs',
          'scale',
          Colors.blue,
        ),
        _buildVitalCard(
          theme,
          'BMI',
          '${vitals['bmi']}',
          '',
          'straighten',
          Colors.green,
        ),
        _buildVitalCard(
          theme,
          'O₂ Saturation',
          '${vitals['oxygenSaturation']}',
          '%',
          'air',
          Colors.cyan,
        ),
      ],
    );
  }


  Widget _buildVitalCard(
    ThemeData theme,
    String label,
    String value,
    String unit,
    String iconName,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: color,
                    size: 16,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  SizedBox(width: 1.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Text(
                      unit,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildVitalChart(ThemeData theme, List vitalHistory) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedVital,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 30.h,
              child: Semantics(
                label:
                    '$_selectedVital trend chart showing measurements over time',
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < vitalHistory.length) {
                              final vital = vitalHistory[value.toInt()]
                                  as Map<String, dynamic>;
                              final date = vital['date'] as String;
                              final parts = date.split('-');
                              return Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Text(
                                  '${parts[1]}/${parts[2]}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: theme.textTheme.bodySmall,
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    minX: 0,
                    maxX: (vitalHistory.length - 1).toDouble(),
                    minY: _getMinY(vitalHistory),
                    maxY: _getMaxY(vitalHistory),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _getChartSpots(vitalHistory),
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: theme.colorScheme.primary,
                              strokeWidth: 2,
                              strokeColor: theme.colorScheme.surface,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<FlSpot> _getChartSpots(List vitalHistory) {
    final spots = <FlSpot>[];
    for (int i = 0; i < vitalHistory.length; i++) {
      final vital = vitalHistory[i] as Map<String, dynamic>;
      double value = 0;


      switch (_selectedVital) {
        case 'Blood Pressure':
          final bp = vital['bloodPressure'] as String;
          final systolic = int.parse(bp.split('/')[0]);
          value = systolic.toDouble();
          break;
        case 'Heart Rate':
          value = (vital['heartRate'] as int).toDouble();
          break;
        case 'Temperature':
          value = vital['temperature'] as double;
          break;
        case 'Weight':
          value = (vital['weight'] as int).toDouble();
          break;
        case 'BMI':
          value = vital['bmi'] as double;
          break;
        case 'Oxygen Saturation':
          value = (vital['oxygenSaturation'] as int).toDouble();
          break;
      }


      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots.reversed.toList();
  }


  double _getMinY(List vitalHistory) {
    final spots = _getChartSpots(vitalHistory);
    final values = spots.map((spot) => spot.y).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    return (minValue - 5).floorToDouble();
  }


  double _getMaxY(List vitalHistory) {
    final spots = _getChartSpots(vitalHistory);
    final values = spots.map((spot) => spot.y).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return (maxValue + 5).ceilToDouble();
  }


  Widget _buildVitalHistoryTable(ThemeData theme, List vitalHistory) {
    return Card(
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'BP',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'HR',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Temp',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'O₂',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Table Rows
          ...vitalHistory.map((vital) {
            final vitalMap = vital as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      vitalMap['date'] as String,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      vitalMap['bloodPressure'] as String,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${vitalMap['heartRate']}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${vitalMap['temperature']}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${vitalMap['oxygenSaturation']}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}




=== File 27: lib/presentation/splash_screen/splash_screen.dart ===

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';


/// Splash Screen - Branded app launch experience with medical-grade precision
///
/// Displays full-screen Medical Blue gradient with animated logo and shimmer effect
/// during 2-3 second initialization of core medical data services. Performs critical
/// background tasks including biometric authentication check, encrypted health records
/// cache loading, security certificate fetching, and offline data sync preparation.
///
/// Navigation Logic:
/// - Authenticated users with valid biometric tokens → Health Dashboard
/// - New users → 4-slide Onboarding Flow
/// - Returning users → Authentication Screen with biometric prompt
///
/// Accessibility: Respects reduced motion preferences for users with vestibular disorders
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
    _initializeShimmerAnimation();
    _performInitialization();
  }


  /// Initialize shimmer animation for logo with reduced motion support
  void _initializeShimmerAnimation() {
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );


    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));


    // Check for reduced motion preference
    final reducedMotion = MediaQuery.of(context).disableAnimations;


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




=== File 28: lib/routes/app_routes.dart ===

import 'package:flutter/material.dart';
import '../presentation/medical_records_screen/medical_records_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/health_dashboard/health_dashboard.dart';
import '../presentation/patient_record_view/patient_record_view.dart';


class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String medicalRecords = '/medical-records-screen';
  static const String splash = '/splash-screen';
  static const String authentication = '/authentication-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String healthDashboard = '/health-dashboard';
  static const String patientRecordView = '/patient-record-view';


  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    medicalRecords: (context) => const MedicalRecordsScreen(),
    splash: (context) => const SplashScreen(),
    authentication: (context) => const AuthenticationScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    healthDashboard: (context) => const HealthDashboard(),
    patientRecordView: (context) => const PatientRecordView(),
    // TODO: Add your other routes here
  };
}




=== File 29: lib/theme/app_theme.dart ===

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// A class that contains all theme configurations for the healthcare application.
/// Implements Medical Precision Minimalism design philosophy with Clinical Trust Palette.
class AppTheme {
  AppTheme._();


  // Clinical Trust Palette - Light Theme Colors
  static const Color primaryMedicalBlueLight = Color(0xFF0066CC);
  static const Color trustTealLight = Color(0xFF00A896);
  static const Color accentMintLight = Color(0xFFE8F5F3);
  static const Color criticalRedLight = Color(0xFFDC2626);
  static const Color warningAmberLight = Color(0xFFF59E0B);
  static const Color successGreenLight = Color(0xFF10B981);
  static const Color infoBlueLigh = Color(0xFF3B82F6);
  static const Color neutralCharcoalLight = Color(0xFF374151);
  static const Color surfaceGrayLight = Color(0xFFF9FAFB);
  static const Color borderLightGray = Color(0xFFE5E7EB);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF374151);
  static const Color onSurfaceLight = Color(0xFF374151);
  static const Color onErrorLight = Color(0xFFFFFFFF);


  // Clinical Trust Palette - Dark Theme Colors
  static const Color primaryMedicalBlueDark = Color(0xFF3B8FE8);
  static const Color trustTealDark = Color(0xFF00C9B7);
  static const Color accentMintDark = Color(0xFF1A3A37);
  static const Color criticalRedDark = Color(0xFFEF4444);
  static const Color warningAmberDark = Color(0xFFFBBF24);
  static const Color successGreenDark = Color(0xFF34D399);
  static const Color infoBlueDark = Color(0xFF60A5FA);
  static const Color neutralCharcoalDark = Color(0xFFD1D5DB);
  static const Color surfaceGrayDark = Color(0xFF1F2937);
  static const Color borderDarkGray = Color(0xFF374151);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFD1D5DB);
  static const Color onSurfaceDark = Color(0xFFD1D5DB);
  static const Color onErrorDark = Color(0xFF000000);


  // Card and dialog colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF1F2937);


  // Shadow colors with 8% opacity maximum
  static const Color shadowLight = Color(0x14000000);
  static const Color shadowDark = Color(0x14FFFFFF);


  // Divider colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);


  // Text colors with proper contrast ratios
  static const Color textHighEmphasisLight = Color(0xFF374151); // Primary text
  static const Color textMediumEmphasisLight =
      Color(0xFF6B7280); // Secondary text
  static const Color textDisabledLight = Color(0xFF9CA3AF); // Disabled text


  static const Color textHighEmphasisDark = Color(0xFFD1D5DB); // Primary text
  static const Color textMediumEmphasisDark =
      Color(0xFF9CA3AF); // Secondary text
  static const Color textDisabledDark = Color(0xFF6B7280); // Disabled text


  /// Light theme - Optimized for bright clinical environments
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryMedicalBlueLight,
      onPrimary: onPrimaryLight,
      primaryContainer: trustTealLight,
      onPrimaryContainer: onPrimaryLight,
      secondary: trustTealLight,
      onSecondary: onSecondaryLight,
      secondaryContainer: accentMintLight,
      onSecondaryContainer: neutralCharcoalLight,
      tertiary: infoBlueLigh,
      onTertiary: onPrimaryLight,
      tertiaryContainer: accentMintLight,
      onTertiaryContainer: neutralCharcoalLight,
      error: criticalRedLight,
      onError: onErrorLight,
      surface: surfaceGrayLight,
      onSurface: onSurfaceLight,
      onSurfaceVariant: textMediumEmphasisLight,
      outline: borderLightGray,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: surfaceGrayDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: primaryMedicalBlueDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,
    appBarTheme: AppBarTheme(
      color: backgroundLight,
      foregroundColor: neutralCharcoalLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutralCharcoalLight,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: neutralCharcoalLight,
        size: 24,
      ),
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: borderLightGray, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundLight,
      selectedItemColor: primaryMedicalBlueLight,
      unselectedItemColor: textMediumEmphasisLight,
      elevation: 4.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: criticalRedLight,
      foregroundColor: onErrorLight,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryLight,
        backgroundColor: primaryMedicalBlueLight,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryMedicalBlueLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        side: const BorderSide(color: primaryMedicalBlueLight, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryMedicalBlueLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: backgroundLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderLightGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderLightGray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryMedicalBlueLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: criticalRedLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: criticalRedLight, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: criticalRedLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueLight;
        }
        return textDisabledLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueLight.withValues(alpha: 0.5);
        }
        return borderLightGray;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryLight),
      side: const BorderSide(color: borderLightGray, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueLight;
        }
        return borderLightGray;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryMedicalBlueLight,
      linearTrackColor: borderLightGray,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryMedicalBlueLight,
      thumbColor: primaryMedicalBlueLight,
      overlayColor: primaryMedicalBlueLight.withValues(alpha: 0.2),
      inactiveTrackColor: borderLightGray,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryMedicalBlueLight,
      unselectedLabelColor: textMediumEmphasisLight,
      indicatorColor: primaryMedicalBlueLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.25,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: neutralCharcoalLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: neutralCharcoalLight,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: trustTealLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: backgroundLight,
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      modalBackgroundColor: backgroundLight,
      modalElevation: 8.0,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: dialogLight,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutralCharcoalLight,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasisLight,
      ),
    ),
  );


  /// Dark theme - Optimized for dimly lit bedrooms during night-time health logging
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryMedicalBlueDark,
      onPrimary: onPrimaryDark,
      primaryContainer: trustTealDark,
      onPrimaryContainer: onPrimaryDark,
      secondary: trustTealDark,
      onSecondary: onSecondaryDark,
      secondaryContainer: accentMintDark,
      onSecondaryContainer: neutralCharcoalDark,
      tertiary: infoBlueDark,
      onTertiary: onPrimaryDark,
      tertiaryContainer: accentMintDark,
      onTertiaryContainer: neutralCharcoalDark,
      error: criticalRedDark,
      onError: onErrorDark,
      surface: surfaceGrayDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: textMediumEmphasisDark,
      outline: borderDarkGray,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceGrayLight,
      onInverseSurface: onSurfaceLight,
      inversePrimary: primaryMedicalBlueLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: AppBarTheme(
      color: backgroundDark,
      foregroundColor: neutralCharcoalDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutralCharcoalDark,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: neutralCharcoalDark,
        size: 24,
      ),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: borderDarkGray, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceGrayDark,
      selectedItemColor: primaryMedicalBlueDark,
      unselectedItemColor: textMediumEmphasisDark,
      elevation: 4.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: criticalRedDark,
      foregroundColor: onErrorDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryDark,
        backgroundColor: primaryMedicalBlueDark,
        elevation: 2.0,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryMedicalBlueDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        side: const BorderSide(color: primaryMedicalBlueDark, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryMedicalBlueDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceGrayDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderDarkGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderDarkGray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryMedicalBlueDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: criticalRedDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: criticalRedDark, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: criticalRedDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueDark;
        }
        return textDisabledDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueDark.withValues(alpha: 0.5);
        }
        return borderDarkGray;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryDark),
      side: const BorderSide(color: borderDarkGray, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryMedicalBlueDark;
        }
        return borderDarkGray;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryMedicalBlueDark,
      linearTrackColor: borderDarkGray,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryMedicalBlueDark,
      thumbColor: primaryMedicalBlueDark,
      overlayColor: primaryMedicalBlueDark.withValues(alpha: 0.2),
      inactiveTrackColor: borderDarkGray,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryMedicalBlueDark,
      unselectedLabelColor: textMediumEmphasisDark,
      indicatorColor: primaryMedicalBlueDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.25,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: neutralCharcoalDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceGrayDark,
      contentTextStyle: GoogleFonts.inter(
        color: neutralCharcoalDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: trustTealDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceGrayDark,
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      modalBackgroundColor: surfaceGrayDark,
      modalElevation: 8.0,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: dialogDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutralCharcoalDark,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasisDark,
      ),
    ),
  );


  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for all text styles with appropriate weights
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;


    return TextTheme(
      // Display styles - Large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),


      // Headline styles - Section headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),


      // Title styles - Card titles and list items
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),


      // Body styles - Main content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),


      // Label styles - Buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 1.25,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }


  /// Get JetBrains Mono text style for medical data display
  /// Used for medical codes, dates, and numerical health data
  static TextStyle getDataTextStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0,
      height: 1.5,
    );
  }


  /// Animation duration constants following 300ms spring physics
  static const Duration standardAnimationDuration = Duration(milliseconds: 300);
  static const Duration quickAnimationDuration = Duration(milliseconds: 200);
  static const Duration modalAnimationDuration = Duration(milliseconds: 250);


  /// Border radius constants following 8px, 12px, 16px scale
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;


  /// Elevation constants following 1dp, 2dp, 4dp system
  static const double elevationMinimal = 1.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;


  /// Touch target sizes optimized for medical use
  static const double touchTargetMinimum = 48.0;
  static const double touchTargetEmergency = 56.0;
  static const double touchTargetSpacing = 8.0;
}




=== File 30: lib/widgets/custom_app_bar.dart ===

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// App bar variant types for different contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and actions
  standard,


  /// Search-focused app bar with search field
  search,


  /// Profile/settings app bar with avatar
  profile,


  /// Medical record detail app bar with share action
  recordDetail,


  /// Emergency mode app bar with critical styling
  emergency;
}


/// Custom app bar for healthcare application
/// Implements Medical Precision Minimalism with clean interfaces
/// Optimized for clinical environments and mobile contexts
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text displayed in the app bar
  final String? title;


  /// Subtitle text displayed below title (optional)
  final String? subtitle;


  /// Leading widget (typically back button or menu)
  final Widget? leading;


  /// Action widgets displayed on the right
  final List<Widget>? actions;


  /// Whether to show back button automatically
  final bool automaticallyImplyLeading;


  /// App bar variant type
  final CustomAppBarVariant variant;


  /// Whether to center the title
  final bool centerTitle;


  /// Custom background color (overrides theme)
  final Color? backgroundColor;


  /// Elevation of the app bar
  final double? elevation;


  /// Search query callback for search variant
  final ValueChanged<String>? onSearchChanged;


  /// Search submit callback for search variant
  final ValueChanged<String>? onSearchSubmitted;


  /// Initial search query for search variant
  final String? initialSearchQuery;


  /// Avatar URL for profile variant
  final String? avatarUrl;


  /// Avatar tap callback for profile variant
  final VoidCallback? onAvatarTap;


  /// Share callback for record detail variant
  final VoidCallback? onShare;


  /// Emergency callback for emergency variant
  final VoidCallback? onEmergencyAction;


  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.variant = CustomAppBarVariant.standard,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.initialSearchQuery,
    this.avatarUrl,
    this.onAvatarTap,
    this.onShare,
    this.onEmergencyAction,
  });


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme, isDark);
      case CustomAppBarVariant.profile:
        return _buildProfileAppBar(context, theme, isDark);
      case CustomAppBarVariant.recordDetail:
        return _buildRecordDetailAppBar(context, theme, isDark);
      case CustomAppBarVariant.emergency:
        return _buildEmergencyAppBar(context, theme, isDark);
      case CustomAppBarVariant.standard:
      default:
        return _buildStandardAppBar(context, theme, isDark);
    }
  }


  /// Standard app bar with title and actions
  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);


    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            )
          : Text(
              title ?? '',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.15,
              ),
            ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }


  /// Search-focused app bar with search field
  Widget _buildSearchAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);


    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: false,
      title: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: TextField(
          controller: TextEditingController(text: initialSearchQuery),
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: 'Search medical records...',
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              size: 20,
            ),
            suffixIcon:
                initialSearchQuery != null && initialSearchQuery!.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                          size: 20,
                        ),
                        onPressed: () {
                          if (onSearchChanged != null) {
                            onSearchChanged!('');
                          }
                        },
                      )
                    : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_list_rounded,
            color: textColor,
            size: 24,
          ),
          onPressed: () {
            // Filter action
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }


  /// Profile app bar with avatar
  Widget _buildProfileAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);


    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(
        title ?? 'Profile',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.15,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor:
                  isDark ? const Color(0xFF3B8FE8) : const Color(0xFF0066CC),
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
        ),
        ...?actions,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }


  /// Record detail app bar with share action
  Widget _buildRecordDetailAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);
    final primaryColor =
        isDark ? const Color(0xFF3B8FE8) : const Color(0xFF0066CC);


    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(
        title ?? 'Medical Record',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.15,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.share_rounded,
            color: primaryColor,
            size: 24,
          ),
          onPressed: onShare ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Share medical record',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
          tooltip: 'Share record',
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: textColor,
            size: 24,
          ),
          onPressed: () {
            // More options
          },
        ),
        ...?actions,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }


  /// Emergency mode app bar with critical styling
  Widget _buildEmergencyAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final emergencyColor =
        isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);


    return AppBar(
      backgroundColor: emergencyColor,
      elevation: elevation ?? 4,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emergency_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title ?? 'EMERGENCY MODE',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onEmergencyAction ??
              () {
                Navigator.of(context).pop();
              },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            'EXIT',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.25,
            ),
          ),
        ),
        ...?actions,
      ],
    );
  }
}




=== File 31: lib/widgets/custom_bottom_bar.dart ===

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// Navigation item configuration for bottom navigation bar
enum CustomBottomBarItem {
  healthId,
  records,
  care,
  profile;


  String get label {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return 'Health ID';
      case CustomBottomBarItem.records:
        return 'Records';
      case CustomBottomBarItem.care:
        return 'Care';
      case CustomBottomBarItem.profile:
        return 'Profile';
    }
  }


  IconData get icon {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return Icons.credit_card_rounded;
      case CustomBottomBarItem.records:
        return Icons.folder_outlined;
      case CustomBottomBarItem.care:
        return Icons.calendar_today_rounded;
      case CustomBottomBarItem.profile:
        return Icons.person_outline_rounded;
    }
  }


  IconData get activeIcon {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return Icons.credit_card;
      case CustomBottomBarItem.records:
        return Icons.folder;
      case CustomBottomBarItem.care:
        return Icons.calendar_today;
      case CustomBottomBarItem.profile:
        return Icons.person;
    }
  }


  String get route {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return '/health-dashboard';
      case CustomBottomBarItem.records:
        return '/medical-records-screen';
      case CustomBottomBarItem.care:
        return '/patient-record-view';
      case CustomBottomBarItem.profile:
        return '/authentication-screen';
    }
  }
}


/// Custom bottom navigation bar for healthcare application
/// Implements bottom-heavy interaction design with 48dp touch targets
/// Optimized for one-handed operation during clinical visits
class CustomBottomBar extends StatelessWidget {
  /// Current selected navigation item
  final CustomBottomBarItem currentItem;


  /// Callback when navigation item is tapped
  final ValueChanged<CustomBottomBarItem>? onItemSelected;


  /// Whether to show emergency FAB
  final bool showEmergencyFab;


  /// Callback for emergency FAB tap
  final VoidCallback? onEmergencyTap;


  /// Whether the bottom bar should be elevated
  final bool elevated;


  const CustomBottomBar({
    super.key,
    required this.currentItem,
    this.onItemSelected,
    this.showEmergencyFab = true,
    this.onEmergencyTap,
    this.elevated = true,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;


    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              // Navigation items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: CustomBottomBarItem.values.map((item) {
                  return _NavigationItem(
                    item: item,
                    isSelected: currentItem == item,
                    onTap: () {
                      if (onItemSelected != null) {
                        onItemSelected!(item);
                      } else {
                        Navigator.pushNamed(context, item.route);
                      }
                    },
                    colorScheme: colorScheme,
                    isDark: isDark,
                  );
                }).toList(),
              ),


              // Emergency FAB overlay
              if (showEmergencyFab)
                Positioned(
                  right: 16,
                  bottom: 8,
                  child: _EmergencyFab(
                    onTap: onEmergencyTap,
                    colorScheme: colorScheme,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Individual navigation item widget
class _NavigationItem extends StatelessWidget {
  final CustomBottomBarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isDark;


  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.isDark,
  });


  @override
  Widget build(BuildContext context) {
    final primaryColor =
        isDark ? const Color(0xFF3B8FE8) : const Color(0xFF0066CC);
    final unselectedColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);


    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with 48dp touch target
              SizedBox(
                height: 28,
                width: 28,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 24,
                  color: isSelected ? primaryColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected ? primaryColor : unselectedColor,
                  letterSpacing: 0.4,
                  height: 1.33,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Emergency SOS floating action button
/// Positioned in bottom-right for thumb accessibility
/// 56dp touch target for stress situations and gloved hands
class _EmergencyFab extends StatelessWidget {
  final VoidCallback? onTap;
  final ColorScheme colorScheme;


  const _EmergencyFab({
    this.onTap,
    required this.colorScheme,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emergencyColor =
        isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);


    return Material(
      color: emergencyColor,
      elevation: 4,
      shadowColor:
          (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap ??
            () {
              // Default emergency action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Emergency SOS activated',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: emergencyColor,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: const Icon(
            Icons.emergency_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


/// Provider role variant of bottom navigation bar
/// Separate navigation context for clinical workflows
class CustomProviderBottomBar extends StatelessWidget {
  /// Current selected navigation item for provider
  final int currentIndex;


  /// Callback when navigation item is tapped
  final ValueChanged<int>? onItemSelected;


  /// Whether the bottom bar should be elevated
  final bool elevated;


  const CustomProviderBottomBar({
    super.key,
    required this.currentIndex,
    this.onItemSelected,
    this.elevated = true,
  });


  static const List<_ProviderNavItem> _items = [
    _ProviderNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      route: '/health-dashboard',
    ),
    _ProviderNavItem(
      label: 'Patients',
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      route: '/medical-records-screen',
    ),
    _ProviderNavItem(
      label: 'Schedule',
      icon: Icons.event_note_outlined,
      activeIcon: Icons.event_note,
      route: '/patient-record-view',
    ),
    _ProviderNavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person,
      route: '/authentication-screen',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = currentIndex == index;
              final primaryColor =
                  isDark ? const Color(0xFF3B8FE8) : const Color(0xFF0066CC);
              final unselectedColor =
                  isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);


              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (onItemSelected != null) {
                      onItemSelected!(index);
                    } else {
                      Navigator.pushNamed(context, item.route);
                    }
                  },
                  splashColor: primaryColor.withValues(alpha: 0.1),
                  highlightColor: primaryColor.withValues(alpha: 0.05),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 24,
                            color: isSelected ? primaryColor : unselectedColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                            color: isSelected ? primaryColor : unselectedColor,
                            letterSpacing: 0.4,
                            height: 1.33,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}


/// Provider navigation item data class
class _ProviderNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;


  const _ProviderNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}




=== File 32: lib/widgets/custom_error_widget.dart ===

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../core/app_export.dart';
import '../routes/app_routes.dart';


// custom_error_widget.dart


class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;


  const CustomErrorWidget({
    Key? key,
    this.errorDetails,
    this.errorMessage,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/sad_face.svg',
                height: 42,
                width: 42,
              ),
              const SizedBox(height: 8),
              Text(
                "Something went wrong",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF262626),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                child: const Text(
                  'We encountered an unexpected error while processing your request.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF525252), // neutral-600
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  bool canBeBack = Navigator.canPop(context);
                  if (canBeBack) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushNamed(context, AppRoutes.initial);
                  }
                },
                icon:
                    const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}




=== File 33: lib/widgets/custom_icon_widget.dart ===

import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;

  const CustomIconWidget(
      {Key? key, required this.iconName, this.size = 24, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map of available icons
    final Map<String, IconData> iconMap = {
      // A
      'abc': Icons.abc,
      'ac_unit': Icons.ac_unit,
      'access_alarm': Icons.access_alarm,
      'access_alarms': Icons.access_alarms,
      'access_time': Icons.access_time,
      'access_time_filled': Icons.access_time_filled,
      'access_time_rounded': Icons.access_time_rounded,
      'accessibility': Icons.accessibility,
      'accessibility_new': Icons.accessibility_new,
      'accessible': Icons.accessible,
      'accessible_forward': Icons.accessible_forward,
      'account_balance': Icons.account_balance,
      'account_balance_wallet': Icons.account_balance_wallet,
      'account_box': Icons.account_box,
      'account_circle': Icons.account_circle,
      'account_tree': Icons.account_tree,
      'ad_units': Icons.ad_units,
      'adb': Icons.adb,
      'add': Icons.add,
      'add_a_photo': Icons.add_a_photo,
      'add_alarm': Icons.add_alarm,
      'add_alert': Icons.add_alert,
      'add_box': Icons.add_box,
      'add_business': Icons.add_business,
      'add_call': Icons.add_call,
      'add_card': Icons.add_card,
      'add_chart': Icons.add_chart,
      'add_circle': Icons.add_circle,
      'add_circle_outline': Icons.add_circle_outline,
      'add_comment': Icons.add_comment,
      'add_home': Icons.add_home,
      'add_home_work': Icons.add_home_work,
      'add_ic_call': Icons.add_ic_call,
      'add_link': Icons.add_link,
      'add_location': Icons.add_location,
      'add_location_alt': Icons.add_location_alt,
      'add_moderator': Icons.add_moderator,
      'add_photo_alternate': Icons.add_photo_alternate,
      'add_reaction': Icons.add_reaction,
      'add_road': Icons.add_road,
      'add_shopping_cart': Icons.add_shopping_cart,
      'add_task': Icons.add_task,
      'add_to_drive': Icons.add_to_drive,
      'add_to_home_screen': Icons.add_to_home_screen,
      'add_to_photos': Icons.add_to_photos,
      'add_to_queue': Icons.add_to_queue,
      'addchart': Icons.addchart,
      'adjust': Icons.adjust,
      'admin_panel_settings': Icons.admin_panel_settings,
      'adobe': Icons.adobe,
      'ads_click': Icons.ads_click,
      'agriculture': Icons.agriculture,
      'air': Icons.air,
      'airline_seat_flat': Icons.airline_seat_flat,
      'airline_seat_flat_angled': Icons.airline_seat_flat_angled,
      'airline_seat_individual_suite': Icons.airline_seat_individual_suite,
      'airline_seat_legroom_extra': Icons.airline_seat_legroom_extra,
      'airline_seat_legroom_normal': Icons.airline_seat_legroom_normal,
      'airline_seat_legroom_reduced': Icons.airline_seat_legroom_reduced,
      'airline_seat_recline_extra': Icons.airline_seat_recline_extra,
      'airline_seat_recline_normal': Icons.airline_seat_recline_normal,
      'airline_stops': Icons.airline_stops,
      'airlines': Icons.airlines,
      'airplane_ticket': Icons.airplane_ticket,
      'airplanemode_active': Icons.airplanemode_active,
      'airplanemode_inactive': Icons.airplanemode_inactive,
      'airplay': Icons.airplay,
      'airport_shuttle': Icons.airport_shuttle,
      'alarm': Icons.alarm,
      'alarm_add': Icons.alarm_add,
      'alarm_off': Icons.alarm_off,
      'alarm_on': Icons.alarm_on,
      'album': Icons.album,
      'align_horizontal_center': Icons.align_horizontal_center,
      'align_horizontal_left': Icons.align_horizontal_left,
      'align_horizontal_right': Icons.align_horizontal_right,
      'align_vertical_bottom': Icons.align_vertical_bottom,
      'align_vertical_center': Icons.align_vertical_center,
      'align_vertical_top': Icons.align_vertical_top,
      'all_inbox': Icons.all_inbox,
      'all_inclusive': Icons.all_inclusive,
      'all_out': Icons.all_out,
      'alt_route': Icons.alt_route,
      'alternate_email': Icons.alternate_email,
      'analytics': Icons.analytics,
      'anchor': Icons.anchor,
      'android': Icons.android,
      'animation': Icons.animation,
      'announcement': Icons.announcement,
      'aod': Icons.aod,
      'apartment': Icons.apartment,
      'api': Icons.api,
      'app_blocking': Icons.app_blocking,
      'app_registration': Icons.app_registration,
      'app_settings_alt': Icons.app_settings_alt,
      'app_shortcut': Icons.app_shortcut,
      'approval': Icons.approval,
      'apps': Icons.apps,
      'apps_outage': Icons.apps_outage,
      'architecture': Icons.architecture,
      'archive': Icons.archive,
      'area_chart': Icons.area_chart,
      'arrow_back': Icons.arrow_back,
      'arrow_back_ios': Icons.arrow_back_ios,
      'arrow_back_ios_new': Icons.arrow_back_ios_new,
      'arrow_circle_down': Icons.arrow_circle_down,
      'arrow_circle_left': Icons.arrow_circle_left,
      'arrow_circle_right': Icons.arrow_circle_right,
      'arrow_circle_up': Icons.arrow_circle_up,
      'arrow_downward': Icons.arrow_downward,
      'arrow_drop_down': Icons.arrow_drop_down,
      'arrow_drop_down_circle': Icons.arrow_drop_down_circle,
      'arrow_drop_up': Icons.arrow_drop_up,
      'arrow_forward': Icons.arrow_forward,
      'arrow_forward_ios': Icons.arrow_forward_ios,
      'arrow_forward_rounded': Icons.arrow_forward_rounded,
      'arrow_left': Icons.arrow_left,
      'arrow_outward': Icons.arrow_outward,
      'arrow_right': Icons.arrow_right,
      'arrow_right_alt': Icons.arrow_right_alt,
      'arrow_upward': Icons.arrow_upward,
      'art_track': Icons.art_track,
      'article': Icons.article,
      'aspect_ratio': Icons.aspect_ratio,
      'assessment': Icons.assessment,
      'assignment': Icons.assignment,
      'assignment_ind': Icons.assignment_ind,
      'assignment_late': Icons.assignment_late,
      'assignment_return': Icons.assignment_return,
      'assignment_returned': Icons.assignment_returned,
      'assignment_turned_in': Icons.assignment_turned_in,
      'assist_walker': Icons.assist_walker,
      'assistant': Icons.assistant,
      'assistant_direction': Icons.assistant_direction,
      'assistant_photo': Icons.assistant_photo,
      'assured_workload': Icons.assured_workload,
      'atm': Icons.atm,
      'attach_email': Icons.attach_email,
      'attach_file': Icons.attach_file,
      'attach_money': Icons.attach_money,
      'attachment': Icons.attachment,
      'attractions': Icons.attractions,
      'attribution': Icons.attribution,
      'audio_file': Icons.audio_file,
      'audiotrack': Icons.audiotrack,
      'auto_awesome': Icons.auto_awesome,
      'auto_awesome_mosaic': Icons.auto_awesome_mosaic,
      'auto_awesome_motion': Icons.auto_awesome_motion,
      'auto_delete': Icons.auto_delete,
      'auto_fix_high': Icons.auto_fix_high,
      'auto_fix_normal': Icons.auto_fix_normal,
      'auto_fix_off': Icons.auto_fix_off,
      'auto_graph': Icons.auto_graph,
      'auto_mode': Icons.auto_mode,
      'auto_stories': Icons.auto_stories,
      'autofps_select': Icons.autofps_select,
      'autorenew': Icons.autorenew,
      'av_timer': Icons.av_timer,

      // B
      'baby_changing_station': Icons.baby_changing_station,
      'back_hand': Icons.back_hand,
      'backpack': Icons.backpack,
      'backspace': Icons.backspace,
      'backup': Icons.backup,
      'backup_table': Icons.backup_table,
      'badge': Icons.badge,
      'bakery_dining': Icons.bakery_dining,
      'balance': Icons.balance,
      'balcony': Icons.balcony,
      'ballot': Icons.ballot,
      'bar_chart': Icons.bar_chart,
      'batch_prediction': Icons.batch_prediction,
      'bathroom': Icons.bathroom,
      'bathtub': Icons.bathtub,
      'battery_0_bar': Icons.battery_0_bar,
      'battery_1_bar': Icons.battery_1_bar,
      'battery_2_bar': Icons.battery_2_bar,
      'battery_3_bar': Icons.battery_3_bar,
      'battery_4_bar': Icons.battery_4_bar,
      'battery_5_bar': Icons.battery_5_bar,
      'battery_6_bar': Icons.battery_6_bar,
      'battery_alert': Icons.battery_alert,
      'battery_charging_full': Icons.battery_charging_full,
      'battery_full': Icons.battery_full,
      'battery_saver': Icons.battery_saver,
      'battery_std': Icons.battery_std,
      'battery_unknown': Icons.battery_unknown,
      'beach_access': Icons.beach_access,
      'bed': Icons.bed,
      'bedroom_baby': Icons.bedroom_baby,
      'bedroom_child': Icons.bedroom_child,
      'bedroom_parent': Icons.bedroom_parent,
      'bedtime': Icons.bedtime,
      'bedtime_off': Icons.bedtime_off,
      'beenhere': Icons.beenhere,
      'bento': Icons.bento,
      'bike_scooter': Icons.bike_scooter,
      'biotech': Icons.biotech,
      'blender': Icons.blender,
      'blind': Icons.blind,
      'blinds': Icons.blinds,
      'blinds_closed': Icons.blinds_closed,
      'block': Icons.block,
      'bloodtype': Icons.bloodtype,
      'bluetooth': Icons.bluetooth,
      'bluetooth_audio': Icons.bluetooth_audio,
      'bluetooth_connected': Icons.bluetooth_connected,
      'bluetooth_disabled': Icons.bluetooth_disabled,
      'bluetooth_drive': Icons.bluetooth_drive,
      'bluetooth_searching': Icons.bluetooth_searching,
      'blur_circular': Icons.blur_circular,
      'blur_linear': Icons.blur_linear,
      'blur_off': Icons.blur_off,
      'blur_on': Icons.blur_on,
      'bolt': Icons.bolt,
      'book': Icons.book,
      'book_online': Icons.book_online,
      'bookmark': Icons.bookmark,
      'bookmark_add': Icons.bookmark_add,
      'bookmark_added': Icons.bookmark_added,
      'bookmark_border': Icons.bookmark_border,
      'bookmark_outline': Icons.bookmark_outline,
      'bookmark_remove': Icons.bookmark_remove,
      'bookmarks': Icons.bookmarks,
      'border_all': Icons.border_all,
      'border_bottom': Icons.border_bottom,
      'border_clear': Icons.border_clear,
      'border_color': Icons.border_color,
      'border_horizontal': Icons.border_horizontal,
      'border_inner': Icons.border_inner,
      'border_left': Icons.border_left,
      'border_outer': Icons.border_outer,
      'border_right': Icons.border_right,
      'border_style': Icons.border_style,
      'border_top': Icons.border_top,
      'border_vertical': Icons.border_vertical,
      'boy': Icons.boy,
      'branding_watermark': Icons.branding_watermark,
      'breakfast_dining': Icons.breakfast_dining,
      'brightness_1': Icons.brightness_1,
      'brightness_2': Icons.brightness_2,
      'brightness_3': Icons.brightness_3,
      'brightness_4': Icons.brightness_4,
      'brightness_5': Icons.brightness_5,
      'brightness_6': Icons.brightness_6,
      'brightness_7': Icons.brightness_7,
      'brightness_auto': Icons.brightness_auto,
      'brightness_high': Icons.brightness_high,
      'brightness_low': Icons.brightness_low,
      'brightness_medium': Icons.brightness_medium,
      'broken_image': Icons.broken_image,
      'browse_gallery': Icons.browse_gallery,
      'browser_not_supported': Icons.browser_not_supported,
      'browser_updated': Icons.browser_updated,
      'brunch_dining': Icons.brunch_dining,
      'brush': Icons.brush,
      'bubble_chart': Icons.bubble_chart,
      'bug_report': Icons.bug_report,
      'build': Icons.build,
      'build_circle': Icons.build_circle,
      'bungalow': Icons.bungalow,
      'burst_mode': Icons.burst_mode,
      'bus_alert': Icons.bus_alert,
      'business': Icons.business,
      'business_center': Icons.business_center,

      // C
      'cabin': Icons.cabin,
      'cable': Icons.cable,
      'cached': Icons.cached,
      'cake': Icons.cake,
      'calculate': Icons.calculate,
      'calendar_month': Icons.calendar_month,
      'calendar_today': Icons.calendar_today,
      'calendar_view_day': Icons.calendar_view_day,
      'calendar_view_month': Icons.calendar_view_month,
      'calendar_view_week': Icons.calendar_view_week,
      'call': Icons.call,
      'call_end': Icons.call_end,
      'call_made': Icons.call_made,
      'call_merge': Icons.call_merge,
      'call_missed': Icons.call_missed,
      'call_missed_outgoing': Icons.call_missed_outgoing,
      'call_received': Icons.call_received,
      'call_split': Icons.call_split,
      'call_to_action': Icons.call_to_action,
      'camera': Icons.camera,
      'camera_alt': Icons.camera_alt,
      'camera_enhance': Icons.camera_enhance,
      'camera_front': Icons.camera_front,
      'camera_indoor': Icons.camera_indoor,
      'camera_outdoor': Icons.camera_outdoor,
      'camera_rear': Icons.camera_rear,
      'camera_roll': Icons.camera_roll,
      'cameraswitch': Icons.cameraswitch,
      'campaign': Icons.campaign,
      'cancel': Icons.cancel,
      'cancel_presentation': Icons.cancel_presentation,
      'cancel_schedule_send': Icons.cancel_schedule_send,
      'candlestick_chart': Icons.candlestick_chart,
      'car_crash': Icons.car_crash,
      'car_rental': Icons.car_rental,
      'car_repair': Icons.car_repair,
      'card_giftcard': Icons.card_giftcard,
      'card_membership': Icons.card_membership,
      'card_travel': Icons.card_travel,
      'carpenter': Icons.carpenter,
      'cases': Icons.cases,
      'casino': Icons.casino,
      'cast': Icons.cast,
      'cast_connected': Icons.cast_connected,
      'cast_for_education': Icons.cast_for_education,
      'castle': Icons.castle,
      'catching_pokemon': Icons.catching_pokemon,
      'category': Icons.category,
      'celebration': Icons.celebration,
      'cell_tower': Icons.cell_tower,
      'cell_wifi': Icons.cell_wifi,
      'center_focus_strong': Icons.center_focus_strong,
      'center_focus_weak': Icons.center_focus_weak,
      'chair': Icons.chair,
      'chair_alt': Icons.chair_alt,
      'chalet': Icons.chalet,
      'change_circle': Icons.change_circle,
      'change_history': Icons.change_history,
      'charging_station': Icons.charging_station,
      'chat': Icons.chat,
      'chat_bubble': Icons.chat_bubble,
      'chat_bubble_outline': Icons.chat_bubble_outline,
      'check': Icons.check,
      'check_box': Icons.check_box,
      'check_box_outline_blank': Icons.check_box_outline_blank,
      'check_circle': Icons.check_circle,
      'check_circle_outline': Icons.check_circle_outline,
      'checklist': Icons.checklist,
      'checklist_rtl': Icons.checklist_rtl,
      'checkroom': Icons.checkroom,
      'chevron_left': Icons.chevron_left,
      'chevron_right': Icons.chevron_right,
      'child_care': Icons.child_care,
      'child_friendly': Icons.child_friendly,
      'chrome_reader_mode': Icons.chrome_reader_mode,
      'church': Icons.church,
      'circle': Icons.circle,
      'circle_notifications': Icons.circle_notifications,
      'class_': Icons.class_,
      'clean_hands': Icons.clean_hands,
      'cleaning_services': Icons.cleaning_services,
      'clear': Icons.clear,
      'clear_all': Icons.clear_all,
      'close': Icons.close,
      'close_fullscreen': Icons.close_fullscreen,
      'closed_caption': Icons.closed_caption,
      'closed_caption_disabled': Icons.closed_caption_disabled,
      'closed_caption_off': Icons.closed_caption_off,
      'cloud': Icons.cloud,
      'cloud_circle': Icons.cloud_circle,
      'cloud_done': Icons.cloud_done,
      'cloud_download': Icons.cloud_download,
      'cloud_off': Icons.cloud_off,
      'cloud_queue': Icons.cloud_queue,
      'cloud_sync': Icons.cloud_sync,
      'cloud_upload': Icons.cloud_upload,
      'co2': Icons.co2,
      'co_present': Icons.co_present,
      'code': Icons.code,
      'code_off': Icons.code_off,
      'coffee': Icons.coffee,
      'coffee_maker': Icons.coffee_maker,
      'collections': Icons.collections,
      'collections_bookmark': Icons.collections_bookmark,
      'color_lens': Icons.color_lens,
      'colorize': Icons.colorize,
      'comment': Icons.comment,
      'comment_bank': Icons.comment_bank,
      'comments_disabled': Icons.comments_disabled,
      'commit': Icons.commit,
      'commute': Icons.commute,
      'compare': Icons.compare,
      'compare_arrows': Icons.compare_arrows,
      'compass_calibration': Icons.compass_calibration,
      'compost': Icons.compost,
      'compress': Icons.compress,
      'computer': Icons.computer,
      'confirmation_num': Icons.confirmation_num,
      'confirmation_number': Icons.confirmation_number,
      'connect_without_contact': Icons.connect_without_contact,
      'connected_tv': Icons.connected_tv,
      'connecting_airports': Icons.connecting_airports,
      'construction': Icons.construction,
      'contact_emergency': Icons.contact_emergency,
      'contact_mail': Icons.contact_mail,
      'contact_page': Icons.contact_page,
      'contact_phone': Icons.contact_phone,
      'contact_support': Icons.contact_support,
      'contactless': Icons.contactless,
      'contacts': Icons.contacts,
      'content_copy': Icons.content_copy,
      'content_cut': Icons.content_cut,
      'content_paste': Icons.content_paste,
      'content_paste_go': Icons.content_paste_go,
      'content_paste_off': Icons.content_paste_off,
      'content_paste_search': Icons.content_paste_search,
      'contrast': Icons.contrast,
      'control_camera': Icons.control_camera,
      'control_point': Icons.control_point,
      'control_point_duplicate': Icons.control_point_duplicate,
      'cookie': Icons.cookie,
      'copy_all': Icons.copy_all,
      'copyright': Icons.copyright,
      'coronavirus': Icons.coronavirus,
      'corporate_fare': Icons.corporate_fare,
      'cottage': Icons.cottage,
      'countertops': Icons.countertops,
      'create': Icons.create,
      'create_new_folder': Icons.create_new_folder,
      'credit_card': Icons.credit_card,
      'credit_card_off': Icons.credit_card_off,
      'credit_score': Icons.credit_score,
      'crib': Icons.crib,
      'crisis_alert': Icons.crisis_alert,
      'crop': Icons.crop,
      'crop_16_9': Icons.crop_16_9,
      'crop_3_2': Icons.crop_3_2,
      'crop_5_4': Icons.crop_5_4,
      'crop_7_5': Icons.crop_7_5,
      'crop_din': Icons.crop_din,
      'crop_free': Icons.crop_free,
      'crop_landscape': Icons.crop_landscape,
      'crop_original': Icons.crop_original,
      'crop_portrait': Icons.crop_portrait,
      'crop_rotate': Icons.crop_rotate,
      'crop_square': Icons.crop_square,
      'cruelty_free': Icons.cruelty_free,
      'css': Icons.css,
      'currency_bitcoin': Icons.currency_bitcoin,
      'currency_exchange': Icons.currency_exchange,
      'currency_franc': Icons.currency_franc,
      'currency_lira': Icons.currency_lira,
      'currency_pound': Icons.currency_pound,
      'currency_ruble': Icons.currency_ruble,
      'currency_rupee': Icons.currency_rupee,
      'currency_yen': Icons.currency_yen,
      'currency_yuan': Icons.currency_yuan,
      'curtains': Icons.curtains,
      'curtains_closed': Icons.curtains_closed,

      // D
      'dangerous': Icons.dangerous,
      'dark_mode': Icons.dark_mode,
      'dark_mode_outlined': Icons.dark_mode_outlined,
      'dashboard': Icons.dashboard,
      'dashboard_customize': Icons.dashboard_customize,
      'data_array': Icons.data_array,
      'data_exploration': Icons.data_exploration,
      'data_object': Icons.data_object,
      'data_saver_off': Icons.data_saver_off,
      'data_saver_on': Icons.data_saver_on,
      'data_thresholding': Icons.data_thresholding,
      'data_usage': Icons.data_usage,
      'date_range': Icons.date_range,
      'deblur': Icons.deblur,
      'deck': Icons.deck,
      'dehaze': Icons.dehaze,
      'delete': Icons.delete,
      'delete_forever': Icons.delete_forever,
      'delete_outline': Icons.delete_outline,
      'delete_sweep': Icons.delete_sweep,
      'delivery_dining': Icons.delivery_dining,
      'density_large': Icons.density_large,
      'density_medium': Icons.density_medium,
      'density_small': Icons.density_small,
      'departure_board': Icons.departure_board,
      'description': Icons.description,
      'deselect': Icons.deselect,
      'design_services': Icons.design_services,
      'desk': Icons.desk,
      'desktop_access_disabled': Icons.desktop_access_disabled,
      'desktop_mac': Icons.desktop_mac,
      'desktop_windows': Icons.desktop_windows,
      'details': Icons.details,
      'developer_board': Icons.developer_board,
      'developer_board_off': Icons.developer_board_off,
      'developer_mode': Icons.developer_mode,
      'device_hub': Icons.device_hub,
      'device_thermostat': Icons.device_thermostat,
      'device_unknown': Icons.device_unknown,
      'devices': Icons.devices,
      'devices_fold': Icons.devices_fold,
      'devices_other': Icons.devices_other,
      'dew_point': Icons.dew_point,
      'dialer_sip': Icons.dialer_sip,
      'dialpad': Icons.dialpad,
      'diamond': Icons.diamond,
      'difference': Icons.difference,
      'dining': Icons.dining,
      'dinner_dining': Icons.dinner_dining,
      'directions': Icons.directions,
      'directions_bike': Icons.directions_bike,
      'directions_boat': Icons.directions_boat,
      'directions_boat_filled': Icons.directions_boat_filled,
      'directions_bus': Icons.directions_bus,
      'directions_bus_filled': Icons.directions_bus_filled,
      'directions_car': Icons.directions_car,
      'directions_car_filled': Icons.directions_car_filled,
      'directions_ferry': Icons.directions_ferry,
      'directions_off': Icons.directions_off,
      'directions_railway': Icons.directions_railway,
      'directions_railway_filled': Icons.directions_railway_filled,
      'directions_run': Icons.directions_run,
      'directions_subway': Icons.directions_subway,
      'directions_subway_filled': Icons.directions_subway_filled,
      'directions_transit': Icons.directions_transit,
      'directions_transit_filled': Icons.directions_transit_filled,
      'directions_walk': Icons.directions_walk,
      'dirty_lens': Icons.dirty_lens,
      'disabled_by_default': Icons.disabled_by_default,
      'disabled_visible': Icons.disabled_visible,
      'disc_full': Icons.disc_full,
      'discord': Icons.discord,
      'discount': Icons.discount,
      'display_settings': Icons.display_settings,
      'diversity_1': Icons.diversity_1,
      'diversity_2': Icons.diversity_2,
      'diversity_3': Icons.diversity_3,
      'dns': Icons.dns,
      'do_disturb': Icons.do_disturb,
      'do_disturb_alt': Icons.do_disturb_alt,
      'do_disturb_off': Icons.do_disturb_off,
      'do_disturb_on': Icons.do_disturb_on,
      'do_not_disturb': Icons.do_not_disturb,
      'do_not_disturb_alt': Icons.do_not_disturb_alt,
      'do_not_disturb_off': Icons.do_not_disturb_off,
      'do_not_disturb_on': Icons.do_not_disturb_on,
      'do_not_disturb_on_total_silence': Icons.do_not_disturb_on_total_silence,
      'do_not_step': Icons.do_not_step,
      'do_not_touch': Icons.do_not_touch,
      'dock': Icons.dock,
      'document_scanner': Icons.document_scanner,
      'domain': Icons.domain,
      'domain_add': Icons.domain_add,
      'domain_disabled': Icons.domain_disabled,
      'domain_verification': Icons.domain_verification,
      'done': Icons.done,
      'done_all': Icons.done_all,
      'done_outline': Icons.done_outline,
      'donut_large': Icons.donut_large,
      'donut_small': Icons.donut_small,
      'door_back': Icons.door_back_door,
      'door_front': Icons.door_front_door,
      'door_sliding': Icons.door_sliding,
      'doorbell': Icons.doorbell,
      'double_arrow': Icons.double_arrow,
      'downhill_skiing': Icons.downhill_skiing,
      'download': Icons.download,
      'download_done': Icons.download_done,
      'download_for_offline': Icons.download_for_offline,
      'downloading': Icons.downloading,
      'drafts': Icons.drafts,
      'drag_handle': Icons.drag_handle,
      'drag_indicator': Icons.drag_indicator,
      'draw': Icons.draw,
      'drive_eta': Icons.drive_eta,
      'drive_file_move': Icons.drive_file_move,
      'drive_file_move_outline': Icons.drive_file_move_outline,
      'drive_file_move_rtl': Icons.drive_file_move_rtl,
      'drive_file_rename_outline': Icons.drive_file_rename_outline,
      'drive_folder_upload': Icons.drive_folder_upload,
      'dry': Icons.dry,
      'dry_cleaning': Icons.dry_cleaning,
      'duo': Icons.duo,
      'dvr': Icons.dvr,
      'dynamic_feed': Icons.dynamic_feed,
      'dynamic_form': Icons.dynamic_form,

      // E
      'e_mobiledata': Icons.e_mobiledata,
      'earbuds': Icons.earbuds,
      'earbuds_battery': Icons.earbuds_battery,
      'east': Icons.east,
      'eco': Icons.eco,
      'edgesensor_high': Icons.edgesensor_high,
      'edgesensor_low': Icons.edgesensor_low,
      'edit': Icons.edit,
      'edit_attributes': Icons.edit_attributes,
      'edit_calendar': Icons.edit_calendar,
      'edit_document': Icons.edit_document,
      'edit_location': Icons.edit_location,
      'edit_location_alt': Icons.edit_location_alt,
      'edit_note': Icons.edit_note,
      'edit_notifications': Icons.edit_notifications,
      'edit_off': Icons.edit_off,
      'edit_outlined': Icons.edit_outlined,
      'edit_road': Icons.edit_road,
      'egg': Icons.egg,
      'egg_alt': Icons.egg_alt,
      'eject': Icons.eject,
      'elderly': Icons.elderly,
      'elderly_woman': Icons.elderly_woman,
      'electric_bike': Icons.electric_bike,
      'electric_bolt': Icons.electric_bolt,
      'electric_car': Icons.electric_car,
      'electric_meter': Icons.electric_meter,
      'electric_moped': Icons.electric_moped,
      'electric_rickshaw': Icons.electric_rickshaw,
      'electric_scooter': Icons.electric_scooter,
      'electrical_services': Icons.electrical_services,
      'elevator': Icons.elevator,
      'email': Icons.email,
      'emergency': Icons.emergency,
      'emergency_recording': Icons.emergency_recording,
      'emergency_share': Icons.emergency_share,
      'emoji_emotions': Icons.emoji_emotions,
      'emoji_events': Icons.emoji_events,
      'emoji_flags': Icons.emoji_flags,
      'emoji_food_beverage': Icons.emoji_food_beverage,
      'emoji_nature': Icons.emoji_nature,
      'emoji_objects': Icons.emoji_objects,
      'emoji_people': Icons.emoji_people,
      'emoji_symbols': Icons.emoji_symbols,
      'emoji_transportation': Icons.emoji_transportation,
      'engineering': Icons.engineering,
      'enhance_photo_translate': Icons.enhance_photo_translate,
      'enhanced_encryption': Icons.enhanced_encryption,
      'equalizer': Icons.equalizer,
      'error': Icons.error,
      'error_outline': Icons.error_outline,
      'escalator': Icons.escalator,
      'escalator_warning': Icons.escalator_warning,
      'euro': Icons.euro,
      'euro_symbol': Icons.euro_symbol,
      'ev_station': Icons.ev_station,
      'event': Icons.event,
      'event_available': Icons.event_available,
      'event_busy': Icons.event_busy,
      'event_note': Icons.event_note,
      'event_repeat': Icons.event_repeat,
      'event_seat': Icons.event_seat,
      'exit_to_app': Icons.exit_to_app,
      'expand': Icons.expand,
      'expand_circle_down': Icons.expand_circle_down,
      'expand_less': Icons.expand_less,
      'expand_more': Icons.expand_more,
      'explicit': Icons.explicit,
      'explore': Icons.explore,
      'explore_off': Icons.explore_off,
      'exposure': Icons.exposure,
      'exposure_neg_1': Icons.exposure_neg_1,
      'exposure_neg_2': Icons.exposure_neg_2,
      'exposure_plus_1': Icons.exposure_plus_1,
      'exposure_plus_2': Icons.exposure_plus_2,
      'exposure_zero': Icons.exposure_zero,
      'extension': Icons.extension,
      'extension_off': Icons.extension_off,

      // F
      'face': Icons.face,
      'face_2': Icons.face_2,
      'face_3': Icons.face_3,
      'face_4': Icons.face_4,
      'face_5': Icons.face_5,
      'face_6': Icons.face_6,
      'face_retouching_natural': Icons.face_retouching_natural,
      'face_retouching_off': Icons.face_retouching_off,
      'fact_check': Icons.fact_check,
      'factory': Icons.factory,
      'family_restroom': Icons.family_restroom,
      'fast_forward': Icons.fast_forward,
      'fast_rewind': Icons.fast_rewind,
      'fastfood': Icons.fastfood,
      'favorite': Icons.favorite,
      'favorite_border': Icons.favorite_border,
      'favorite_outline': Icons.favorite_outline,
      'fax': Icons.fax,
      'featured_play_list': Icons.featured_play_list,
      'featured_video': Icons.featured_video,
      'feed': Icons.feed,
      'feedback': Icons.feedback,
      'female': Icons.female,
      'fence': Icons.fence,
      'festival': Icons.festival,
      'fiber_dvr': Icons.fiber_dvr,
      'fiber_manual_record': Icons.fiber_manual_record,
      'fiber_new': Icons.fiber_new,
      'fiber_pin': Icons.fiber_pin,
      'fiber_smart_record': Icons.fiber_smart_record,
      'file_copy': Icons.file_copy,
      'file_download': Icons.file_download,
      'file_download_done': Icons.file_download_done,
      'file_download_off': Icons.file_download_off,
      'file_open': Icons.file_open,
      'file_present': Icons.file_present,
      'file_upload': Icons.file_upload,
      'filter': Icons.filter,
      'filter_1': Icons.filter_1,
      'filter_2': Icons.filter_2,
      'filter_3': Icons.filter_3,
      'filter_4': Icons.filter_4,
      'filter_5': Icons.filter_5,
      'filter_6': Icons.filter_6,
      'filter_7': Icons.filter_7,
      'filter_8': Icons.filter_8,
      'filter_9': Icons.filter_9,
      'filter_9_plus': Icons.filter_9_plus,
      'filter_alt': Icons.filter_alt,
      'filter_alt_off': Icons.filter_alt_off,
      'filter_b_and_w': Icons.filter_b_and_w,
      'filter_center_focus': Icons.filter_center_focus,
      'filter_drama': Icons.filter_drama,
      'filter_frames': Icons.filter_frames,
      'filter_hdr': Icons.filter_hdr,
      'filter_list': Icons.filter_list,
      'filter_list_alt': Icons.filter_list_alt,
      'filter_list_off': Icons.filter_list_off,
      'filter_none': Icons.filter_none,
      'filter_tilt_shift': Icons.filter_tilt_shift,
      'filter_vintage': Icons.filter_vintage,
      'find_in_page': Icons.find_in_page,
      'find_replace': Icons.find_replace,
      'fingerprint': Icons.fingerprint,
      'fire_extinguisher': Icons.fire_extinguisher,
      'fire_hydrant': Icons.fire_hydrant,
      'fire_truck': Icons.fire_truck,
      'fireplace': Icons.fireplace,
      'first_page': Icons.first_page,
      'fit_screen': Icons.fit_screen,
      'fitness_center': Icons.fitness_center,
      'flag': Icons.flag,
      'flag_circle': Icons.flag_circle,
      'flaky': Icons.flaky,
      'flare': Icons.flare,
      'flash_auto': Icons.flash_auto,
      'flash_off': Icons.flash_off,
      'flash_on': Icons.flash_on,
      'flashlight_off': Icons.flashlight_off,
      'flashlight_on': Icons.flashlight_on,
      'flatware': Icons.flatware,
      'flight': Icons.flight,
      'flight_class': Icons.flight_class,
      'flight_land': Icons.flight_land,
      'flight_takeoff': Icons.flight_takeoff,
      'flip': Icons.flip,
      'flip_camera_android': Icons.flip_camera_android,
      'flip_camera_ios': Icons.flip_camera_ios,
      'flip_to_back': Icons.flip_to_back,
      'flip_to_front': Icons.flip_to_front,
      'flood': Icons.flood,
      'fluorescent': Icons.fluorescent,
      'flutter_dash': Icons.flutter_dash,
      'fmd_bad': Icons.fmd_bad,
      'fmd_good': Icons.fmd_good,
      'folder': Icons.folder,
      'folder_copy': Icons.folder_copy,
      'folder_delete': Icons.folder_delete,
      'folder_off': Icons.folder_off,
      'folder_open': Icons.folder_open,
      'folder_shared': Icons.folder_shared,
      'folder_special': Icons.folder_special,
      'folder_zip': Icons.folder_zip,
      'follow_the_signs': Icons.follow_the_signs,
      'font_download': Icons.font_download,
      'font_download_off': Icons.font_download_off,
      'food_bank': Icons.food_bank,
      'forest': Icons.forest,
      'fork_left': Icons.fork_left,
      'fork_right': Icons.fork_right,
      'format_align_center': Icons.format_align_center,
      'format_align_justify': Icons.format_align_justify,
      'format_align_left': Icons.format_align_left,
      'format_align_right': Icons.format_align_right,
      'format_bold': Icons.format_bold,
      'format_clear': Icons.format_clear,
      'format_color_fill': Icons.format_color_fill,
      'format_color_reset': Icons.format_color_reset,
      'format_color_text': Icons.format_color_text,
      'format_indent_decrease': Icons.format_indent_decrease,
      'format_indent_increase': Icons.format_indent_increase,
      'format_italic': Icons.format_italic,
      'format_line_spacing': Icons.format_line_spacing,
      'format_list_bulleted': Icons.format_list_bulleted,
      'format_list_numbered': Icons.format_list_numbered,
      'format_list_numbered_rtl': Icons.format_list_numbered_rtl,
      'format_overline': Icons.format_overline,
      'format_paint': Icons.format_paint,
      'format_quote': Icons.format_quote,
      'format_shapes': Icons.format_shapes,
      'format_size': Icons.format_size,
      'format_strikethrough': Icons.format_strikethrough,
      'format_textdirection_l_to_r': Icons.format_textdirection_l_to_r,
      'format_textdirection_r_to_l': Icons.format_textdirection_r_to_l,
      'format_underlined': Icons.format_underlined,
      'forum': Icons.forum,
      'forward': Icons.forward,
      'forward_10': Icons.forward_10,
      'forward_30': Icons.forward_30,
      'forward_5': Icons.forward_5,
      'forward_to_inbox': Icons.forward_to_inbox,
      'foundation': Icons.foundation,
      'free_breakfast': Icons.free_breakfast,
      'free_cancellation': Icons.free_cancellation,
      'front_hand': Icons.front_hand,
      'fullscreen': Icons.fullscreen,
      'fullscreen_exit': Icons.fullscreen_exit,
      'functions': Icons.functions,

      // G
      'g_mobiledata': Icons.g_mobiledata,
      'g_translate': Icons.g_translate,
      'gamepad': Icons.gamepad,
      'games': Icons.games,
      'garage': Icons.garage,
      'gas_meter': Icons.gas_meter,
      'gavel': Icons.gavel,
      'generating_tokens': Icons.generating_tokens,
      'gesture': Icons.gesture,
      'get_app': Icons.get_app,
      'gif': Icons.gif,
      'gif_box': Icons.gif_box,
      'girl': Icons.girl,
      'gite': Icons.gite,
      'golf_course': Icons.golf_course,
      'gpp_bad': Icons.gpp_bad,
      'gpp_good': Icons.gpp_good,
      'gpp_maybe': Icons.gpp_maybe,
      'gps_fixed': Icons.gps_fixed,
      'gps_not_fixed': Icons.gps_not_fixed,
      'gps_off': Icons.gps_off,
      'grade': Icons.grade,
      'gradient': Icons.gradient,
      'grading': Icons.grading,
      'grain': Icons.grain,
      'graphic_eq': Icons.graphic_eq,
      'grass': Icons.grass,
      'grid_3x3': Icons.grid_3x3,
      'grid_4x4': Icons.grid_4x4,
      'grid_goldenratio': Icons.grid_goldenratio,
      'grid_off': Icons.grid_off,
      'grid_on': Icons.grid_on,
      'grid_view': Icons.grid_view,
      'group': Icons.group,
      'group_add': Icons.group_add,
      'group_off': Icons.group_off,
      'group_remove': Icons.group_remove,
      'group_work': Icons.group_work,
      'groups': Icons.groups,
      'groups_2': Icons.groups_2,
      'groups_3': Icons.groups_3,
      'h_mobiledata': Icons.h_mobiledata,
      'h_plus_mobiledata': Icons.h_plus_mobiledata,

      // H
      'hail': Icons.hail,
      'handshake': Icons.handshake,
      'handyman': Icons.handyman,
      'hardware': Icons.hardware,
      'hd': Icons.hd,
      'hdr_auto': Icons.hdr_auto,
      'hdr_auto_select': Icons.hdr_auto_select,
      'hdr_enhanced_select': Icons.hdr_enhanced_select,
      'hdr_off': Icons.hdr_off,
      'hdr_off_select': Icons.hdr_off_select,
      'hdr_on': Icons.hdr_on,
      'hdr_on_select': Icons.hdr_on_select,
      'hdr_plus': Icons.hdr_plus,
      'hdr_strong': Icons.hdr_strong,
      'hdr_weak': Icons.hdr_weak,
      'headphones': Icons.headphones,
      'headphones_battery': Icons.headphones_battery,
      'headset': Icons.headset,
      'headset_mic': Icons.headset_mic,
      'headset_off': Icons.headset_off,
      'healing': Icons.healing,
      'health_and_safety': Icons.health_and_safety,
      'hearing': Icons.hearing,
      'hearing_disabled': Icons.hearing_disabled,
      'heart_broken': Icons.heart_broken,
      'heat_pump': Icons.heat_pump,
      'height': Icons.height,
      'help': Icons.help,
      'help_center': Icons.help_center,
      'help_outline': Icons.help_outline,
      'hevc': Icons.hevc,
      'hexagon': Icons.hexagon,
      'hide_image': Icons.hide_image,
      'hide_source': Icons.hide_source,
      'high_quality': Icons.high_quality,
      'highlight': Icons.highlight,
      'highlight_alt': Icons.highlight_alt,
      'highlight_off': Icons.highlight_off,
      'highlight_remove': Icons.highlight_remove,
      'hiking': Icons.hiking,
      'history': Icons.history,
      'history_edu': Icons.history_edu,
      'history_toggle_off': Icons.history_toggle_off,
      'hive': Icons.hive,
      'hls': Icons.hls,
      'hls_off': Icons.hls_off,
      'holiday_village': Icons.holiday_village,
      'home': Icons.home,
      'home_filled': Icons.home_filled,
      'home_max': Icons.home_max,
      'home_mini': Icons.home_mini,
      'home_outlined': Icons.home_outlined,
      'home_repair_service': Icons.home_repair_service,
      'home_work': Icons.home_work,
      'horizontal_distribute': Icons.horizontal_distribute,
      'horizontal_rule': Icons.horizontal_rule,
      'horizontal_split': Icons.horizontal_split,
      'hot_tub': Icons.hot_tub,
      'hotel': Icons.hotel,
      'hotel_class': Icons.hotel_class,
      'hourglass_bottom': Icons.hourglass_bottom,
      'hourglass_disabled': Icons.hourglass_disabled,
      'hourglass_empty': Icons.hourglass_empty,
      'hourglass_full': Icons.hourglass_full,
      'hourglass_top': Icons.hourglass_top,
      'house': Icons.house,
      'house_siding': Icons.house_siding,
      'houseboat': Icons.houseboat,
      'how_to_reg': Icons.how_to_reg,
      'how_to_vote': Icons.how_to_vote,
      'html': Icons.html,
      'http': Icons.http,
      'https': Icons.https,
      'hub': Icons.hub,
      'hvac': Icons.hvac,

      // I
      'ice_skating': Icons.ice_skating,
      'icecream': Icons.icecream,
      'image': Icons.image,
      'image_aspect_ratio': Icons.image_aspect_ratio,
      'image_not_supported': Icons.image_not_supported,
      'image_search': Icons.image_search,
      'imagesearch_roller': Icons.imagesearch_roller,
      'import_contacts': Icons.import_contacts,
      'import_export': Icons.import_export,
      'important_devices': Icons.important_devices,
      'inbox': Icons.inbox,
      'incomplete_circle': Icons.incomplete_circle,
      'indeterminate_check_box': Icons.indeterminate_check_box,
      'info': Icons.info,
      'info_outline': Icons.info_outline,
      'input': Icons.input,
      'insert_chart': Icons.insert_chart,
      'insert_chart_outlined': Icons.insert_chart_outlined,
      'insert_comment': Icons.insert_comment,
      'insert_drive_file': Icons.insert_drive_file,
      'insert_emoticon': Icons.insert_emoticon,
      'insert_invitation': Icons.insert_invitation,
      'insert_link': Icons.insert_link,
      'insert_page_break': Icons.insert_page_break,
      'insert_photo': Icons.insert_photo,
      'insights': Icons.insights,
      'install_desktop': Icons.install_desktop,
      'install_mobile': Icons.install_mobile,
      'integration_instructions': Icons.integration_instructions,
      'interests': Icons.interests,
      'interpreter_mode': Icons.interpreter_mode,
      'inventory': Icons.inventory,
      'inventory_2': Icons.inventory_2,
      'invert_colors': Icons.invert_colors,
      'invert_colors_off': Icons.invert_colors_off,
      'ios_share': Icons.ios_share,
      'iron': Icons.iron,
      'iso': Icons.iso,

      // J
      'javascript': Icons.javascript,
      'join_full': Icons.join_full,
      'join_inner': Icons.join_inner,
      'join_left': Icons.join_left,
      'join_right': Icons.join_right,
      'joystick': Icons.gamepad,
      'jpeg': Icons.image,
      'kayaking': Icons.kayaking,

      // K
      'kebab_dining': Icons.kebab_dining,
      'key': Icons.key,
      'key_off': Icons.key_off,
      'keyboard': Icons.keyboard,
      'keyboard_alt': Icons.keyboard_alt,
      'keyboard_arrow_down': Icons.keyboard_arrow_down,
      'keyboard_arrow_left': Icons.keyboard_arrow_left,
      'keyboard_arrow_right': Icons.keyboard_arrow_right,
      'keyboard_arrow_up': Icons.keyboard_arrow_up,
      'keyboard_backspace': Icons.keyboard_backspace,
      'keyboard_capslock': Icons.keyboard_capslock,
      'keyboard_command_key': Icons.keyboard_command_key,
      'keyboard_control_key': Icons.keyboard_control_key,
      'keyboard_double_arrow_down': Icons.keyboard_double_arrow_down,
      'keyboard_double_arrow_left': Icons.keyboard_double_arrow_left,
      'keyboard_double_arrow_right': Icons.keyboard_double_arrow_right,
      'keyboard_double_arrow_up': Icons.keyboard_double_arrow_up,
      'keyboard_hide': Icons.keyboard_hide,
      'keyboard_option_key': Icons.keyboard_option_key,
      'keyboard_return': Icons.keyboard_return,
      'keyboard_tab': Icons.keyboard_tab,
      'keyboard_voice': Icons.keyboard_voice,
      'king_bed': Icons.king_bed,
      'kitchen': Icons.kitchen,
      'kitesurfing': Icons.kitesurfing,

      // L
      'label': Icons.label,
      'label_important': Icons.label_important,
      'label_important_outline': Icons.label_important_outline,
      'label_off': Icons.label_off,
      'label_outline': Icons.label_outline,
      'lan': Icons.lan,
      'landscape': Icons.landscape,
      'landslide': Icons.landslide,
      'language': Icons.language,
      'laptop': Icons.laptop,
      'laptop_chromebook': Icons.laptop_chromebook,
      'laptop_mac': Icons.laptop_mac,
      'laptop_windows': Icons.laptop_windows,
      'last_page': Icons.last_page,
      'launch': Icons.launch,
      'layers': Icons.layers,
      'layers_clear': Icons.layers_clear,
      'leaderboard': Icons.leaderboard,
      'leak_add': Icons.leak_add,
      'leak_remove': Icons.leak_remove,
      'legend_toggle': Icons.legend_toggle,
      'lens': Icons.lens,
      'lens_blur': Icons.lens_blur,
      'library_add': Icons.library_add,
      'library_add_check': Icons.library_add_check,
      'library_books': Icons.library_books,
      'library_music': Icons.library_music,
      'light': Icons.light,
      'light_mode': Icons.light_mode,
      'lightbulb': Icons.lightbulb,
      'lightbulb_outline': Icons.lightbulb_outline,
      'line_axis': Icons.line_axis,
      'line_style': Icons.line_style,
      'line_weight': Icons.line_weight,
      'linear_scale': Icons.linear_scale,
      'link': Icons.link,
      'link_off': Icons.link_off,
      'linked_camera': Icons.linked_camera,
      'liquor': Icons.liquor,
      'list': Icons.list,
      'list_alt': Icons.list_alt,
      'live_help': Icons.live_help,
      'live_tv': Icons.live_tv,
      'living': Icons.living,
      'local_activity': Icons.local_activity,
      'local_airport': Icons.local_airport,
      'local_atm': Icons.local_atm,
      'local_bar': Icons.local_bar,
      'local_cafe': Icons.local_cafe,
      'local_car_wash': Icons.local_car_wash,
      'local_convenience_store': Icons.local_convenience_store,
      'local_dining': Icons.local_dining,
      'local_drink': Icons.local_drink,
      'local_fire_department': Icons.local_fire_department,
      'local_fire_department_outlined': Icons.local_fire_department_outlined,
      'local_florist': Icons.local_florist,
      'local_gas_station': Icons.local_gas_station,
      'local_grocery_store': Icons.local_grocery_store,
      'local_hospital': Icons.local_hospital,
      'local_hotel': Icons.local_hotel,
      'local_laundry_service': Icons.local_laundry_service,
      'local_library': Icons.local_library,
      'local_mall': Icons.local_mall,
      'local_movies': Icons.local_movies,
      'local_offer': Icons.local_offer,
      'local_parking': Icons.local_parking,
      'local_pharmacy': Icons.local_pharmacy,
      'local_phone': Icons.local_phone,
      'local_pizza': Icons.local_pizza,
      'local_play': Icons.local_play,
      'local_police': Icons.local_police,
      'local_post_office': Icons.local_post_office,
      'local_printshop': Icons.local_printshop,
      'local_see': Icons.local_see,
      'local_shipping': Icons.local_shipping,
      'local_taxi': Icons.local_taxi,
      'location_city': Icons.location_city,
      'location_disabled': Icons.location_disabled,
      'location_history': Icons.location_history,
      'location_off': Icons.location_off,
      'location_on': Icons.location_on,
      'location_pin': Icons.location_pin,
      'location_searching': Icons.location_searching,
      'lock': Icons.lock,
      'lock_clock': Icons.lock_clock,
      'lock_open': Icons.lock_open,
      'lock_outline': Icons.lock_outline,
      'lock_person': Icons.lock_person,
      'lock_reset': Icons.lock_reset,
      'login': Icons.login,
      'logo_dev': Icons.logo_dev,
      'logout': Icons.logout,
      'looks': Icons.looks,
      'looks_3': Icons.looks_3,
      'looks_4': Icons.looks_4,
      'looks_5': Icons.looks_5,
      'looks_6': Icons.looks_6,
      'looks_one': Icons.looks_one,
      'looks_two': Icons.looks_two,
      'loop': Icons.loop,
      'loupe': Icons.loupe,
      'low_priority': Icons.low_priority,
      'loyalty': Icons.loyalty,
      'lte_mobiledata': Icons.lte_mobiledata,
      'lte_plus_mobiledata': Icons.lte_plus_mobiledata,
      'luggage': Icons.luggage,
      'lunch_dining': Icons.lunch_dining,

      // M
      'mail': Icons.mail,
      'mail_lock': Icons.mail_lock,
      'mail_outline': Icons.mail_outline,
      'male': Icons.male,
      'man': Icons.man,
      'manage_accounts': Icons.manage_accounts,
      'manage_history': Icons.manage_history,
      'manage_search': Icons.manage_search,
      'map': Icons.map,
      'maps_home_work': Icons.maps_home_work,
      'maps_ugc': Icons.maps_ugc,
      'margin': Icons.margin,
      'mark_as_unread': Icons.mark_as_unread,
      'mark_chat_read': Icons.mark_chat_read,
      'mark_chat_unread': Icons.mark_chat_unread,
      'mark_email_read': Icons.mark_email_read,
      'mark_email_unread': Icons.mark_email_unread,
      'mark_unread_chat_alt': Icons.mark_unread_chat_alt,
      'markunread': Icons.markunread,
      'markunread_mailbox': Icons.markunread_mailbox,
      'masks': Icons.masks,
      'maximize': Icons.maximize,
      'media_bluetooth_off': Icons.media_bluetooth_off,
      'media_bluetooth_on': Icons.media_bluetooth_on,
      'mediation': Icons.mediation,
      'medical_information': Icons.medical_information,
      'medical_services': Icons.medical_services,
      'medication': Icons.medication,
      'medication_liquid': Icons.medication_liquid,
      'meeting_room': Icons.meeting_room,
      'memory': Icons.memory,
      'menu': Icons.menu,
      'menu_book': Icons.menu_book,
      'menu_open': Icons.menu_open,
      'merge': Icons.merge,
      'merge_type': Icons.merge_type,
      'message': Icons.message,
      'messenger': Icons.messenger,
      'messenger_outline': Icons.messenger_outline,
      'mic': Icons.mic,
      'mic_external_off': Icons.mic_external_off,
      'mic_external_on': Icons.mic_external_on,
      'mic_none': Icons.mic_none,
      'mic_off': Icons.mic_off,
      'microwave': Icons.microwave,
      'military_tech': Icons.military_tech,
      'minimize': Icons.minimize,
      'minor_crash': Icons.minor_crash,
      'miscellaneous_services': Icons.miscellaneous_services,
      'missed_video_call': Icons.missed_video_call,
      'mms': Icons.mms,
      'mobile_friendly': Icons.mobile_friendly,
      'mobile_off': Icons.mobile_off,
      'mobile_screen_share': Icons.mobile_screen_share,
      'mobiledata_off': Icons.mobiledata_off,
      'mode': Icons.mode,
      'mode_comment': Icons.mode_comment,
      'mode_edit': Icons.mode_edit,
      'mode_edit_outline': Icons.mode_edit_outline,
      'mode_fan_off': Icons.mode_fan_off,
      'mode_night': Icons.mode_night,
      'mode_of_travel': Icons.mode_of_travel,
      'mode_standby': Icons.mode_standby,
      'model_training': Icons.model_training,
      'monetization_on': Icons.monetization_on,
      'money': Icons.money,
      'money_off': Icons.money_off,
      'money_off_csred': Icons.money_off_csred,
      'monitor': Icons.monitor,
      'monitor_heart': Icons.monitor_heart,
      'monitor_weight': Icons.monitor_weight,
      'monochrome_photos': Icons.monochrome_photos,
      'mood': Icons.mood,
      'mood_bad': Icons.mood_bad,
      'moped': Icons.moped,
      'more': Icons.more,
      'more_horiz': Icons.more_horiz,
      'more_time': Icons.more_time,
      'more_vert': Icons.more_vert,
      'mosque': Icons.mosque,
      'motion_photos_auto': Icons.motion_photos_auto,
      'motion_photos_off': Icons.motion_photos_off,
      'motion_photos_on': Icons.motion_photos_on,
      'motion_photos_pause': Icons.motion_photos_pause,
      'motion_photos_paused': Icons.motion_photos_paused,
      'motorcycle': Icons.motorcycle,
      'mouse': Icons.mouse,
      'move_down': Icons.move_down,
      'move_to_inbox': Icons.move_to_inbox,
      'move_up': Icons.move_up,
      'movie': Icons.movie,
      'movie_creation': Icons.movie_creation,
      'movie_filter': Icons.movie_filter,
      'moving': Icons.moving,
      'mp': Icons.mp,
      'multiline_chart': Icons.multiline_chart,
      'multiple_stop': Icons.multiple_stop,
      'museum': Icons.museum,
      'music_note': Icons.music_note,
      'music_off': Icons.music_off,
      'music_video': Icons.music_video,
      'my_library_add': Icons.my_library_add,
      'my_library_books': Icons.my_library_books,
      'my_library_music': Icons.my_library_music,
      'my_location': Icons.my_location,

      // N
      'nat': Icons.nat,
      'nature': Icons.nature,
      'nature_people': Icons.nature_people,
      'navigate_before': Icons.navigate_before,
      'navigate_next': Icons.navigate_next,
      'navigation': Icons.navigation,
      'near_me': Icons.near_me,
      'near_me_disabled': Icons.near_me_disabled,
      'nearby_error': Icons.nearby_error,
      'nearby_off': Icons.nearby_off,
      'nest_cam_wired_stand': Icons.nest_cam_wired_stand,
      'network_cell': Icons.network_cell,
      'network_check': Icons.network_check,
      'network_locked': Icons.network_locked,
      'network_ping': Icons.network_ping,
      'network_wifi': Icons.network_wifi,
      'network_wifi_1_bar': Icons.network_wifi_1_bar,
      'network_wifi_2_bar': Icons.network_wifi_2_bar,
      'network_wifi_3_bar': Icons.network_wifi_3_bar,
      'new_label': Icons.new_label,
      'new_releases': Icons.new_releases,
      'newspaper': Icons.newspaper,
      'next_plan': Icons.next_plan,
      'next_week': Icons.next_week,
      'nfc': Icons.nfc,
      'night_shelter': Icons.night_shelter,
      'nightlife': Icons.nightlife,
      'nightlight': Icons.nightlight,
      'nightlight_round': Icons.nightlight_round,
      'nights_stay': Icons.nights_stay,
      'no_accounts': Icons.no_accounts,
      'no_adult_content': Icons.no_adult_content,
      'no_backpack': Icons.no_backpack,
      'no_cell': Icons.no_cell,
      'no_crash': Icons.no_crash,
      'no_drinks': Icons.no_drinks,
      'no_encryption': Icons.no_encryption,
      'no_encryption_gmailerrorred': Icons.no_encryption_gmailerrorred,
      'no_flash': Icons.no_flash,
      'no_food': Icons.no_food,
      'no_luggage': Icons.no_luggage,
      'no_meals': Icons.no_meals,
      'no_meeting_room': Icons.no_meeting_room,
      'no_photography': Icons.no_photography,
      'no_sim': Icons.no_sim,
      'no_stroller': Icons.no_stroller,
      'no_transfer': Icons.no_transfer,
      'noise_aware': Icons.noise_aware,
      'noise_control_off': Icons.noise_control_off,
      'nordic_walking': Icons.nordic_walking,
      'north': Icons.north,
      'north_east': Icons.north_east,
      'north_west': Icons.north_west,
      'not_accessible': Icons.not_accessible,
      'not_interested': Icons.not_interested,
      'not_listed_location': Icons.not_listed_location,
      'not_started': Icons.not_started,
      'note': Icons.note,
      'note_add': Icons.note_add,
      'note_alt': Icons.note_alt,
      'notes': Icons.notes,
      'notification_add': Icons.notification_add,
      'notification_important': Icons.notification_important,
      'notifications': Icons.notifications,
      'notifications_active': Icons.notifications_active,
      'notifications_none': Icons.notifications_none,
      'notifications_off': Icons.notifications_off,
      'notifications_on': Icons.notifications_on,
      'notifications_outlined': Icons.notifications_outlined,
      'notifications_paused': Icons.notifications_paused,
      'now_wallpaper': Icons.now_wallpaper,
      'now_widgets': Icons.now_widgets,
      'numbers': Icons.numbers,

      // O
      'offline_bolt': Icons.offline_bolt,
      'offline_pin': Icons.offline_pin,
      'offline_share': Icons.offline_share,
      'oil_barrel': Icons.oil_barrel,
      'on_device_training': Icons.on_device_training,
      'ondemand_video': Icons.ondemand_video,
      'one_k': Icons.one_k,
      'one_k_plus': Icons.one_k_plus,
      'one_x_mobiledata': Icons.one_x_mobiledata,
      'online_prediction': Icons.online_prediction,
      'opacity': Icons.opacity,
      'open_in_browser': Icons.open_in_browser,
      'open_in_full': Icons.open_in_full,
      'open_in_new': Icons.open_in_new,
      'open_in_new_off': Icons.open_in_new_off,
      'open_with': Icons.open_with,
      'other_houses': Icons.other_houses,
      'outbound': Icons.outbound,
      'outbox': Icons.outbox,
      'outdoor_grill': Icons.outdoor_grill,
      'outgoing_mail': Icons.outgoing_mail,
      'outlet': Icons.outlet,
      'outlined_flag': Icons.outlined_flag,
      'output': Icons.output,
      'padding': Icons.padding,

      // P
      'pages': Icons.pages,
      'pageview': Icons.pageview,
      'paid': Icons.paid,
      'palette': Icons.palette,
      'pan_tool': Icons.pan_tool,
      'pan_tool_alt': Icons.pan_tool_alt,
      'panorama': Icons.panorama,
      'panorama_fish_eye': Icons.panorama_fish_eye,
      'panorama_horizontal': Icons.panorama_horizontal,
      'panorama_horizontal_select': Icons.panorama_horizontal_select,
      'panorama_photosphere': Icons.panorama_photosphere,
      'panorama_photosphere_select': Icons.panorama_photosphere_select,
      'panorama_vertical': Icons.panorama_vertical,
      'panorama_vertical_select': Icons.panorama_vertical_select,
      'panorama_wide_angle': Icons.panorama_wide_angle,
      'panorama_wide_angle_select': Icons.panorama_wide_angle_select,
      'paragliding': Icons.paragliding,
      'park': Icons.park,
      'party_mode': Icons.party_mode,
      'password': Icons.password,
      'paste': Icons.paste,
      'pattern': Icons.pattern,
      'pause': Icons.pause,
      'pause_circle': Icons.pause_circle,
      'pause_circle_filled': Icons.pause_circle_filled,
      'pause_circle_outline': Icons.pause_circle_outline,
      'pause_presentation': Icons.pause_presentation,
      'payment': Icons.payment,
      'payments': Icons.payments,
      'paypal': Icons.paypal,
      'pedal_bike': Icons.pedal_bike,
      'pending': Icons.pending,
      'pending_actions': Icons.pending_actions,
      'pentagon': Icons.pentagon,
      'people': Icons.people,
      'people_alt': Icons.people_alt,
      'people_outline': Icons.people_outline,
      'percent': Icons.percent,
      'perm_camera_mic': Icons.perm_camera_mic,
      'perm_contact_calendar': Icons.perm_contact_calendar,
      'perm_data_setting': Icons.perm_data_setting,
      'perm_device_information': Icons.perm_device_information,
      'perm_identity': Icons.perm_identity,
      'perm_media': Icons.perm_media,
      'perm_phone_msg': Icons.perm_phone_msg,
      'perm_scan_wifi': Icons.perm_scan_wifi,
      'person': Icons.person,
      'person_2': Icons.person_2,
      'person_3': Icons.person_3,
      'person_4': Icons.person_4,
      'person_add': Icons.person_add,
      'person_add_alt': Icons.person_add_alt,
      'person_add_alt_1': Icons.person_add_alt_1,
      'person_add_disabled': Icons.person_add_disabled,
      'person_off': Icons.person_off,
      'person_outline': Icons.person_outline,
      'person_pin': Icons.person_pin,
      'person_pin_circle': Icons.person_pin_circle,
      'person_remove': Icons.person_remove,
      'person_remove_alt_1': Icons.person_remove_alt_1,
      'person_search': Icons.person_search,
      'personal_injury': Icons.personal_injury,
      'personal_video': Icons.personal_video,
      'pest_control': Icons.pest_control,
      'pest_control_rodent': Icons.pest_control_rodent,
      'pets': Icons.pets,
      'phishing': Icons.phishing,
      'phone': Icons.phone,
      'phone_android': Icons.phone_android,
      'phone_bluetooth_speaker': Icons.phone_bluetooth_speaker,
      'phone_callback': Icons.phone_callback,
      'phone_disabled': Icons.phone_disabled,
      'phone_enabled': Icons.phone_enabled,
      'phone_forwarded': Icons.phone_forwarded,
      'phone_in_talk': Icons.phone_in_talk,
      'phone_iphone': Icons.phone_iphone,
      'phone_locked': Icons.phone_locked,
      'phone_missed': Icons.phone_missed,
      'phone_paused': Icons.phone_paused,
      'phonelink': Icons.phonelink,
      'phonelink_erase': Icons.phonelink_erase,
      'phonelink_lock': Icons.phonelink_lock,
      'phonelink_off': Icons.phonelink_off,
      'phonelink_ring': Icons.phonelink_ring,
      'phonelink_setup': Icons.phonelink_setup,
      'photo': Icons.photo,
      'photo_album': Icons.photo_album,
      'photo_camera': Icons.photo_camera,
      'photo_camera_back': Icons.photo_camera_back,
      'photo_camera_front': Icons.photo_camera_front,
      'photo_filter': Icons.photo_filter,
      'photo_library': Icons.photo_library,
      'photo_size_select_actual': Icons.photo_size_select_actual,
      'photo_size_select_large': Icons.photo_size_select_large,
      'photo_size_select_small': Icons.photo_size_select_small,
      'php': Icons.php,
      'piano': Icons.piano,
      'piano_off': Icons.piano_off,
      'picture_as_pdf': Icons.picture_as_pdf,
      'picture_in_picture': Icons.picture_in_picture,
      'picture_in_picture_alt': Icons.picture_in_picture_alt,
      'pie_chart': Icons.pie_chart,
      'pie_chart_outline': Icons.pie_chart_outline,
      'pin': Icons.pin,
      'pin_drop': Icons.pin_drop,
      'pin_end': Icons.pin_end,
      'pin_invoke': Icons.pin_invoke,
      'pinch': Icons.pinch,
      'pivot_table_chart': Icons.pivot_table_chart,
      'pix': Icons.pix,
      'place': Icons.place,
      'plagiarism': Icons.plagiarism,
      'play_arrow': Icons.play_arrow,
      'play_circle': Icons.play_circle,
      'play_circle_fill': Icons.play_circle_fill,
      'play_circle_filled': Icons.play_circle_filled,
      'play_circle_outline': Icons.play_circle_outline,
      'play_disabled': Icons.play_disabled,
      'play_for_work': Icons.play_for_work,
      'play_lesson': Icons.play_lesson,
      'playlist_add': Icons.playlist_add,
      'playlist_add_check': Icons.playlist_add_check,
      'playlist_add_check_circle': Icons.playlist_add_check_circle,
      'playlist_add_circle': Icons.playlist_add_circle,
      'playlist_play': Icons.playlist_play,
      'playlist_remove': Icons.playlist_remove,
      'plumbing': Icons.plumbing,
      'plus_one': Icons.plus_one,
      'podcasts': Icons.podcasts,
      'point_of_sale': Icons.point_of_sale,
      'policy': Icons.policy,
      'poll': Icons.poll,
      'polyline': Icons.polyline,
      'polymer': Icons.polymer,
      'pool': Icons.pool,
      'portable_wifi_off': Icons.portable_wifi_off,
      'portrait': Icons.portrait,
      'post_add': Icons.post_add,
      'power': Icons.power,
      'power_input': Icons.power_input,
      'power_off': Icons.power_off,
      'power_settings_new': Icons.power_settings_new,
      'precision_manufacturing': Icons.precision_manufacturing,
      'pregnant_woman': Icons.pregnant_woman,
      'present_to_all': Icons.present_to_all,
      'preview': Icons.preview,
      'price_change': Icons.price_change,
      'price_check': Icons.price_check,
      'print': Icons.print,
      'print_disabled': Icons.print_disabled,
      'priority_high': Icons.priority_high,
      'privacy_tip': Icons.privacy_tip,
      'privacy_tip_outlined': Icons.privacy_tip_outlined,
      'private_connectivity': Icons.private_connectivity,
      'production_quantity_limits': Icons.production_quantity_limits,
      'propane': Icons.propane,
      'propane_tank': Icons.propane_tank,
      'psychology': Icons.psychology,
      'psychology_alt': Icons.psychology_alt,
      'public': Icons.public,
      'public_off': Icons.public_off,
      'publish': Icons.publish,
      'published_with_changes': Icons.published_with_changes,
      'punch_clock': Icons.punch_clock,
      'push_pin': Icons.push_pin,
      'qr_code': Icons.qr_code,

      // Q
      'qr_code_2': Icons.qr_code_2,
      'qr_code_scanner': Icons.qr_code_scanner,
      'query_builder': Icons.query_builder,
      'query_stats': Icons.query_stats,
      'question_answer': Icons.question_answer,
      'question_mark': Icons.question_mark,
      'queue': Icons.queue,
      'queue_music': Icons.queue_music,
      'queue_play_next': Icons.queue_play_next,
      'quickreply': Icons.quickreply,
      'quiz': Icons.quiz,

      // R
      'r_mobiledata': Icons.r_mobiledata,
      'radar': Icons.radar,
      'radio': Icons.radio,
      'radio_button_checked': Icons.radio_button_checked,
      'radio_button_off': Icons.radio_button_off,
      'radio_button_on': Icons.radio_button_on,
      'radio_button_unchecked': Icons.radio_button_unchecked,
      'railway_alert': Icons.railway_alert,
      'ramen_dining': Icons.ramen_dining,
      'ramp_left': Icons.ramp_left,
      'ramp_right': Icons.ramp_right,
      'rate_review': Icons.rate_review,
      'raw_off': Icons.raw_off,
      'raw_on': Icons.raw_on,
      'read_more': Icons.read_more,
      'real_estate_agent': Icons.real_estate_agent,
      'receipt': Icons.receipt,
      'receipt_long': Icons.receipt_long,
      'recent_actors': Icons.recent_actors,
      'recommend': Icons.recommend,
      'record_voice_over': Icons.record_voice_over,
      'rectangle': Icons.rectangle,
      'recycling': Icons.recycling,
      'redeem': Icons.redeem,
      'redo': Icons.redo,
      'reduce_capacity': Icons.reduce_capacity,
      'refresh': Icons.refresh,
      'remember_me': Icons.remember_me,
      'remove': Icons.remove,
      'remove_circle': Icons.remove_circle,
      'remove_circle_outline': Icons.remove_circle_outline,
      'remove_done': Icons.remove_done,
      'remove_from_queue': Icons.remove_from_queue,
      'remove_moderator': Icons.remove_moderator,
      'remove_red_eye': Icons.remove_red_eye,
      'remove_red_eye_outlined': Icons.remove_red_eye_outlined,
      'remove_shopping_cart': Icons.remove_shopping_cart,
      'reorder': Icons.reorder,
      'repartition': Icons.repartition,
      'repeat': Icons.repeat,
      'repeat_on': Icons.repeat_on,
      'repeat_one': Icons.repeat_one,
      'repeat_one_on': Icons.repeat_one_on,
      'replay': Icons.replay,
      'replay_10': Icons.replay_10,
      'replay_30': Icons.replay_30,
      'replay_5': Icons.replay_5,
      'replay_circle_filled': Icons.replay_circle_filled,
      'reply': Icons.reply,
      'reply_all': Icons.reply_all,
      'report': Icons.report,
      'report_gmailerrorred': Icons.report_gmailerrorred,
      'report_off': Icons.report_off,
      'report_problem': Icons.report_problem,
      'request_page': Icons.request_page,
      'request_quote': Icons.request_quote,
      'reset_tv': Icons.reset_tv,
      'restart_alt': Icons.restart_alt,
      'restaurant': Icons.restaurant,
      'restaurant_menu': Icons.restaurant_menu,
      'restore': Icons.restore,
      'restore_from_trash': Icons.restore_from_trash,
      'restore_page': Icons.restore_page,
      'reviews': Icons.reviews,
      'rice_bowl': Icons.rice_bowl,
      'ring_volume': Icons.ring_volume,
      'rocket': Icons.rocket,
      'rocket_launch': Icons.rocket_launch,
      'roller_shades': Icons.roller_shades,
      'roller_shades_closed': Icons.roller_shades_closed,
      'roller_skating': Icons.roller_skating,
      'roofing': Icons.roofing,
      'room': Icons.room,
      'room_preferences': Icons.room_preferences,
      'room_service': Icons.room_service,
      'rotate_90_degrees_ccw': Icons.rotate_90_degrees_ccw,
      'rotate_90_degrees_cw': Icons.rotate_90_degrees_cw,
      'rotate_left': Icons.rotate_left,
      'rotate_right': Icons.rotate_right,
      'roundabout_left': Icons.roundabout_left,
      'roundabout_right': Icons.roundabout_right,
      'rounded_corner': Icons.rounded_corner,
      'route': Icons.route,
      'router': Icons.router,
      'rowing': Icons.rowing,
      'rss_feed': Icons.rss_feed,
      'rsvp': Icons.rsvp,
      'rtt': Icons.rtt,
      'rule': Icons.rule,
      'rule_folder': Icons.rule_folder,
      'run_circle': Icons.run_circle,
      'running_with_errors': Icons.running_with_errors,
      'rv_hookup': Icons.rv_hookup,

      // S
      'safety_check': Icons.safety_check,
      'safety_divider': Icons.safety_divider,
      'sailing': Icons.sailing,
      'sanitizer': Icons.sanitizer,
      'satellite': Icons.satellite,
      'satellite_alt': Icons.satellite_alt,
      'save': Icons.save,
      'save_alt': Icons.save_alt,
      'save_as': Icons.save_as,
      'saved_search': Icons.saved_search,
      'savings': Icons.savings,
      'scale': Icons.scale,
      'scanner': Icons.scanner,
      'scatter_plot': Icons.scatter_plot,
      'schedule': Icons.schedule,
      'schedule_send': Icons.schedule_send,
      'schema': Icons.schema,
      'school': Icons.school,
      'science': Icons.science,
      'score': Icons.score,
      'scoreboard': Icons.scoreboard,
      'screen_lock_landscape': Icons.screen_lock_landscape,
      'screen_lock_portrait': Icons.screen_lock_portrait,
      'screen_lock_rotation': Icons.screen_lock_rotation,
      'screen_rotation': Icons.screen_rotation,
      'screen_rotation_alt': Icons.screen_rotation_alt,
      'screen_search_desktop': Icons.screen_search_desktop,
      'screen_share': Icons.screen_share,
      'screenshot': Icons.screenshot,
      'screenshot_monitor': Icons.screenshot_monitor,
      'scuba_diving': Icons.scuba_diving,
      'sd': Icons.sd,
      'sd_card': Icons.sd_card,
      'sd_card_alert': Icons.sd_card_alert,
      'sd_storage': Icons.sd_storage,
      'search': Icons.search,
      'search_off': Icons.search_off,
      'security': Icons.security,
      'security_update': Icons.security_update,
      'security_update_good': Icons.security_update_good,
      'security_update_warning': Icons.security_update_warning,
      'segment': Icons.segment,
      'select_all': Icons.select_all,
      'self_improvement': Icons.self_improvement,
      'sell': Icons.sell,
      'send': Icons.send,
      'send_and_archive': Icons.send_and_archive,
      'send_time_extension': Icons.send_time_extension,
      'send_to_mobile': Icons.send_to_mobile,
      'sensor_door': Icons.sensor_door,
      'sensor_occupied': Icons.sensor_occupied,
      'sensor_window': Icons.sensor_window,
      'sensors': Icons.sensors,
      'sensors_off': Icons.sensors_off,
      'sentiment_dissatisfied': Icons.sentiment_dissatisfied,
      'sentiment_neutral': Icons.sentiment_neutral,
      'sentiment_satisfied': Icons.sentiment_satisfied,
      'sentiment_satisfied_alt': Icons.sentiment_satisfied_alt,
      'sentiment_very_dissatisfied': Icons.sentiment_very_dissatisfied,
      'sentiment_very_satisfied': Icons.sentiment_very_satisfied,
      'set_meal': Icons.set_meal,
      'settings': Icons.settings,
      'settings_accessibility': Icons.settings_accessibility,
      'settings_applications': Icons.settings_applications,
      'settings_backup_restore': Icons.settings_backup_restore,
      'settings_bluetooth': Icons.settings_bluetooth,
      'settings_brightness': Icons.settings_brightness,
      'settings_cell': Icons.settings_cell,
      'settings_display': Icons.settings_display,
      'settings_ethernet': Icons.settings_ethernet,
      'settings_input_antenna': Icons.settings_input_antenna,
      'settings_input_component': Icons.settings_input_component,
      'settings_input_composite': Icons.settings_input_composite,
      'settings_input_hdmi': Icons.settings_input_hdmi,
      'settings_input_svideo': Icons.settings_input_svideo,
      'settings_overscan': Icons.settings_overscan,
      'settings_phone': Icons.settings_phone,
      'settings_power': Icons.settings_power,
      'settings_remote': Icons.settings_remote,
      'settings_suggest': Icons.settings_suggest,
      'settings_system_daydream': Icons.settings_system_daydream,
      'settings_voice': Icons.settings_voice,
      'severe_cold': Icons.severe_cold,
      'shape_line': Icons.shape_line,
      'share': Icons.share,
      'share_location': Icons.share_location,
      'shield': Icons.shield,
      'shield_moon': Icons.shield_moon,
      'shop': Icons.shop,
      'shop_2': Icons.shop_2,
      'shop_two': Icons.shop_two,
      'shopping_bag': Icons.shopping_bag,
      'shopping_basket': Icons.shopping_basket,
      'shopping_cart': Icons.shopping_cart,
      'shopping_cart_checkout': Icons.shopping_cart_checkout,
      'short_text': Icons.short_text,
      'shortcut': Icons.shortcut,
      'show_chart': Icons.show_chart,
      'shower': Icons.shower,
      'shuffle': Icons.shuffle,
      'shuffle_on': Icons.shuffle_on,
      'shutter_speed': Icons.shutter_speed,
      'sick': Icons.sick,
      'sign_language': Icons.sign_language,
      'signal_cellular_0_bar': Icons.signal_cellular_0_bar,
      'signal_cellular_4_bar': Icons.signal_cellular_4_bar,
      'signal_cellular_alt': Icons.signal_cellular_alt,
      'signal_cellular_alt_1_bar': Icons.signal_cellular_alt_1_bar,
      'signal_cellular_alt_2_bar': Icons.signal_cellular_alt_2_bar,
      'signal_cellular_connected_no_internet_0_bar':
          Icons.signal_cellular_connected_no_internet_0_bar,
      'signal_cellular_connected_no_internet_4_bar':
          Icons.signal_cellular_connected_no_internet_4_bar,
      'signal_cellular_no_sim': Icons.signal_cellular_no_sim,
      'signal_cellular_nodata': Icons.signal_cellular_nodata,
      'signal_cellular_null': Icons.signal_cellular_null,
      'signal_cellular_off': Icons.signal_cellular_off,
      'signal_wifi_0_bar': Icons.signal_wifi_0_bar,
      'signal_wifi_4_bar': Icons.signal_wifi_4_bar,
      'signal_wifi_4_bar_lock': Icons.signal_wifi_4_bar_lock,
      'signal_wifi_bad': Icons.signal_wifi_bad,
      'signal_wifi_connected_no_internet_4':
          Icons.signal_wifi_connected_no_internet_4,
      'signal_wifi_off': Icons.signal_wifi_off,
      'signal_wifi_statusbar_4_bar': Icons.signal_wifi_statusbar_4_bar,
      'signal_wifi_statusbar_connected_no_internet_4':
          Icons.signal_wifi_statusbar_connected_no_internet_4,
      'signal_wifi_statusbar_null': Icons.signal_wifi_statusbar_null,
      'signpost': Icons.signpost,
      'sim_card': Icons.sim_card,
      'sim_card_alert': Icons.sim_card_alert,
      'sim_card_download': Icons.sim_card_download,
      'single_bed': Icons.single_bed,
      'sip': Icons.sip,
      'skateboarding': Icons.skateboarding,
      'skip_next': Icons.skip_next,
      'skip_previous': Icons.skip_previous,
      'sledding': Icons.sledding,
      'slideshow': Icons.slideshow,
      'slow_motion_video': Icons.slow_motion_video,
      'smart_button': Icons.smart_button,
      'smart_display': Icons.smart_display,
      'smart_screen': Icons.smart_screen,
      'smart_toy': Icons.smart_toy,
      'smartphone': Icons.smartphone,
      'smoke_free': Icons.smoke_free,
      'smoking_rooms': Icons.smoking_rooms,
      'sms': Icons.sms,
      'sms_failed': Icons.sms_failed,
      'snippet_folder': Icons.snippet_folder,
      'snooze': Icons.snooze,
      'snowboarding': Icons.snowboarding,
      'snowmobile': Icons.snowmobile,
      'snowshoeing': Icons.snowshoeing,
      'soap': Icons.soap,
      'social_distance': Icons.social_distance,
      'solar_power': Icons.solar_power,
      'sort': Icons.sort,
      'sort_by_alpha': Icons.sort_by_alpha,
      'sos': Icons.sos,
      'soup_kitchen': Icons.soup_kitchen,
      'source': Icons.source,
      'south': Icons.south,
      'south_america': Icons.south_america,
      'south_east': Icons.south_east,
      'south_west': Icons.south_west,
      'spa': Icons.spa,
      'space_bar': Icons.space_bar,
      'space_dashboard': Icons.space_dashboard,
      'spatial_audio': Icons.spatial_audio,
      'spatial_audio_off': Icons.spatial_audio_off,
      'spatial_tracking': Icons.spatial_tracking,
      'speaker': Icons.speaker,
      'speaker_group': Icons.speaker_group,
      'speaker_notes': Icons.speaker_notes,
      'speaker_notes_off': Icons.speaker_notes_off,
      'speaker_phone': Icons.speaker_phone,
      'speed': Icons.speed,
      'spellcheck': Icons.spellcheck,
      'splitscreen': Icons.splitscreen,
      'spoke': Icons.spoke,
      'sports': Icons.sports,
      'sports_bar': Icons.sports_bar,
      'sports_baseball': Icons.sports_baseball,
      'sports_basketball': Icons.sports_basketball,
      'sports_cricket': Icons.sports_cricket,
      'sports_esports': Icons.sports_esports,
      'sports_football': Icons.sports_football,
      'sports_golf': Icons.sports_golf,
      'sports_gymnastics': Icons.sports_gymnastics,
      'sports_handball': Icons.sports_handball,
      'sports_hockey': Icons.sports_hockey,
      'sports_kabaddi': Icons.sports_kabaddi,
      'sports_martial_arts': Icons.sports_martial_arts,
      'sports_mma': Icons.sports_mma,
      'sports_motorsports': Icons.sports_motorsports,
      'sports_rugby': Icons.sports_rugby,
      'sports_score': Icons.sports_score,
      'sports_soccer': Icons.sports_soccer,
      'sports_tennis': Icons.sports_tennis,
      'sports_volleyball': Icons.sports_volleyball,
      'square': Icons.square,
      'square_foot': Icons.square_foot,
      'ssid_chart': Icons.ssid_chart,
      'stacked_bar_chart': Icons.stacked_bar_chart,
      'stacked_line_chart': Icons.stacked_line_chart,
      'stadium': Icons.stadium,
      'stairs': Icons.stairs,
      'star': Icons.star,
      'star_border': Icons.star_border,
      'star_border_purple500': Icons.star_border_purple500,
      'star_half': Icons.star_half,
      'star_outline': Icons.star_outline,
      'star_purple500': Icons.star_purple500,
      'star_rate': Icons.star_rate,
      'stars': Icons.stars,
      'start': Icons.start,
      'stay_current_landscape': Icons.stay_current_landscape,
      'stay_current_portrait': Icons.stay_current_portrait,
      'stay_primary_landscape': Icons.stay_primary_landscape,
      'stay_primary_portrait': Icons.stay_primary_portrait,
      'sticky_note_2': Icons.sticky_note_2,
      'stop': Icons.stop,
      'stop_circle': Icons.stop_circle,
      'stop_screen_share': Icons.stop_screen_share,
      'storage': Icons.storage,
      'store': Icons.store,
      'store_mall_directory': Icons.store_mall_directory,
      'storefront': Icons.storefront,
      'storm': Icons.storm,
      'straight': Icons.straight,
      'straighten': Icons.straighten,
      'stream': Icons.stream,
      'streetview': Icons.streetview,
      'strikethrough_s': Icons.strikethrough_s,
      'stroller': Icons.stroller,
      'style': Icons.style,
      'subdirectory_arrow_left': Icons.subdirectory_arrow_left,
      'subdirectory_arrow_right': Icons.subdirectory_arrow_right,
      'subject': Icons.subject,
      'subscript': Icons.subscript,
      'subscriptions': Icons.subscriptions,
      'subtitles': Icons.subtitles,
      'subtitles_off': Icons.subtitles_off,
      'subway': Icons.subway,
      'summarize': Icons.summarize,
      'superscript': Icons.superscript,
      'supervised_user_circle': Icons.supervised_user_circle,
      'supervisor_account': Icons.supervisor_account,
      'support': Icons.support,
      'support_agent': Icons.support_agent,
      'surfing': Icons.surfing,
      'surround_sound': Icons.surround_sound,
      'swap_calls': Icons.swap_calls,
      'swap_horiz': Icons.swap_horiz,
      'swap_horizontal_circle': Icons.swap_horizontal_circle,
      'swap_vert': Icons.swap_vert,
      'swap_vertical_circle': Icons.swap_vertical_circle,
      'swipe': Icons.swipe,
      'swipe_down': Icons.swipe_down,
      'swipe_down_alt': Icons.swipe_down_alt,
      'swipe_left': Icons.swipe_left,
      'swipe_left_alt': Icons.swipe_left_alt,
      'swipe_right': Icons.swipe_right,
      'swipe_right_alt': Icons.swipe_right_alt,
      'swipe_up': Icons.swipe_up,
      'swipe_up_alt': Icons.swipe_up_alt,
      'swipe_vertical': Icons.swipe_vertical,
      'switch_access_shortcut': Icons.switch_access_shortcut,
      'switch_access_shortcut_add': Icons.switch_access_shortcut_add,
      'switch_account': Icons.switch_account,
      'switch_camera': Icons.switch_camera,
      'switch_left': Icons.switch_left,
      'switch_right': Icons.switch_right,
      'switch_video': Icons.switch_video,
      'synagogue': Icons.synagogue,
      'sync': Icons.sync,
      'sync_alt': Icons.sync_alt,
      'sync_disabled': Icons.sync_disabled,
      'sync_problem': Icons.sync_problem,
      'system_security_update': Icons.system_security_update,
      'system_security_update_good': Icons.system_security_update_good,
      'system_security_update_warning': Icons.system_security_update_warning,
      'system_update': Icons.system_update,
      'system_update_alt': Icons.system_update_alt,

      // T
      'tab': Icons.tab,
      'tab_unselected': Icons.tab_unselected,
      'table_bar': Icons.table_bar,
      'table_chart': Icons.table_chart,
      'table_restaurant': Icons.table_restaurant,
      'table_rows': Icons.table_rows,
      'table_view': Icons.table_view,
      'tablet': Icons.tablet,
      'tablet_android': Icons.tablet_android,
      'tablet_mac': Icons.tablet_mac,
      'tag': Icons.tag,
      'tag_faces': Icons.tag_faces,
      'takeout_dining': Icons.takeout_dining,
      'tap_and_play': Icons.tap_and_play,
      'tapas': Icons.tapas,
      'task': Icons.task,
      'task_alt': Icons.task_alt,
      'taxi_alert': Icons.taxi_alert,
      'telegram': Icons.telegram,
      'temple_buddhist': Icons.temple_buddhist,
      'temple_hindu': Icons.temple_hindu,
      'terminal': Icons.terminal,
      'terrain': Icons.terrain,
      'text_decrease': Icons.text_decrease,
      'text_fields': Icons.text_fields,
      'text_format': Icons.text_format,
      'text_increase': Icons.text_increase,
      'text_rotate_up': Icons.text_rotate_up,
      'text_rotate_vertical': Icons.text_rotate_vertical,
      'text_rotation_angledown': Icons.text_rotation_angledown,
      'text_rotation_angleup': Icons.text_rotation_angleup,
      'text_rotation_down': Icons.text_rotation_down,
      'text_rotation_none': Icons.text_rotation_none,
      'text_snippet': Icons.text_snippet,
      'textsms': Icons.textsms,
      'texture': Icons.texture,
      'theater_comedy': Icons.theater_comedy,
      'theaters': Icons.theaters,
      'thermostat': Icons.thermostat,
      'thermostat_auto': Icons.thermostat_auto,
      'thumb_down': Icons.thumb_down,
      'thumb_down_alt': Icons.thumb_down_alt,
      'thumb_down_off_alt': Icons.thumb_down_off_alt,
      'thumb_up': Icons.thumb_up,
      'thumb_up_alt': Icons.thumb_up_alt,
      'thumb_up_off_alt': Icons.thumb_up_off_alt,
      'thumbs_up_down': Icons.thumbs_up_down,
      'thunderstorm': Icons.thunderstorm,
      'time_to_leave': Icons.time_to_leave,
      'timelapse': Icons.timelapse,
      'timeline': Icons.timeline,
      'timer': Icons.timer,
      'timer_10': Icons.timer_10,
      'timer_10_select': Icons.timer_10_select,
      'timer_3': Icons.timer_3,
      'timer_3_select': Icons.timer_3_select,
      'timer_off': Icons.timer_off,
      'tips_and_updates': Icons.tips_and_updates,
      'tire_repair': Icons.tire_repair,
      'title': Icons.title,
      'toc': Icons.toc,
      'today': Icons.today,
      'toggle_off': Icons.toggle_off,
      'toggle_on': Icons.toggle_on,
      'token': Icons.token,
      'toll': Icons.toll,
      'tonality': Icons.tonality,
      'topic': Icons.topic,
      'tornado': Icons.tornado,
      'touch_app': Icons.touch_app,
      'tour': Icons.tour,
      'toys': Icons.toys,
      'track_changes': Icons.track_changes,
      'traffic': Icons.traffic,
      'train': Icons.train,
      'tram': Icons.tram,
      'transcribe': Icons.transcribe,
      'transfer_within_a_station': Icons.transfer_within_a_station,
      'transform': Icons.transform,
      'transgender': Icons.transgender,
      'transit_enterexit': Icons.transit_enterexit,
      'translate': Icons.translate,
      'travel_explore': Icons.travel_explore,
      'trending_down': Icons.trending_down,
      'trending_flat': Icons.trending_flat,
      'trending_up': Icons.trending_up,
      'trip_origin': Icons.trip_origin,
      'troubleshoot': Icons.troubleshoot,
      'try': Icons.try_sms_star,
      'tsunami': Icons.tsunami,
      'tty': Icons.tty,
      'tune': Icons.tune,
      'tungsten': Icons.tungsten,
      'turn_left': Icons.turn_left,
      'turn_right': Icons.turn_right,
      'turn_sharp_left': Icons.turn_sharp_left,
      'turn_sharp_right': Icons.turn_sharp_right,
      'turn_slight_left': Icons.turn_slight_left,
      'turn_slight_right': Icons.turn_slight_right,
      'turned_in': Icons.turned_in,
      'turned_in_not': Icons.turned_in_not,
      'tv': Icons.tv,
      'tv_off': Icons.tv_off,
      'two_wheeler': Icons.two_wheeler,
      'type_specimen': Icons.type_specimen,

      // U
      'u_turn_left': Icons.u_turn_left,
      'u_turn_right': Icons.u_turn_right,
      'umbrella': Icons.umbrella,
      'unarchive': Icons.unarchive,
      'undo': Icons.undo,
      'unfold_less': Icons.unfold_less,
      'unfold_more': Icons.unfold_more,
      'unpublished': Icons.unpublished,
      'unsubscribe': Icons.unsubscribe,
      'upcoming': Icons.upcoming,
      'update': Icons.update,
      'update_disabled': Icons.update_disabled,
      'upgrade': Icons.upgrade,
      'upload': Icons.upload,
      'upload_file': Icons.upload_file,
      'usb': Icons.usb,
      'usb_off': Icons.usb_off,

      // V
      'verified': Icons.verified,
      'verified_user': Icons.verified_user,
      'vertical_align_bottom': Icons.vertical_align_bottom,
      'vertical_align_center': Icons.vertical_align_center,
      'vertical_align_top': Icons.vertical_align_top,
      'vertical_distribute': Icons.vertical_distribute,
      'vertical_split': Icons.vertical_split,
      'vibration': Icons.vibration,
      'video_call': Icons.video_call,
      'video_camera_back': Icons.video_camera_back,
      'video_camera_front': Icons.video_camera_front,
      'video_chat': Icons.video_chat,
      'video_collection': Icons.video_collection,
      'video_file': Icons.video_file,
      'video_label': Icons.video_label,
      'video_library': Icons.video_library,
      'video_settings': Icons.video_settings,
      'video_stable': Icons.video_stable,
      'videocam': Icons.videocam,
      'videocam_off': Icons.videocam_off,
      'videogame_asset': Icons.videogame_asset,
      'videogame_asset_off': Icons.videogame_asset_off,
      'view_agenda': Icons.view_agenda,
      'view_array': Icons.view_array,
      'view_carousel': Icons.view_carousel,
      'view_column': Icons.view_column,
      'view_comfortable': Icons.view_comfortable,
      'view_comfy': Icons.view_comfy,
      'view_comfy_alt': Icons.view_comfy_alt,
      'view_compact': Icons.view_compact,
      'view_compact_alt': Icons.view_compact_alt,
      'view_cozy': Icons.view_cozy,
      'view_day': Icons.view_day,
      'view_headline': Icons.view_headline,
      'view_in_ar': Icons.view_in_ar,
      'view_kanban': Icons.view_kanban,
      'view_list': Icons.view_list,
      'view_module': Icons.view_module,
      'view_quilt': Icons.view_quilt,
      'view_sidebar': Icons.view_sidebar,
      'view_stream': Icons.view_stream,
      'view_timeline': Icons.view_timeline,
      'view_week': Icons.view_week,
      'vignette': Icons.vignette,
      'villa': Icons.villa,
      'visibility': Icons.visibility,
      'visibility_off': Icons.visibility_off,
      'voice_chat': Icons.voice_chat,
      'voice_over_off': Icons.voice_over_off,
      'voicemail': Icons.voicemail,
      'volcano': Icons.volcano,
      'volume_down': Icons.volume_down,
      'volume_down_alt': Icons.volume_down_alt,
      'volume_mute': Icons.volume_mute,
      'volume_off': Icons.volume_off,
      'volume_up': Icons.volume_up,
      'volunteer_activism': Icons.volunteer_activism,
      'vpn_key': Icons.vpn_key,
      'vpn_key_off': Icons.vpn_key_off,
      'vpn_lock': Icons.vpn_lock,

      // W
      'wallet': Icons.wallet,
      'wallet_giftcard': Icons.wallet_giftcard,
      'wallet_membership': Icons.wallet_membership,
      'wallet_travel': Icons.wallet_travel,
      'wallpaper': Icons.wallpaper,
      'warehouse': Icons.warehouse,
      'warning': Icons.warning,
      'warning_amber': Icons.warning_amber,
      'wash': Icons.wash,
      'watch': Icons.watch,
      'watch_later': Icons.watch_later,
      'watch_off': Icons.watch_off,
      'water': Icons.water,
      'water_damage': Icons.water_damage,
      'water_drop': Icons.water_drop,
      'waterfall_chart': Icons.waterfall_chart,
      'waves': Icons.waves,
      'waving_hand': Icons.waving_hand,
      'wb_auto': Icons.wb_auto,
      'wb_cloudy': Icons.wb_cloudy,
      'wb_incandescent': Icons.wb_incandescent,
      'wb_iridescent': Icons.wb_iridescent,
      'wb_shade': Icons.wb_shade,
      'wb_sunny': Icons.wb_sunny,
      'wb_twilight': Icons.wb_twilight,
      'wc': Icons.wc,
      'web': Icons.web,
      'web_asset': Icons.web_asset,
      'web_asset_off': Icons.web_asset_off,
      'web_stories': Icons.web_stories,
      'webhook': Icons.webhook,
      'weekend': Icons.weekend,
      'west': Icons.west,
      'whatshot': Icons.whatshot,
      'wheelchair_pickup': Icons.wheelchair_pickup,
      'where_to_vote': Icons.where_to_vote,
      'widgets': Icons.widgets,
      'width_full': Icons.width_full,
      'width_normal': Icons.width_normal,
      'width_wide': Icons.width_wide,
      'wifi': Icons.wifi,
      'wifi_1_bar': Icons.wifi_1_bar,
      'wifi_2_bar': Icons.wifi_2_bar,
      'wifi_calling': Icons.wifi_calling,
      'wifi_calling_3': Icons.wifi_calling_3,
      'wifi_channel': Icons.wifi_channel,
      'wifi_find': Icons.wifi_find,
      'wifi_lock': Icons.wifi_lock,
      'wifi_off': Icons.wifi_off,
      'wifi_password': Icons.wifi_password,
      'wifi_protected_setup': Icons.wifi_protected_setup,
      'wifi_tethering': Icons.wifi_tethering,
      'wifi_tethering_error': Icons.wifi_tethering_error,
      'wifi_tethering_off': Icons.wifi_tethering_off,
      'window': Icons.window,
      'wine_bar': Icons.wine_bar,
      'woman': Icons.woman,
      'woman_2': Icons.woman_2,
      'work': Icons.work,
      'work_history': Icons.work_history,
      'work_off': Icons.work_off,
      'work_outline': Icons.work_outline,
      'workspace_premium': Icons.workspace_premium,
      'workspaces': Icons.workspaces,
      'workspaces_filled': Icons.workspaces_filled,
      'workspaces_outline': Icons.workspaces_outline,
      'wrap_text': Icons.wrap_text,
      'wrong_location': Icons.wrong_location,
      'wysiwyg': Icons.wysiwyg,

      // X-Z
      'yard': Icons.yard,
      'youtube_searched_for': Icons.youtube_searched_for,
      'zoom_in': Icons.zoom_in,
      'zoom_in_map': Icons.zoom_in_map,
      'zoom_out': Icons.zoom_out,
      'zoom_out_map': Icons.zoom_out_map,
    };

    // Check if the icon exists
    if (iconMap.containsKey(iconName)) {
      return Icon(
        iconMap[iconName],
        size: size,
        color: color,
        semanticLabel: iconName,
      );
    } else {
      // Return a fallback icon
      return Icon(
        Icons.help_outline,
        size: size,
        color: Colors.grey,
        semanticLabel: '$iconName',
      );
    }
  }
}



=== File 34: lib/widgets/custom_image_widget.dart ===

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_export.dart';


extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file: //')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}


enum ImageType { svg, png, network, file, unknown }


// ignore_for_file: must_be_immutable
class CustomImageWidget extends StatelessWidget {
  CustomImageWidget({
    this.imageUrl,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/no-image.jpg',
    this.errorWidget,
    this.semanticLabel,
  });


  ///[imageUrl] is required parameter for showing image
  final String? imageUrl;


  final double? height;


  final double? width;


  final BoxFit? fit;


  final String placeHolder;


  final Color? color;


  final Alignment? alignment;


  final VoidCallback? onTap;


  final BorderRadius? radius;


  final EdgeInsetsGeometry? margin;


  final BoxBorder? border;


  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;


  /// Semantic label for the image to improve accessibility
  final String? semanticLabel;


  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }


  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }


  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }


  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }


  Widget _buildImageView() {
    if (imageUrl != null) {
      switch (imageUrl!.imageType) {
        case ImageType.svg:
          return Container(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imageUrl!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: this.color != null
                  ? ColorFilter.mode(
                      this.color ?? Colors.transparent, BlendMode.srcIn)
                  : null,
              semanticsLabel: semanticLabel,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imageUrl!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imageUrl!,
            color: color,
            placeholder: (context, url) => Container(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) =>
                errorWidget ??
                Image.asset(
                  placeHolder,
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.cover,
                  semanticLabel: semanticLabel,
                ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imageUrl!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
      }
    }
    return SizedBox();
  }
}



