import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../services/health_service.dart';
import '../../services/auth_service.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _healthService = HealthService();
  final _authService = AuthService();

  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter =
      'ALL'; // ALL, PENDING, CONFIRMED, REJECTED, CANCELLED

  @override
  void initState() {
    super.initState();
    _loadCachedDataSync();
    _loadAppointments();
  }

  // Load cached data synchronously first to avoid loading state
  void _loadCachedDataSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load appointments from cache
      final cachedAppointments = prefs.getString('cached_appointments');
      if (cachedAppointments != null) {
        final appointmentsData = jsonDecode(cachedAppointments);
        if (appointmentsData['success'] &&
            appointmentsData['data'] != null &&
            mounted) {
          setState(() {
            _appointments = List<Map<String, dynamic>>.from(
              appointmentsData['data']['appointments'] ?? [],
            );
          });
        }
      }
    } catch (e) {
      print('Error loading cached appointments: $e');
    }
  }

  Future<void> _loadAppointments() async {
    try {
      // Fetch appointments (will return cached data instantly)
      final result = await _healthService.getAppointments();

      if (result['success'] && result['data'] != null) {
        if (mounted) {
          setState(() {
            _appointments = List<Map<String, dynamic>>.from(
              result['data']['appointments'] ?? [],
            );
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = result['message'] ?? 'Failed to load appointments';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load appointments: $e';
        });
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return '--:--';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return '--:--';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Color(0xFF4CAF50);
      case 'PENDING':
        return Color(0xFFF59E0B);
      case 'REJECTED':
        return Color(0xFFF44336);
      case 'CANCELLED':
        return Color(0xFF9E9E9E);
      default:
        return Color(0xFF2196F3);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Icons.check_circle;
      case 'PENDING':
        return Icons.access_time;
      case 'REJECTED':
        return Icons.cancel;
      case 'CANCELLED':
        return Icons.block;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var filteredAppointments = _appointments.where((apt) {
      if (_selectedFilter == 'ALL') return true;
      return apt['status'] == _selectedFilter;
    }).toList();

    // Sort by date (upcoming first)
    filteredAppointments.sort((a, b) {
      final dateA = DateTime.tryParse(a['requestedTime']?.toString() ?? '');
      final dateB = DateTime.tryParse(b['requestedTime']?.toString() ?? '');
      if (dateA == null || dateB == null) return 0;
      return dateA.compareTo(dateB);
    });

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Appointments',
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: Colors.grey[800]),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              _buildFilterMenuItem('ALL', 'All', Icons.all_inclusive),
              _buildFilterMenuItem('PENDING', 'Pending', Icons.access_time),
              _buildFilterMenuItem(
                'CONFIRMED',
                'Confirmed',
                Icons.check_circle,
              ),
              _buildFilterMenuItem('CANCELLED', 'Cancelled', Icons.block),
              _buildFilterMenuItem('REJECTED', 'Rejected', Icons.cancel),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(_errorMessage!),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAppointments,
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadAppointments,
              child: filteredAppointments.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 100),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No appointments found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];
                        return _buildAppointmentCard(appointment);
                      },
                    ),
            ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2196F3).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Book appointment feature coming soon')),
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.schedule,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.schedule) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }

  PopupMenuItem<String> _buildFilterMenuItem(
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: _selectedFilter == value ? theme.primaryColor : Colors.grey,
          ),
          SizedBox(width: 12),
          Text(label),
          if (_selectedFilter == value) ...[
            Spacer(),
            Icon(Icons.check, color: theme.primaryColor),
          ],
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final status = appointment['status']?.toString() ?? 'UNKNOWN';
    final statusColor = _getStatusColor(status);
    final doctor = appointment['doctor'];
    final doctorName = doctor != null && doctor['healthProfile'] != null
        ? '${doctor['healthProfile']['firstName'] ?? ''} ${doctor['healthProfile']['lastName'] ?? ''}'
              .trim()
        : 'Doctor';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAppointmentDetails(appointment),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_hospital,
                        color: Color(0xFF2196F3),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. $doctorName',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            appointment['appointmentType'] ?? 'Consultation',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(status),
                            size: 14,
                            color: statusColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatDate(appointment['requestedTime']),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (appointment['duration'] != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${appointment['duration']} min',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (appointment['reasonForVisit'] != null &&
                    appointment['reasonForVisit'].toString().isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    appointment['reasonForVisit'],
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    final status = appointment['status']?.toString() ?? 'UNKNOWN';
    final statusColor = _getStatusColor(status);
    final doctor = appointment['doctor'];
    final doctorName = doctor != null && doctor['healthProfile'] != null
        ? 'Dr. ${doctor['healthProfile']['firstName'] ?? ''} ${doctor['healthProfile']['lastName'] ?? ''}'
              .trim()
        : 'Doctor';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          doctorName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getStatusIcon(status),
                              size: 16,
                              color: statusColor,
                            ),
                            SizedBox(width: 6),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildDetailRow(
                    'Appointment Type',
                    appointment['appointmentType'] ?? 'Consultation',
                  ),
                  _buildDetailRow(
                    'Date & Time',
                    _formatDate(appointment['requestedTime']),
                  ),
                  _buildDetailRow(
                    'Duration',
                    '${appointment['duration'] ?? 30} minutes',
                  ),
                  if (appointment['reasonForVisit'] != null)
                    _buildDetailRow(
                      'Reason for Visit',
                      appointment['reasonForVisit'],
                    ),
                  if (appointment['patientNotes'] != null)
                    _buildDetailRow('Your Notes', appointment['patientNotes']),
                  if (appointment['doctorNotes'] != null)
                    _buildDetailRow('Doctor Notes', appointment['doctorNotes']),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Close'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
