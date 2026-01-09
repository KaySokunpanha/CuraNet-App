# Quick Start Guide

## ⚡ Immediate Next Steps

### 1. Get Your Appwrite Project ID (5 minutes)

```bash
1. Visit: https://cloud.appwrite.io
2. Sign up / Login
3. Click "Create Project"
4. Name: "CuraNet"
5. Copy the Project ID shown
```

### 2. Update Configuration

Open this file and paste your Project ID:
```
lib/core/appwrite_config.dart
```

Replace:
```dart
static const String projectId = 'YOUR_PROJECT_ID';
```

With your actual ID:
```dart
static const String projectId = '67abc123def456'; // Your ID here
```

### 3. Add Android Platform in Appwrite

```bash
1. Appwrite Console → Settings → Platforms
2. Click "Add Platform" → Android
3. Package Name: com.example.curanet
4. App Name: CuraNet
5. Save
```

### 4. Enable Phone Auth + Test Numbers

```bash
1. Appwrite Console → Authentication
2. Enable "Phone" method
3. Scroll down to "Phone numbers for testing"
4. Add: +911234567890 → OTP: 123456
5. Save
```

### 5. Test the App

```bash
flutter run
```

Enter test phone: **1234567890** (without +91)
Enter OTP: **123456**

## 🎉 You're Done!

The app will now work with test numbers WITHOUT needing SMS provider setup.

## 📱 For Real SMS (Production)

Later, when ready for production:

1. Appwrite Console → Settings → Messaging
2. Add Provider → Choose MSG91 or Twilio
3. Enter your SMS provider credentials
4. Remove test numbers
5. Real SMS will work automatically!

## 🔧 Backend Setup

Add to `backend/.env`:
```env
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id_here
```

Restart backend server.

---

See [APPWRITE_MIGRATION.md](APPWRITE_MIGRATION.md) for detailed documentation.
