# CuraNet OTP Testing Guide 🧪

## Current Status
✅ **App is running on device RMX3686**  
✅ **Backend is running on http://localhost:3001**  
✅ **Appwrite project configured (ID: 694a115800137473397e)**

## Prerequisites
1. Appwrite Console: https://cloud.appwrite.io
2. Project: CuraNet (694a115800137473397e)
3. Phone Auth enabled in Appwrite Console

## Test Scenarios

### Scenario 1: Test Phone Authentication with Test Number
Appwrite supports test phone numbers for development:

1. **In Appwrite Console:**
   - Go to Auth → Settings → Phone Auth
   - Enable "Test Numbers"
   - Add test number: `+911234567890` with OTP: `123456`

2. **In CuraNet App:**
   - Open phone authentication screen
   - Enter: `+911234567890`
   - Click "Send OTP"
   - Enter OTP: `123456`
   - Click "Verify"

3. **Expected Result:**
   - ✅ OTP sent successfully
   - ✅ Verification successful
   - ✅ User session created
   - ✅ JWT token generated
   - ✅ Backend login successful

### Scenario 2: Test with Real Phone Number (Production)

1. **In CuraNet App:**
   - Open phone authentication screen
   - Enter your real phone number with country code (e.g., `+919876543210`)
   - Click "Send OTP"
   - Check your phone for SMS with OTP code
   - Enter the received OTP
   - Click "Verify"

2. **Expected Result:**
   - ✅ SMS received with OTP
   - ✅ Verification successful
   - ✅ User session created
   - ✅ JWT token generated
   - ✅ Backend login successful

## Test Checklist

### Frontend (Flutter App)
- [ ] Phone number input accepts international format (+91...)
- [ ] "Send OTP" button shows loading state
- [ ] OTP sent success message displays
- [ ] OTP input field appears after sending OTP
- [ ] "Verify" button validates OTP
- [ ] Verification success message displays
- [ ] Navigation to home/dashboard after successful login

### Backend (Node.js API)
Monitor backend logs for:
- [ ] POST request to `/api/auth/appwrite-phone-login`
- [ ] JWT verification with Appwrite
- [ ] User lookup/creation in database
- [ ] Access token generation
- [ ] Response with user data and token

### Appwrite Console
Check in Appwrite Console:
- [ ] Auth → Users: New user appears after verification
- [ ] User has phone number verified
- [ ] Session created for user

## Error Testing

### Test Invalid OTP
1. Enter phone number: `+911234567890`
2. Send OTP
3. Enter wrong OTP: `999999`
4. Expected: "Invalid OTP code" error message

### Test Expired OTP
1. Enter phone number
2. Send OTP
3. Wait 10 minutes (OTP expires)
4. Enter OTP
5. Expected: "OTP expired" error message

### Test Rate Limiting
1. Send OTP multiple times rapidly (>5 times in 1 minute)
2. Expected: "Too many requests. Please try again later" error

## Backend Testing Commands

### Check Backend Health
```bash
curl http://localhost:3001/api/auth/health
```

### Test Appwrite Phone Login Endpoint
```bash
curl -X POST http://localhost:3001/api/auth/appwrite-phone-login \
  -H "Content-Type: application/json" \
  -d '{"jwt": "YOUR_JWT_TOKEN_HERE"}'
```

## Debugging Tips

### If OTP not received:
1. Check Appwrite Console → Auth → Phone Auth is enabled
2. Verify phone number format includes country code (+91...)
3. Check Appwrite Console → Auth → Settings → SMS Provider is configured
4. For testing, use test numbers instead of real numbers

### If JWT verification fails:
1. Check backend `.env` has correct `APPWRITE_ENDPOINT` and `APPWRITE_PROJECT_ID`
2. Verify JWT token is not expired (tokens expire after 15 minutes)
3. Check backend logs for Appwrite API errors

### If backend login fails:
1. Verify PostgreSQL database is running
2. Check database has `users` table
3. Verify backend environment variables are loaded

## Current Configuration

### Appwrite
- **Endpoint:** https://sgp.cloud.appwrite.io/v1
- **Region:** Singapore (sgp)
- **Project ID:** 694a115800137473397e
- **Auth Method:** Phone (OTP)

### Backend
- **Port:** 3001
- **Auth Endpoint:** http://localhost:3001/api/auth/appwrite-phone-login
- **Database:** PostgreSQL (via Prisma)

### Flutter App
- **Debug Mode:** Running on RMX3686
- **Appwrite SDK:** 20.3.1
- **Hot Reload:** Enabled (press 'r' in terminal)

## Success Criteria

✅ **Authentication Flow Complete When:**
1. User can enter phone number
2. OTP is sent (test or real SMS)
3. User can enter OTP
4. OTP verification succeeds
5. JWT token is generated
6. Backend creates/updates user record
7. Access token returned to app
8. User navigated to authenticated screens

## Next Actions

1. **Test with Test Number:** `+911234567890` / OTP: `123456`
2. **Verify Backend Logs:** Check POST requests and JWT verification
3. **Check Appwrite Console:** Verify user creation and sessions
4. **Test Error Scenarios:** Invalid OTP, expired OTP, rate limiting
5. **Test Real Number:** Use actual phone to receive SMS

## Monitoring

### Flutter App Logs
In VS Code terminal where `flutter run` is active, watch for:
- OTP send request logs
- OTP verification logs
- Backend API call logs
- Error messages (if any)

### Backend Logs
In backend terminal, watch for:
- Appwrite JWT verification logs
- User lookup/creation logs
- Token generation logs
- Any error stack traces

### Appwrite Console
Monitor in real-time:
- Auth → Users: New users appearing
- Auth → Sessions: Active sessions
- Overview: Request count, errors

---

**Ready to Test!** 🚀

Start with Scenario 1 (test number) to verify the complete flow without using SMS credits.
