import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../services/auth_service.dart';

class PhoneAuthWidget extends StatefulWidget {
  final bool isLogin;

  const PhoneAuthWidget({super.key, required this.isLogin});

  @override
  State<PhoneAuthWidget> createState() => _PhoneAuthWidgetState();
}

class _PhoneAuthWidgetState extends State<PhoneAuthWidget> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();

  bool _codeSent = false;
  bool _isLoading = false;
  String? _fullPhoneNumber;
  String? _errorMessage;
  bool _showPassword = false;

  _CountryCode _selectedCountry = _countryCodes.first;
  static const List<_CountryCode> _countryCodes = [
    _CountryCode(name: 'India', code: '+91', flag: '🇮🇳'),
    _CountryCode(name: 'United States', code: '+1', flag: '🇺🇸'),
    _CountryCode(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
    _CountryCode(name: 'Australia', code: '+61', flag: '🇦🇺'),
    _CountryCode(name: 'Japan', code: '+81', flag: '🇯🇵'),
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (phone.length < 5) {
      setState(() => _errorMessage = 'Please enter a valid phone number');
      return;
    }

    if (!widget.isLogin) {
      if (name.isEmpty) {
        setState(() => _errorMessage = 'Please enter your name');
        return;
      }

      if (password.length < 8) {
        setState(
          () => _errorMessage = 'Password must be at least 8 characters',
        );
        return;
      }
    } else {
      if (password.length < 8) {
        setState(
          () => _errorMessage = 'Password must be at least 8 characters',
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final fullPhone = '${_selectedCountry.code}$phone';

    if (widget.isLogin) {
      // For login, verify phone and password directly
      final result = await _authService.login(
        phone: fullPhone,
        password: password,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/main-screen');
      } else {
        setState(() => _errorMessage = result['message']);
      }
    } else {
      // For registration, register and send OTP
      final result = await _authService.register(
        phone: fullPhone,
        password: password,
        role: 'patient',
        name: name,
      );

      if (!mounted) return;

      if (result['success']) {
        setState(() {
          _isLoading = false;
          _codeSent = true;
          _fullPhoneNumber = fullPhone;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to $fullPhone'),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['message'];
        });
      }
    }
  }

  void _verifyCode() async {
    if (_otpController.text.length < 6 || _fullPhoneNumber == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    print('📞 Verifying OTP for: $_fullPhoneNumber');
    print('🔢 OTP: ${_otpController.text}');

    // Verify OTP with backend
    final result = await _authService.verifyPhoneOtp(
      phone: _fullPhoneNumber!,
      otp: _otpController.text,
    );

    print('✅ Verification result: $result');

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      print('🎉 Phone verified successfully!');

      if (mounted) {
        // Auto-login after successful verification
        print('🔐 Auto-logging in...');

        final loginResult = await _authService.login(
          phone: _fullPhoneNumber!,
          password: _passwordController.text,
        );

        if (!mounted) return;

        setState(() => _isLoading = false);

        if (loginResult['success']) {
          print('✅ Auto-login successful!');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Registration successful! Logging you in...'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to dashboard
          Navigator.pushReplacementNamed(context, '/main-screen');
        } else {
          print('❌ Auto-login failed: ${loginResult['message']}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Phone verified! ${loginResult['message'] ?? 'Please login manually'}',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );

          // Reset form to login state
          setState(() {
            _codeSent = false;
            _otpController.clear();
            _fullPhoneNumber = null;
            _errorMessage = null;
          });
        }
      }
    } else {
      print('❌ Verification failed: ${result['message']}');
      setState(() {
        _errorMessage = result['message'] ?? 'OTP verification failed';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'OTP verification failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildCountryCodePicker() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<_CountryCode>(
        value: _selectedCountry,
        isDense: true,
        alignment: Alignment.centerLeft,
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: Theme.of(context).cardColor,
        selectedItemBuilder: (context) => _countryCodes
            .map(
              (country) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${country.flag} ${country.code}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
            .toList(),
        items: _countryCodes
            .map(
              (country) => DropdownMenuItem<_CountryCode>(
                value: country,
                child: Row(
                  children: [
                    Text(country.flag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${country.code}  ${country.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() => _selectedCountry = value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_codeSent) ...[
          // Name field (only for registration)
          if (!widget.isLogin) ...[
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.35
                      : 0.9,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 6),
                child: SizedBox(width: 110, child: _buildCountryCodePicker()),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 110),
              suffixIcon: const Icon(Icons.phone_outlined),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.35
                    : 0.9,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: !_showPassword,
            autofillHints: widget.isLogin
                ? [AutofillHints.password]
                : [AutofillHints.newPassword],
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.35
                    : 0.9,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendCode,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.isLogin ? 'Login' : 'Register & Send OTP'),
            ),
          ),
        ] else ...[
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              hintText: 'Enter 6-digit OTP',
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.35
                    : 0.9,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verify & Login'),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _codeSent = false),
            child: const Text('Change Phone Number'),
          ),
        ],
      ],
    );
  }
}

class _CountryCode {
  final String name;
  final String code;
  final String flag;

  const _CountryCode({
    required this.name,
    required this.code,
    required this.flag,
  });
}
