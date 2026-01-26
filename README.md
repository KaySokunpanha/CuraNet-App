<p align="center">
  <img src="assets/images/CuraNet.png" alt="CuraNet Logo" width="120"/>
</p>

<h1 align="center">CuraNet</h1>

<p align="center">
  <strong>Your Complete Digital Health Companion</strong>
</p>

<p align="center">
  A modern Flutter-based mobile health application that empowers patients to manage their medical records, appointments, health vitals, and emergency information — all in one secure platform.
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#installation">Installation</a> •
  <a href="#project-structure">Project Structure</a> •
  <a href="#api-integration">API Integration</a> •
  <a href="#license">License</a>
</p>

---

## Features

### 🏥 Health Dashboard
- Comprehensive health profile overview
- Recent activity timeline (encounters, prescriptions, diagnoses)
- Quick access to vital statistics and health metrics
- Data caching for offline accessibility

### 📋 Medical Records Management
- Upload and organize medical documents (Lab Reports, Prescriptions, Scans, Discharge Summaries)
- Secure file storage with Base64 encoding
- Filter and categorize records by type
- Download and share records

### 📅 Appointments
- View upcoming and past appointments
- Appointment status tracking (Pending, Confirmed, Cancelled, Rejected)
- Doctor information and consultation details

### 🚨 Emergency Services
- Emergency Card with critical health information
- Blood group, allergies, and emergency contacts
- Quick access QR code for sharing
- One-tap emergency dialer

### 🗺️ Nearby Care
- Find nearby hospitals, pharmacies, and labs
- Google Places API integration for real-time data
- Distance calculation and directions
- Open/Closed status and ratings

### 👤 User Profile
- Complete health profile management
- Email/Phone verification with OTP
- Update personal and medical information
- Biometric authentication support

### 🔐 Secure Authentication
- JWT-based authentication with refresh tokens
- Phone and Email OTP verification
- Auto token refresh mechanism
- Device fingerprinting

---

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform mobile framework |
| **Dart** | Programming language |
| **Sizer** | Responsive UI design |
| **Google Fonts** | Typography |
| **fl_chart** | Health data visualization |
| **Google Maps Flutter** | Location & mapping |
| **Geolocator** | Device location services |
| **SharedPreferences** | Local data caching |
| **HTTP** | RESTful API communication |
| **QR Flutter** | QR code generation |
| **File Picker / Image Picker** | Document upload |
| **Local Auth** | Biometric authentication |
| **Flutter Dotenv** | Environment configuration |

---

## Installation

### Prerequisites
- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code
- Git

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/mukundjha-mj/CuraNet-App.git
   cd CuraNet-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   Create a `.env` file in the root directory:
   ```env
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

5. **Build APK** (for production)
   ```bash
   flutter build apk --release
   ```

---

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── core/
│   ├── app_export.dart       # Common exports
│   └── utils/                # Utility functions
├── routes/
│   └── app_routes.dart       # Navigation configuration
├── services/
│   ├── api_constants.dart    # API endpoints
│   ├── auth_service.dart     # Authentication logic
│   ├── health_service.dart   # Health data management
│   ├── care_service.dart     # Care profile & vitals
│   ├── nearby_service.dart   # Location-based services
│   ├── record_upload_service.dart  # File uploads
│   └── global_data_sync_service.dart  # Data synchronization
├── presentation/
│   ├── splash_screen/        # App splash screen
│   ├── authentication_screen/ # Login & registration
│   ├── onboarding_flow/      # First-time user setup
│   ├── health_dashboard/     # Main dashboard
│   ├── medical_records_screen/ # Records management
│   ├── patient_record_view/  # Detailed record view
│   ├── appointments_screen/  # Appointments list
│   ├── schedule_screen/      # Schedule management
│   ├── profile_screen/       # User profile
│   ├── emergency_screen/     # Emergency information
│   ├── nearby_care_screen/   # Nearby facilities
│   └── share_id_screen/      # QR sharing
├── theme/
│   ├── app_theme.dart        # Light/Dark themes
│   ├── app_decoration.dart   # UI decorations
│   └── custom_text_style.dart # Typography styles
└── widgets/
    ├── custom_app_bar.dart   # Navigation bar
    ├── custom_bottom_bar.dart # Bottom navigation
    ├── custom_elevated_button.dart
    └── ...                   # Reusable components
```

---

## API Integration

CuraNet connects to a Node.js/Express backend deployed on Vercel.

### Base URL
```
https://curanet-backend.vercel.app
```

### Key Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/register` | POST | User registration |
| `/api/auth/login` | POST | User login |
| `/api/auth/refresh` | POST | Refresh access token |
| `/api/auth/me` | GET | Get user profile |
| `/api/profile` | GET/POST | Health profile management |
| `/api/appointments/patient` | GET | Patient appointments |
| `/api/records/encounters/list` | POST | Medical encounters |
| `/api/records/observations/list` | POST | Vitals & observations |
| `/api/uploads/file` | POST | Upload medical records |
| `/api/emergency/card` | GET | Emergency card data |

---

## Backend Repository

The backend source code is available at:
- **Repository**: [CuraNet-Backend](https://github.com/mukundjha-mj/CuraNet-Backend)

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contact

For any queries or suggestions, feel free to reach out:

- **Email**: mukundjha204@gmail.com
- **GitHub**: [@mukundjha-mj](https://github.com/mukundjha-mj)

---

<p align="center">
  Made with ❤️ using Flutter
</p>
