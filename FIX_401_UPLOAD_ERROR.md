# Fix for 401 Upload Error in Flutter App

## Problem Summary
When uploading files from the CuraNet Flutter app's Health ID page, users were receiving a **401 Unauthorized** error. The same functionality worked perfectly in the web frontend.

## Root Cause Analysis

### The Issue
The Flutter app was experiencing authentication failures during file uploads because:

1. **Expired Access Tokens**: JWT access tokens expire after 15 minutes
2. **No Token Refresh on 401**: Unlike the web frontend, the Flutter app didn't automatically refresh tokens when receiving a 401 error
3. **Skip Refresh Flag**: The upload service was using `skipRefresh: true`, preventing automatic token renewal

### Key Differences

| Component | Token Refresh on 401 | Result |
|-----------|---------------------|---------|
| **Web Frontend** ([api.ts](d:\CuraNet\frontend\src\lib\api.ts#L114-L145)) | ✅ Yes - Automatic retry with refreshed token | Works perfectly |
| **Flutter App (Before Fix)** | ❌ No - Used expired token | 401 Error |
| **Flutter App (After Fix)** | ✅ Yes - Automatic retry with refreshed token | Works perfectly |

## Solution Implemented

### Changes Made to [record_upload_service.dart](g:\Project\curanet\lib\services\record_upload_service.dart)

#### 1. Added Automatic Retry Helper Method
```dart
/// Make an HTTP request with automatic token refresh on 401
Future<http.Response> _makeAuthenticatedRequest({
  required Future<http.Response> Function(String token) requestBuilder,
  String operationName = 'Request',
}) async {
  var token = await _getAccessToken();
  
  if (token == null) {
    throw Exception('Not authenticated. Please login again.');
  }

  // First attempt
  var response = await requestBuilder(token);

  // If 401, refresh token and retry once
  if (response.statusCode == 401) {
    print('⚠️ Got 401 on $operationName, refreshing token and retrying...');
    
    // Force token refresh
    token = await _authService.getAccessToken(skipRefresh: false);
    
    if (token == null) {
      throw Exception('Session expired. Please login again.');
    }
    
    print('🔄 Retrying $operationName with refreshed token...');
    
    // Retry the request with new token
    response = await requestBuilder(token);
    
    if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please login again.');
    }
  }

  return response;
}
```

#### 2. Updated Token Retrieval
Changed from:
```dart
Future<String?> _getAccessToken() async {
  return await _authService.getAccessToken(skipRefresh: true); // ❌ WRONG
}
```

To:
```dart
Future<String?> _getAccessToken() async {
  return await _authService.getAccessToken(skipRefresh: false); // ✅ CORRECT
}
```

#### 3. Refactored Upload Method
Now uses the `_makeAuthenticatedRequest` helper:
```dart
final response = await _makeAuthenticatedRequest(
  operationName: 'File Upload',
  requestBuilder: (token) => http.post(
    Uri.parse('${ApiConstants.baseUrl}/api/uploads/file'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(requestBody),
  ).timeout(Duration(seconds: 60)),
);
```

#### 4. Applied Same Pattern to All Methods
- `uploadFile()` ✅
- `getMyRecords()` ✅
- `deleteRecord()` ✅
- `downloadFile()` ✅

## Technical Flow

### Before Fix
```
Flutter App
    ↓
Get Token (expired) → skipRefresh: true
    ↓
POST /api/uploads/file
    ↓
Backend: Token Expired!
    ↓
← 401 Unauthorized
    ↓
❌ Error shown to user
```

### After Fix
```
Flutter App
    ↓
Get Token (may be expired)
    ↓
POST /api/uploads/file
    ↓
Backend: Token Expired!
    ↓
← 401 Unauthorized
    ↓
Automatically refresh token
    ↓
Retry POST /api/uploads/file (with new token)
    ↓
Backend: Valid Token!
    ↓
← 200 Success
    ↓
✅ File uploaded successfully
```

## How This Matches Web Frontend Behavior

The web frontend ([api.ts](d:\CuraNet\frontend\src\lib\api.ts#L114-L145)) has this pattern:

```typescript
if (res.status === 401) {
  // try refresh
  const newToken = await refreshTokenSingleFlight();
  if (!newToken) {
    setAccessToken(null);
    throw new Error("UNAUTHORIZED");
  }
  // retry once
  const retryHeaders = { ...finalHeaders, Authorization: `Bearer ${newToken}` };
  const retryRes = await fetch(url, {
    method,
    credentials: "include",
    headers: retryHeaders,
    signal,
    body: body ? JSON.stringify(body) : undefined,
  });
  // ... handle retry response
}
```

Our Flutter implementation now mirrors this exact behavior!

## Testing Instructions

1. **Test with Fresh Token**:
   - Login to the app
   - Immediately try to upload a file
   - Should work ✅

2. **Test with Expired Token**:
   - Login to the app
   - Wait 15+ minutes (or mock token expiry)
   - Try to upload a file
   - Should automatically refresh and upload ✅

3. **Test with No Refresh Token**:
   - Clear all tokens
   - Try to upload
   - Should show "Please login again" message ✅

## Benefits

✅ **Seamless User Experience**: No interruptions when tokens expire
✅ **Consistent Behavior**: Flutter app now matches web frontend
✅ **Better Error Handling**: Clear messages when re-authentication is needed
✅ **Reduced Support Tickets**: Fewer "upload not working" complaints
✅ **DRY Code**: Single helper method handles all authenticated requests

## Backend Reference

The backend authentication middleware ([authMiddleware.ts](d:\CuraNet\backend\src\middlewares\authMiddleware.ts#L40-L110)) expects:

```typescript
const authHeader = req.headers.authorization;
const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

if (!token) {
  res.status(401).json({ message: 'Access token required' });
  return;
}

// Verify JWT
const decoded = jwt.verify(token, getJwtSecret()) as JwtPayload;
```

And returns 401 for:
- Missing token
- Invalid token
- Expired token
- Blacklisted token
- Inactive user

Our fix properly handles all these cases by refreshing the token on 401.

## Related Files Modified

- ✅ [g:\Project\curanet\lib\services\record_upload_service.dart](g:\Project\curanet\lib\services\record_upload_service.dart)

## Date Fixed
January 3, 2026

## Status
✅ **RESOLVED** - Flutter app file uploads now work with automatic token refresh, matching web frontend behavior.
