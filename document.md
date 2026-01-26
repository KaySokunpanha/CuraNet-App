# CuraNet - Technical Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Application Flow](#application-flow)
4. [Core Modules](#core-modules)
5. [Services Layer](#services-layer)
6. [Presentation Layer](#presentation-layer)
7. [Data Management](#data-management)
8. [Security](#security)
9. [Third-Party Integrations](#third-party-integrations)
10. [Deployment](#deployment)

---

## Overview

CuraNet is a comprehensive healthcare management mobile application built with Flutter. It provides patients with a unified platform to manage their medical records, appointments, health vitals, and emergency information securely.

### Key Objectives
- **Patient Empowerment**: Give patients complete control over their health data
- **Secure Storage**: Ensure medical records are stored and transmitted securely
- **Offline Accessibility**: Cache critical data for offline access
- **Emergency Readiness**: Provide quick access to emergency health information

---

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter Application                      │
├─────────────────────────────────────────────────────────────┤
│  Presentation Layer (Screens & Widgets)                       │
├─────────────────────────────────────────────────────────────┤
│  Services Layer (Business Logic & API Communication)          │
├─────────────────────────────────────────────────────────────┤
│  Data Layer (Local Storage & Caching)                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Backend API (Node.js + Express)                   │
│                    Deployed on Vercel                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Database (PostgreSQL)                       │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|----------------|
| **Presentation** | UI components, screen layouts, user interactions |
| **Services** | API calls, data transformation, business logic |
| **Data** | Local caching, persistent storage, data models |

---

## Application Flow

### Startup Sequence

```
main.dart
    │
    ├── Load .env (Environment Variables)
    ├── Set Portrait Orientation
    ├── Initialize GlobalDataSyncService
    │
    └── Run MyApp
           │
           └── SplashScreen
                  │
                  ├── (Token Exists) ──► HealthDashboard
                  │
                  └── (No Token) ──► AuthenticationScreen
```

### Navigation Routes

| Route | Screen | Description |
|-------|--------|-------------|
| `/` | SplashScreen | App launch & auth check |
| `/authentication-screen` | AuthenticationScreen | Login/Register |
| `/onboarding-flow` | OnboardingFlow | First-time setup |
| `/health-dashboard` | HealthDashboard | Main dashboard |
| `/medical-records-screen` | MedicalRecordsScreen | View/manage records |
| `/patient-record-view` | PatientRecordView | Detailed record view |
| `/appointments` | AppointmentsScreen | Appointment list |
| `/profile-screen` | ProfileScreen | User profile |
| `/schedule-screen` | ScheduleScreen | Schedule management |
| `/emergency-screen` | EmergencyScreen | Emergency card |
| `/nearby-care-screen` | NearbyCareScreen | Nearby facilities |

---

## Core Modules

### 1. Main Entry Point (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) => runApp(const MyApp()));
}
```

**Key Responsibilities:**
- Load environment variables from `.env`
- Ensure portrait orientation
- Initialize app with Material theme
- Trigger global data synchronization

### 2. Routing (`app_routes.dart`)

Centralized route management using named routes:

```dart
static Map<String, WidgetBuilder> routes = {
  initial: (context) => const SplashScreen(),
  authentication: (context) => const AuthenticationScreen(),
  healthDashboard: (context) => const HealthDashboard(),
  // ... more routes
};
```

### 3. Theme System (`theme/`)

- **app_theme.dart**: Defines light/dark theme configurations
- **custom_text_style.dart**: Typography definitions
- **app_decoration.dart**: Box decorations and UI styling
- **theme_helper.dart**: Theme utility functions

---

## Services Layer

### AuthService (`auth_service.dart`)

Handles all authentication operations:

| Method | Purpose |
|--------|---------|
| `register()` | New user registration |
| `login()` | User login with email/phone |
| `logout()` | Clear session and tokens |
| `getAccessToken()` | Get/refresh JWT token |
| `verifyEmail()` | Email verification |
| `verifyPhoneOtp()` | Phone OTP verification |
| `getProfile()` | Fetch user profile |

**Token Management:**
- Access token expires in 15 minutes
- Auto-refresh 2 minutes before expiry
- Refresh token stored in SharedPreferences
- Force logout on refresh failure

### HealthService (`health_service.dart`)

Manages health-related data with intelligent caching:

| Method | Purpose |
|--------|---------|
| `getProfile()` | Fetch health profile |
| `getAppointments()` | Get patient appointments |
| `getEncounters()` | Get medical encounters |
| `getObservations()` | Get vitals and observations |
| `getRecentActivity()` | Combined activity timeline |
| `updateProfile()` | Update health profile |

**Caching Strategy:**
- Cache duration: 30 minutes
- Background refresh after 5 minutes
- Fallback to cache on network failure

### CareService (`care_service.dart`)

Handles care-related data:

| Method | Purpose |
|--------|---------|
| `getHealthProfile()` | Blood group, allergies |
| `getVitals()` | Health measurements |
| `getEmergencyCard()` | Emergency information |
| `getMedications()` | Current medications |

### NearbyService (`nearby_service.dart`)

Location-based facility search:

```dart
Future<List<Map<String, dynamic>>> getNearbyFacilities(String type)
```

**Features:**
- Uses Google Places API (New)
- Fallback to mock data if API unavailable
- Supports: hospitals, pharmacies, labs
- Calculates distance from user location

### RecordUploadService (`record_upload_service.dart`)

Medical document management:

| Method | Purpose |
|--------|---------|
| `uploadFile()` | Upload with Base64 encoding |
| `getMyRecords()` | List user's records |
| `getMyFiles()` | Get uploaded files |
| `downloadFile()` | Download by file ID |
| `deleteRecord()` | Delete a record |

**Upload Process:**
1. Convert file to Base64
2. Attach metadata (type, date, hospital, doctor)
3. Send to `/api/uploads/file`
4. Handle 401 with automatic token refresh

---

## Presentation Layer

### Screen Components

| Screen | Features |
|--------|----------|
| **SplashScreen** | Logo animation, auth check, auto-navigation |
| **AuthenticationScreen** | Login/Register tabs, form validation, OTP support |
| **OnboardingFlow** | Profile setup, health information collection |
| **HealthDashboard** | Profile card, recent activity, quick actions |
| **MedicalRecordsScreen** | Records list, filter by type, add new records |
| **PatientRecordView** | Detailed view, download, share, delete |
| **AppointmentsScreen** | Appointment cards, status badges, doctor info |
| **ProfileScreen** | Profile editing, email/phone verification |
| **EmergencyScreen** | Emergency card, QR code, emergency contacts |
| **NearbyCareScreen** | Map view, facility list, filters |

### Custom Widgets

| Widget | Purpose |
|--------|---------|
| `CustomAppBar` | Customizable navigation bar |
| `CustomBottomBar` | Bottom navigation with 4 tabs |
| `CustomElevatedButton` | Styled primary buttons |
| `CustomTextFormField` | Form inputs with validation |
| `CustomErrorWidget` | Error state display |
| `CustomImageWidget` | Cached network images |
| `CustomIconWidget` | Themed icon buttons |

---

## Data Management

### Local Storage

Using `SharedPreferences` for:

| Key | Data |
|-----|------|
| `access_token` | JWT access token |
| `refresh_token` | JWT refresh token |
| `token_expiry` | Token expiration timestamp |
| `user_data` | Cached user profile |
| `cached_profile` | Health profile cache |
| `cached_encounters` | Encounters cache |
| `cached_appointments` | Appointments cache |
| `cached_observations` | Vitals cache |
| `cached_my_files` | Uploaded files cache |

### Caching Strategy

```dart
// Cache validation
bool _isCacheValid(int? timestamp) {
  if (timestamp == null) return false;
  final now = DateTime.now().millisecondsSinceEpoch;
  return (now - timestamp) < (30 * 60 * 1000); // 30 minutes
}

// Background refresh trigger
bool _shouldRefreshInBackground(int? timestamp) {
  if (timestamp == null) return true;
  final now = DateTime.now().millisecondsSinceEpoch;
  return (now - timestamp) > (5 * 60 * 1000); // After 5 minutes
}
```

---

## Security

### Authentication Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Login     │────►│   Server    │────►│   JWT       │
│   Request   │     │   Validate  │     │   Token     │
└─────────────┘     └─────────────┘     └─────────────┘
                                              │
                                              ▼
                                        ┌─────────────┐
                                        │   Access    │
                                        │   Token     │
                                        │  (15 min)   │
                                        └─────────────┘
                                        ┌─────────────┐
                                        │   Refresh   │
                                        │   Token     │
                                        │  (7 days)   │
                                        └─────────────┘
```

### Security Measures

1. **JWT Tokens**: Short-lived access tokens (15 min)
2. **Refresh Tokens**: Long-lived tokens stored securely
3. **HTTPS**: All API communication over TLS
4. **OTP Verification**: Phone and email verification
5. **Biometric Auth**: Optional fingerprint/face unlock
6. **Auto Logout**: On token refresh failure

---

## Third-Party Integrations

### Google Maps Platform

**APIs Used:**
- Google Maps Flutter SDK
- Google Places API (New)

**Configuration:**
```env
GOOGLE_MAPS_API_KEY=your_api_key
```

**Features:**
- Display nearby facilities on map
- Calculate distances
- Get facility details (name, address, rating, hours)

### Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | SDK | Framework |
| sizer | ^3.1.3 | Responsive design |
| fl_chart | ^1.1.1 | Health charts |
| google_fonts | ^6.3.3 | Typography |
| google_maps_flutter | ^2.5.3 | Maps display |
| geolocator | ^11.0.0 | Location services |
| http | ^1.2.0 | REST API calls |
| shared_preferences | ^2.2.2 | Local storage |
| qr_flutter | ^4.1.0 | QR code generation |
| file_picker | ^8.0.0 | File selection |
| image_picker | ^1.0.0 | Camera capture |
| local_auth | ^2.1.6 | Biometric auth |
| flutter_dotenv | ^5.1.0 | Environment config |
| cached_network_image | ^3.2.3 | Image caching |
| url_launcher | ^6.1.14 | External links |
| share_plus | ^10.0.0 | Share functionality |
| connectivity_plus | ^7.0.0 | Network monitoring |

---

## Deployment

### Android Build

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS Build

```bash
# Build for iOS
flutter build ios --release

# Archive for App Store
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -archivePath build/Runner.xcarchive archive
```

### Environment Configuration

Create `.env` file in project root:

```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### Backend Information

| Property | Value |
|----------|-------|
| Platform | Vercel |
| Runtime | Node.js |
| Framework | Express |
| Database | PostgreSQL |
| Base URL | `https://curanet-backend.vercel.app` |

---

## Summary

CuraNet provides a robust, secure, and user-friendly platform for healthcare management. With its modular architecture, intelligent caching, and comprehensive security measures, it delivers a reliable experience for patients managing their health information.

**Key Highlights:**
- Clean architecture with separation of concerns
- Efficient caching for offline support
- Secure JWT-based authentication
- Google Maps integration for location services
- Comprehensive medical record management
- Emergency-ready health information access
