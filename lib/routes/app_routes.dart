import 'package:flutter/material.dart';
import '../presentation/medical_records_screen/medical_records_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/health_dashboard/health_dashboard.dart';
import '../presentation/patient_record_view/patient_record_view.dart';
import '../presentation/appointments_screen/appointments_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/schedule_screen/schedule_screen.dart'; // Import ScheduleScreen
import '../presentation/main_screen/main_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String medicalRecords = '/medical-records-screen';
  static const String splash = '/splash-screen';
  static const String authentication = '/authentication-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String healthDashboard = '/health-dashboard';
  static const String patientRecordView = '/patient-record-view';
  static const String appointments = '/appointments';
  static const String profile = '/profile-screen';
  static const String schedule = '/schedule-screen';
  // care is deprecated/removed from active routes map to avoid confusion, linked to schedule in old files
  static const String care = '/care-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    medicalRecords: (context) => const MedicalRecordsScreen(),
    splash: (context) => const SplashScreen(),
    authentication: (context) => const AuthenticationScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    healthDashboard: (context) => const HealthDashboard(),
    patientRecordView: (context) => const PatientRecordView(),
    appointments: (context) => const AppointmentsScreen(),
    profile: (context) => const ProfileScreen(),
    schedule: (context) => const ScheduleScreen(),
    '/main-screen': (context) => const MainScreen(),
    // TODO: Add your other routes here
  };
}
