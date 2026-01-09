import '../../core/app_export.dart';
import '../../services/health_service.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> currentProfile;

  const EditProfileScreen({super.key, required this.currentProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final HealthService _healthService = HealthService();

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _otpController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _addressController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicationsController;

  String? _selectedGender;
  String? _selectedBloodGroup;
  DateTime? _selectedDateOfBirth;
  bool _isLoading = false;
  
  // Email OTP states
  bool _isEmailVerified = false;
  bool _showOtpField = false;
  bool _isLoadingSendOtp = false;
  bool _isLoadingVerifyOtp = false;
  String _emailErrorMessage = '';
  String _currentEmail = '';

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroupOptions = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = widget.currentProfile['profile'];
    
    _firstNameController = TextEditingController(text: profile?['firstName'] ?? '');
    _lastNameController = TextEditingController(text: profile?['lastName'] ?? '');
    _displayNameController = TextEditingController(text: profile?['displayName'] ?? '');
    _emailController = TextEditingController(text: profile?['email'] ?? '');
    _otpController = TextEditingController();
    _emergencyContactController = TextEditingController(text: profile?['emergencyContact'] ?? '');
    _emergencyPhoneController = TextEditingController(text: profile?['emergencyPhone'] ?? '');
    
    // Parse address
    String address = '';
    if (profile?['address'] != null) {
      if (profile['address'] is String) {
        address = profile['address'];
      } else if (profile['address'] is Map) {
        final addr = profile['address'];
        address = '${addr['street'] ?? ''}, ${addr['city'] ?? ''}, ${addr['state'] ?? ''}, ${addr['zipCode'] ?? ''}'.replaceAll(', , ', ', ').trim();
      }
    }
    _addressController = TextEditingController(text: address);
    
    // Parse allergies and medications
    _allergiesController = TextEditingController(text: _parseListToString(profile?['allergies']));
    _medicationsController = TextEditingController(text: _parseListToString(profile?['medications']));
    
    _selectedGender = profile?['gender'];
    _selectedBloodGroup = profile?['bloodGroup'];
    _currentEmail = profile?['email'] ?? '';
    
    if (profile?['dateOfBirth'] != null) {
      try {
        _selectedDateOfBirth = DateTime.parse(profile['dateOfBirth']);
      } catch (e) {
        _selectedDateOfBirth = null;
      }
    }
    
    // Listen to email and OTP changes
    _emailController.addListener(_onEmailChanged);
    _otpController.addListener(_onOtpChanged);
  }
  
  void _onEmailChanged() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && _isValidEmail(email)) {
      setState(() {
        _emailErrorMessage = '';
      });
    }
  }
  
  void _onOtpChanged() async {
    final otp = _otpController.text.trim();
    if (otp.length == 6) {
      // Auto-submit when 6 digits entered
      await _verifyOtp();
    }
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  String _parseListToString(dynamic list) {
    if (list == null) return '';
    if (list is List) return list.join(', ');
    if (list is String) return list;
    return '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _addressController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1976D2),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'displayName': _displayNameController.text.trim().isEmpty 
            ? _firstNameController.text.trim()
            : _displayNameController.text.trim(),
        'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
        'gender': _selectedGender,
        'bloodGroup': _selectedBloodGroup,
        'address': _addressController.text.trim(),
        'emergencyContact': _emergencyContactController.text.trim(),
        'emergencyPhone': _emergencyPhoneController.text.trim(),
        'allergies': _allergiesController.text.isEmpty 
            ? [] 
            : _allergiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        'medications': _medicationsController.text.isEmpty 
            ? [] 
            : _medicationsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      };

      final result = await _healthService.updateProfile(data);

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Please enter email address';
      });
      return;
    }
    
    if (!_isValidEmail(email)) {
      setState(() {
        _emailErrorMessage = 'Please enter a valid email address';
      });
      return;
    }
    
    setState(() {
      _isLoadingSendOtp = true;
      _emailErrorMessage = '';
    });
    
    try {
      final result = await _healthService.sendEmailOtp(email);
      
      if (!mounted) return;
      
      if (result['success'] == true) {
        setState(() {
          _showOtpField = true;
          _isLoadingSendOtp = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isLoadingSendOtp = false;
          _emailErrorMessage = result['message'] ?? 'Failed to send OTP';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingSendOtp = false;
        _emailErrorMessage = 'Error: $e';
      });
    }
  }
  
  Future<void> _verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    
    if (otp.length != 6) {
      return;
    }
    
    setState(() {
      _isLoadingVerifyOtp = true;
      _emailErrorMessage = '';
    });
    
    try {
      final result = await _healthService.verifyEmailOtp(email, otp);
      
      if (!mounted) return;
      
      if (result['success'] == true) {
        setState(() {
          _isLoadingVerifyOtp = false;
          _isEmailVerified = true;
          _showOtpField = false;
          _currentEmail = email;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isLoadingVerifyOtp = false;
          _emailErrorMessage = result['message'] ?? 'Invalid OTP';
        });
        _otpController.clear();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingVerifyOtp = false;
        _emailErrorMessage = 'Error: $e';
      });
      _otpController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1976D2)),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Personal Information Section
            _buildSectionHeader('Personal Information', Icons.person),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'First name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Last name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _displayNameController,
              label: 'Display Name (Optional)',
              icon: Icons.badge,
            ),
            const SizedBox(height: 12),
            _buildDateField(),
            const SizedBox(height: 12),
            _buildDropdownField(
              label: 'Gender',
              icon: Icons.wc,
              value: _selectedGender,
              items: _genderOptions,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Health Information Section
            _buildSectionHeader('Health Information', Icons.favorite),
            const SizedBox(height: 12),
            _buildDropdownField(
              label: 'Blood Group',
              icon: Icons.water_drop,
              value: _selectedBloodGroup,
              items: _bloodGroupOptions,
              onChanged: (value) {
                setState(() {
                  _selectedBloodGroup = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _allergiesController,
              label: 'Allergies (comma separated)',
              icon: Icons.warning_amber,
              hint: 'e.g., Peanuts, Penicillin',
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _medicationsController,
              label: 'Current Medications (comma separated)',
              icon: Icons.medication,
              hint: 'e.g., Aspirin, Vitamin D',
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Update Email Section
            _buildSectionHeader('Update Email', Icons.email),
            const SizedBox(height: 12),
            _buildEmailUpdateSection(),

            const SizedBox(height: 24),

            // Emergency Contact Section
            _buildSectionHeader('Emergency Contact', Icons.emergency),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _emergencyContactController,
              label: 'Emergency Contact Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _emergencyPhoneController,
              label: 'Emergency Contact Phone',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1976D2), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: const Icon(Icons.cake, color: Color(0xFF1976D2)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          _selectedDateOfBirth != null
              ? DateFormat('MMM dd, yyyy').format(_selectedDateOfBirth!)
              : 'Select date',
          style: TextStyle(
            color: _selectedDateOfBirth != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text('Select $label'),
    );
  }
  
  Widget _buildEmailUpdateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email input field with Send OTP button
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  enabled: !_showOtpField && !_isEmailVerified,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF1976D2)),
                    suffixIcon: _isEmailVerified 
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    filled: true,
                    fillColor: (_showOtpField || _isEmailVerified) 
                        ? const Color(0xFFF5F7FA) 
                        : Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 12),
              // Send OTP Button or Checkmark
              if (!_isEmailVerified)
                SizedBox(
                  width: 100,
                  height: 56,
                  child: _isLoadingSendOtp
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: (_emailController.text.trim().isNotEmpty && 
                                     _isValidEmail(_emailController.text.trim()) &&
                                     !_showOtpField)
                              ? _sendOtp
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Send OTP',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
            ],
          ),
          
          // Error message
          if (_emailErrorMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _emailErrorMessage,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // OTP Input field (shows after Send OTP)
          if (_showOtpField && !_isEmailVerified) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              enabled: !_isLoadingVerifyOtp,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                hintText: '6-digit code',
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF1976D2)),
                suffixIcon: _isLoadingVerifyOtp 
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 8),
            // Resend OTP button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoadingSendOtp ? null : _sendOtp,
                child: const Text('Resend OTP'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
