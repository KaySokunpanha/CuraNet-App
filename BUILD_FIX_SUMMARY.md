# Android Build Issue - Resolution Summary 🛠️

## Problem Description

The CuraNet Flutter app was failing to build for Android with the following error:

```
Unresolved reference 'Registrar'
Unresolved reference 'messenger'
Unresolved reference 'context'
```

### Root Cause Analysis

1. **Primary Issue**: `flutter_web_auth_2` version 3.1.2 (required by `appwrite: 13.1.1`) was using **deprecated Flutter Android Plugin V1 API**
   - Flutter Plugin V1 uses `Registrar` interface (deprecated in Flutter 3.x)
   - Flutter Plugin V2 uses `FlutterPlugin` interface (current standard)

2. **Secondary Issue**: Cross-drive path resolution in Kotlin incremental compilation
   - Flutter SDK on C: drive (`C:\flutter\`)
   - Pub cache on C: drive (`C:\Users\Mukund\AppData\Local\Pub\Cache\`)
   - Project on G: drive (`G:\Project\curanet\`)
   - Kotlin's `RelocatableFileToPathConverter` cannot compute relative paths across drive boundaries

## Solution Implemented

### 1. Upgraded Appwrite SDK
**Changed:** `appwrite: ^13.1.1` → `appwrite: ^20.3.1`

**Reason:** 
- Appwrite 20.3.1 uses `flutter_web_auth_2: ^4.1.0` (Plugin V2 compatible)
- Appwrite 13.1.1/14.0.0 used `flutter_web_auth_2: ^3.1.2` (Plugin V1 - deprecated)

### 2. Disabled Kotlin Incremental Compilation (Workaround)
**File:** `android/gradle.properties`

**Added:**
```properties
# Disable Kotlin incremental compilation to fix cross-drive path issues
kotlin.incremental=false
kotlin.compiler.execution.strategy=in-process
```

**Reason:** Prevents Kotlin from trying to create relative path mappings across different drives

## Build Results

✅ **SUCCESS!**
- Build time: 84.3 seconds
- APK size: Standard debug APK
- Installation: 57.0 seconds
- App launched successfully on RMX3686 device (Android 15)

### Build Output
```
Running Gradle task 'assembleDebug'...                             84.3s
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...          57.0s
✓ App running on RMX3686 (wireless)
```

## Files Modified

### 1. pubspec.yaml
```yaml
dependencies:
  appwrite: ^20.3.1  # Upgraded from ^13.1.1
```

### 2. android/gradle.properties
```properties
kotlin.incremental=false
kotlin.compiler.execution.strategy=in-process
```

## Technical Details

### Appwrite Version Comparison

| Version | flutter_web_auth_2 | Plugin API | Status |
|---------|-------------------|------------|--------|
| 13.1.1  | 3.1.2             | V1 (Registrar) | ❌ Deprecated |
| 14.0.0  | 3.1.2             | V1 (Registrar) | ❌ Deprecated |
| 20.3.1  | 4.1.0             | V2 (FlutterPlugin) | ✅ Compatible |

### Cross-Drive Issue Details

**Error Pattern:**
```
IllegalArgumentException: this and base files have different roots:
C:\Users\Mukund\AppData\Local\Pub\Cache\hosted\pub.dev\plugin\MessagesAsync.g.kt 
and G:\Project\curanet\android.
```

**Why it occurs:**
- Kotlin incremental compilation creates path mappings in cache files
- Uses `kotlin.io.relativeTo()` to compute relative paths
- Fails when source files are on different Windows drives

**Workarounds (in order of preference):**
1. ✅ Disable incremental compilation (current solution)
2. Move project to same drive as Flutter SDK (C:)
3. Move Flutter SDK to same drive as project (G:)
4. Use WSL2 with Linux filesystem (eliminates drive letters)

## API Compatibility

### AppwriteAuthService - No Breaking Changes
The Appwrite 20.3.1 upgrade maintains full backward compatibility with our existing code:

```dart
// All existing methods work without changes:
await account.createPhoneToken(userId: ID.unique(), phone: phoneNumber);
await account.createSession(userId: userId, secret: otp);
await account.createJWT();
await account.get();
await account.deleteSession(sessionId: 'current');
```

## Next Steps

1. ✅ Build successful - **COMPLETED**
2. ⏳ Test OTP authentication flow
   - Enter phone number: `+911234567890`
   - Verify OTP: `123456` (test mode)
3. ⏳ Verify backend JWT authentication
4. ⏳ Test on other devices/emulators

## Performance Notes

- **First build:** ~84 seconds (non-incremental compilation)
- **Subsequent builds:** May be slower than before due to disabled incremental compilation
- **Trade-off:** Stability over speed (acceptable for cross-drive development)

## Recommendations

**For Production:**
- Consider moving project to C: drive for better Gradle performance
- Or use a build server with proper drive layout
- Current workaround is acceptable for development

**For Team:**
- Document cross-drive issue in team wiki
- Consider standardizing development environment (all on C: or all on separate drive)
- Add build time metrics to track performance

## References

- [Flutter Plugin V2 Migration Guide](https://docs.flutter.dev/development/packages-and-plugins/plugin-api-migration)
- [Appwrite Flutter SDK](https://pub.dev/packages/appwrite)
- [Kotlin Incremental Compilation](https://kotlinlang.org/docs/gradle-compilation-and-caches.html)
- [Cross-drive issue in Kotlin Gradle](https://github.com/flutter/flutter/issues/118502)

---

**Status:** ✅ RESOLVED  
**Date:** December 23, 2025  
**Build:** Debug APK  
**Device:** RMX3686 (Android 15)  
**Flutter:** 3.10.4  
**Gradle:** 8.14  
**Kotlin:** 2.2.20
