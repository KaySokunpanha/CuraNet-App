class ApiConstants {
  // Base URL - Vercel Production Backend
  static const String baseUrl = 'https://curanet-backend.vercel.app';

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String verifyPhoneOtp = '/api/auth/verify-phone-otp';
  static const String resendPhoneOtp = '/api/auth/resend-phone-otp';
  static const String logout = '/api/auth/logout';
  static const String refresh = '/api/auth/refresh';
  static const String profile = '/api/auth/me';
  static const String resetPassword = '/api/auth/request-password-reset';

  // Health endpoints
  static const String healthProfile = '/api/profile';
  static const String records = '/api/records';
  static const String appointments = '/api/appointments';
  static const String patientAppointments = '/api/appointments/patient';
  static const String encountersList = '/api/records/encounters/list';
  static const String observationsList = '/api/records/observations/list';
}
