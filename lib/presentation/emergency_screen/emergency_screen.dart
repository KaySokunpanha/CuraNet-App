import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../services/care_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curanet/routes/app_routes.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final CareService _careService = CareService();
  bool _isLoading = true;
  Map<String, dynamic>? _emergencyData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEmergencyData();
  }

  Future<void> _loadEmergencyData() async {
    try {
      final data = await _careService.getEmergencyCard(forceRefresh: true);
      if (mounted) {
        setState(() {
          _emergencyData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load emergency data';
          _isLoading = false;
        });
      }
    }
  }

  String? _formatContent(dynamic content) {
    if (content == null) return null;
    if (content is String) return content;
    if (content is List) {
      if (content.isEmpty) return 'None';
      return content.map((e) => e.toString()).join(', ');
    }
    return content.toString();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        elevation: 0,
        title: const Text(
          'Emergency Card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _emergencyData == null
          ? const Center(child: Text('No emergency data available'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 20),
                  _buildCriticalSection(
                    title: 'Allergies',
                    icon: Icons.warning_amber_rounded,
                    content: _formatContent(_emergencyData!['allergies']),
                    isHighlighted: true,
                  ),
                  _buildCriticalSection(
                    title: 'Blood Group',
                    icon: Icons.bloodtype,
                    content: _formatContent(_emergencyData!['blood_group']),
                    isCompact: true,
                  ),
                  _buildCriticalSection(
                    title: 'Chronic Conditions',
                    icon: Icons.medical_information,
                    content: _formatContent(
                      _emergencyData!['chronic_conditions'],
                    ),
                  ),
                  _buildCriticalSection(
                    title: 'Current Medications',
                    icon: Icons.medication,
                    content: _formatContent(
                      _emergencyData!['current_medications'],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEmergencyContact(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.nearbyCareScreen,
                        );
                      },
                      icon: const Icon(Icons.local_hospital),
                      label: const Text('Find Nearby Hospital'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.red[700]!, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700]!, Colors.red[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
            // TODO: Add image support if available
          ),
          const SizedBox(height: 16),
          Text(
            _emergencyData!['name'] ?? 'Unknown Name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${_emergencyData!['health_id']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalSection({
    required String title,
    required IconData icon,
    required String? content,
    bool isHighlighted = false,
    bool isCompact = false,
  }) {
    if (content == null || content.isEmpty || content == 'None')
      return const SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isHighlighted ? Colors.red[50] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.red[100] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isHighlighted ? Colors.red[700] : Colors.grey[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: isCompact ? 24 : 16,
                      fontWeight: isCompact
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isHighlighted ? Colors.red[900] : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    final contact = _emergencyData!['emergency_contact'];
    // Assuming format "Name (Relationship) - Number" or simplified
    // This is a basic implementation, improved parsing can be added

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EMERGENCY CONTACT',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.phone, color: Colors.white),
            ),
            title: Text(
              contact ?? 'Not provided',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Tap to call'),
            onTap: () {
              // Basic extraction of numbers, can be improved
              final RegExp phoneRegExp = RegExp(r'[0-9]{10,}');
              final match = phoneRegExp.firstMatch(contact ?? '');
              if (match != null) {
                _makePhoneCall(match.group(0)!);
              }
            },
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
