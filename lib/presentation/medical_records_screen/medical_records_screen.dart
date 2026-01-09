import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../services/health_service.dart';
import '../../services/auth_service.dart';
import 'widgets/record_card.dart';
import 'widgets/filter_modal.dart';
import 'widgets/empty_state_widget.dart';
import 'package:intl/intl.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final _healthService = HealthService();
  final _authService = AuthService();

  String _searchQuery = '';
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'all'; // all, encounters, observations

  @override
  void initState() {
    super.initState();
    _loadCachedDataSync();
    _loadRecords();
  }

  // Load cached data synchronously first to avoid loading state
  void _loadCachedDataSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load encounters from cache
      final cachedEncounters = prefs.getString('cached_encounters');
      if (cachedEncounters != null && mounted) {
        final encountersData = jsonDecode(cachedEncounters);

        // Process cached encounters with same logic as _loadRecords
        List<Map<String, dynamic>> allRecords = [];

        if (encountersData['encounters'] != null) {
          final encounters = encountersData['encounters'] as List;

          // Take only last 5 Medical Visits (encounters) with all their observations
          final recentEncounters = encounters.take(5).toList();

          for (var encounter in recentEncounters) {
            // Parse JSON notes field to get enhanced data
            Map<String, dynamic> enhancedData = {};
            if (encounter['notes'] != null) {
              try {
                enhancedData = jsonDecode(encounter['notes']);
              } catch (e) {
                // If notes is not JSON, keep it as plain string
              }
            }

            // Add main encounter card
            allRecords.add({
              'id': encounter['id'],
              'title': _getEncounterTitle(encounter),
              'doctor': 'Provider ID: ${encounter['providerId']}',
              'date': encounter['startTime'] ?? encounter['createdAt'],
              'type': 'Medical Visit',
              'category': 'encounter',
              'hospital': encounter['reason'] ?? 'Healthcare Facility',
              'notes': enhancedData['originalNotes'] ?? encounter['notes'],
              'raw': encounter,
              'enhancedData': enhancedData,
            });

            // Extract individual observations as separate cards
            if (encounter['observations'] != null &&
                encounter['observations'] is List) {
              final observations = encounter['observations'] as List;
              for (var obs in observations) {
                final code = obs['code']?.toString().toLowerCase() ?? '';

                // Add vitals card
                if (code == 'vitals') {
                  allRecords.add({
                    'id': '${encounter['id']}_vitals',
                    'title': 'Vital Signs',
                    'doctor': 'Provider ID: ${encounter['providerId']}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                    'type': 'Vitals',
                    'category': 'vitals',
                    'hospital': encounter['reason'] ?? 'Healthcare Facility',
                    'raw': encounter,
                    'observationData': obs,
                  });
                }
                // Add prescription card
                else if (code == 'prescription') {
                  allRecords.add({
                    'id': '${encounter['id']}_prescription',
                    'title': 'Prescription',
                    'doctor': 'Provider ID: ${encounter['providerId']}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                    'type': 'Prescription',
                    'category': 'prescription',
                    'hospital': encounter['reason'] ?? 'Healthcare Facility',
                    'raw': encounter,
                    'observationData': obs,
                  });
                }
                // Add lab test cards
                else if (code.startsWith('lab_')) {
                  allRecords.add({
                    'id': '${encounter['id']}_${code}',
                    'title': code.replaceAll('_', ' ').toUpperCase(),
                    'doctor': 'Provider ID: ${encounter['providerId']}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                    'type': 'Lab Result',
                    'category': 'lab_test',
                    'hospital': encounter['reason'] ?? 'Healthcare Facility',
                    'raw': encounter,
                    'observationData': obs,
                  });
                }
                // Add diagnosis card
                else if (code == 'diagnosis' || code == 'assessment') {
                  allRecords.add({
                    'id': '${encounter['id']}_diagnosis',
                    'title': 'Diagnosis',
                    'doctor': 'Provider ID: ${encounter['providerId']}',
                    'date': obs['recordedAt'] ?? encounter['startTime'],
                    'type': 'Diagnosis',
                    'category': 'diagnosis',
                    'hospital': encounter['reason'] ?? 'Healthcare Facility',
                    'raw': encounter,
                    'observationData': obs,
                  });
                }
              }
            }
          }

          // Sort by date (most recent first)
          allRecords.sort((a, b) {
            final dateA = DateTime.tryParse(a['date']?.toString() ?? '');
            final dateB = DateTime.tryParse(b['date']?.toString() ?? '');
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          });

          setState(() {
            _records = allRecords;
          });
        }
      }
    } catch (e) {
      print('Error loading cached records: $e');
    }
  }

  Future<void> _loadRecords() async {
    try {
      // Fetch encounters and observations (will return cached data instantly)
      final results = await Future.wait([
        _healthService.getEncounters(),
        _healthService.getObservations(),
      ]);

      final encountersResult = results[0];
      final observationsResult = results[1];

      List<Map<String, dynamic>> allRecords = [];

      // Add encounters and extract individual observation cards
      if (encountersResult['encounters'] != null) {
        final encounters = encountersResult['encounters'] as List;
        for (var encounter in encounters) {
          // Parse JSON notes field to get enhanced data
          Map<String, dynamic> enhancedData = {};
          if (encounter['notes'] != null) {
            try {
              enhancedData = jsonDecode(encounter['notes']);
            } catch (e) {
              // If notes is not JSON, keep it as plain string
            }
          }

          // Add main encounter card
          allRecords.add({
            'id': encounter['id'],
            'title': _getEncounterTitle(encounter),
            'doctor': 'Provider ID: ${encounter['providerId']}',
            'date': encounter['startTime'] ?? encounter['createdAt'],
            'type': 'Medical Visit',
            'category': 'encounter',
            'hospital': encounter['reason'] ?? 'Healthcare Facility',
            'notes': enhancedData['originalNotes'] ?? encounter['notes'],
            'raw': encounter,
            'enhancedData': enhancedData,
          });

          // Extract individual observations as separate cards
          if (encounter['observations'] != null &&
              encounter['observations'] is List) {
            final observations = encounter['observations'] as List;
            for (var obs in observations) {
              final code = obs['code']?.toString().toLowerCase() ?? '';

              // Add vitals card
              if (code == 'vitals') {
                allRecords.add({
                  'id': '${encounter['id']}_vitals',
                  'title': 'Vital Signs',
                  'doctor': 'Provider ID: ${encounter['providerId']}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'type': 'Vitals',
                  'category': 'vitals',
                  'hospital': encounter['reason'] ?? 'Healthcare Facility',
                  'raw': encounter,
                  'observationData': obs,
                });
              }
              // Add prescription card
              else if (code == 'prescription') {
                allRecords.add({
                  'id': '${encounter['id']}_prescription',
                  'title': 'Prescription',
                  'doctor': 'Provider ID: ${encounter['providerId']}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'type': 'Prescription',
                  'category': 'prescription',
                  'hospital': encounter['reason'] ?? 'Healthcare Facility',
                  'raw': encounter,
                  'observationData': obs,
                });
              }
              // Add lab test cards
              else if (code.startsWith('lab_')) {
                allRecords.add({
                  'id': '${encounter['id']}_${code}',
                  'title': code.replaceAll('_', ' ').toUpperCase(),
                  'doctor': 'Provider ID: ${encounter['providerId']}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'type': 'Lab Result',
                  'category': 'lab_test',
                  'hospital': encounter['reason'] ?? 'Healthcare Facility',
                  'raw': encounter,
                  'observationData': obs,
                });
              }
              // Add diagnosis card
              else if (code == 'diagnosis' || code == 'assessment') {
                allRecords.add({
                  'id': '${encounter['id']}_diagnosis',
                  'title': 'Diagnosis',
                  'doctor': 'Provider ID: ${encounter['providerId']}',
                  'date': obs['recordedAt'] ?? encounter['startTime'],
                  'type': 'Diagnosis',
                  'category': 'diagnosis',
                  'hospital': encounter['reason'] ?? 'Healthcare Facility',
                  'raw': encounter,
                  'observationData': obs,
                });
              }
            }
          }
        }
      }

      // Sort by date (most recent first)
      allRecords.sort((a, b) {
        final dateA = DateTime.tryParse(a['date']?.toString() ?? '');
        final dateB = DateTime.tryParse(b['date']?.toString() ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });

      if (mounted) {
        setState(() {
          _records = allRecords;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load records: $e';
        });
      }
    }
  }

  String _getEncounterTitle(Map<String, dynamic> encounter) {
    final reason = encounter['reason']?.toString();

    if (reason != null && reason.isNotEmpty) {
      // Clean up the reason - remove prefix if it exists
      String cleanedReason = reason;

      // Remove common prefixes like "follow_up - ", "consultation - ", etc.
      if (reason.contains(' - ')) {
        final parts = reason.split(' - ');
        if (parts.length > 1) {
          // Take everything after the first " - "
          cleanedReason = parts.sublist(1).join(' - ');
        }
      }

      // Capitalize first letter
      if (cleanedReason.isNotEmpty) {
        cleanedReason =
            cleanedReason[0].toUpperCase() + cleanedReason.substring(1);
      }

      return cleanedReason;
    }

    // Fallback to visit type
    final type = encounter['type']?.toString() ?? 'Medical Visit';
    return type;
  }

  String _getObservationTitle(Map<String, dynamic> observation) {
    final code = observation['code']?.toString() ?? 'Test';
    return code;
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Apply filters
    var filteredRecords = _records.where((record) {
      // Filter by category
      if (_selectedFilter != 'all') {
        return record['category'] == _selectedFilter;
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return record['title'].toString().toLowerCase().contains(query) ||
            record['doctor'].toString().toLowerCase().contains(query) ||
            record['type'].toString().toLowerCase().contains(query) ||
            record['hospital'].toString().toLowerCase().contains(query);
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'Medical Records',
        variant: CustomAppBarVariant.search,
        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive, size: 20),
                    SizedBox(width: 12),
                    Text('All Records'),
                    if (_selectedFilter == 'all') ...[
                      Spacer(),
                      Icon(Icons.check, color: theme.primaryColor),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'encounter',
                child: Row(
                  children: [
                    Icon(Icons.local_hospital, size: 20),
                    SizedBox(width: 12),
                    Text('Medical Visits'),
                    if (_selectedFilter == 'encounter') ...[
                      Spacer(),
                      Icon(Icons.check, color: theme.primaryColor),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'observation',
                child: Row(
                  children: [
                    Icon(Icons.science, size: 20),
                    SizedBox(width: 12),
                    Text('Lab Results'),
                    if (_selectedFilter == 'observation') ...[
                      Spacer(),
                      Icon(Icons.check, color: theme.primaryColor),
                    ],
                  ],
                ),
              ),
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
                  ElevatedButton(onPressed: _loadRecords, child: Text('Retry')),
                ],
              ),
            )
          : Column(
              children: [
                // Section Filter Chips
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSectionChip('All', 'all', Icons.all_inclusive),
                      SizedBox(width: 8),
                      _buildSectionChip(
                        'Medical Visits',
                        'encounter',
                        Icons.local_hospital,
                      ),
                      SizedBox(width: 8),
                      _buildSectionChip('Vitals', 'vitals', Icons.favorite),
                      SizedBox(width: 8),
                      _buildSectionChip(
                        'Diagnosis',
                        'diagnosis',
                        Icons.medical_information,
                      ),
                      SizedBox(width: 8),
                      _buildSectionChip(
                        'Prescriptions',
                        'prescription',
                        Icons.medication,
                      ),
                      SizedBox(width: 8),
                      _buildSectionChip('Lab Tests', 'lab_test', Icons.biotech),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadRecords,
                    child: filteredRecords.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(height: 100),
                              EmptyStateWidget(
                                message: _searchQuery.isEmpty
                                    ? 'No medical records found'
                                    : 'No records match your search',
                                icon: Icons.folder_off,
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredRecords.length,
                            itemBuilder: (context, index) {
                              final record = filteredRecords[index];
                              return RecordCard(
                                title: record['title'],
                                doctor: record['doctor'],
                                date: _formatDate(record['date']),
                                type: record['type'],
                                hospital: record['hospital'],
                                onTap: () {
                                  _showRecordDetails(context, record);
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
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
                SnackBar(content: Text('Add record feature coming soon')),
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
          SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
    );
  }

  void _showRecordDetails(BuildContext context, Map<String, dynamic> record) {
    final theme = Theme.of(context);

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
                  Text(
                    record['title'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        _formatDate(record['date']),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: record['category'] == 'encounter'
                              ? Colors.blue.withValues(alpha: 0.1)
                              : Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          record['type'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: record['category'] == 'encounter'
                                ? Colors.blue[700]
                                : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildDetailRow('Doctor/Provider', record['doctor']),
                  _buildDetailRow('Facility', record['hospital']),
                  if (record['notes'] != null &&
                      record['notes'].toString().isNotEmpty)
                    _buildDetailRow('Notes', record['notes']),

                  // Show specific observation data based on category
                  if (record['category'] == 'vitals' &&
                      record['observationData'] != null) ...[
                    ..._buildVitalsData(record['observationData']),
                  ] else if (record['category'] == 'prescription' &&
                      record['observationData'] != null) ...[
                    ..._buildPrescriptionData(record['observationData']),
                  ] else if (record['category'] == 'lab_test' &&
                      record['observationData'] != null) ...[
                    ..._buildLabTestData(record['observationData']),
                  ] else if (record['category'] == 'diagnosis' &&
                      record['observationData'] != null) ...[
                    ..._buildDiagnosisData(record['observationData']),
                  ]
                  // Show encounter details if it's a full encounter
                  else if (record['category'] == 'encounter') ...[
                    ..._buildEncounterDetails(record),
                  ],

                  if (record['value'] != null &&
                      record['category'] == 'observation') ...[
                    SizedBox(height: 16),
                    Text(
                      'Test Result',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${record['value']}${record['unit'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  // Section Navigation
                  _buildSectionNavigation(),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildVitalsData(Map<String, dynamic> obs) {
    if (obs['value'] == null) return [];

    Map<String, dynamic> vitals;
    if (obs['value'] is String) {
      try {
        vitals = jsonDecode(obs['value']);
      } catch (e) {
        return [];
      }
    } else if (obs['value'] is Map) {
      vitals = Map<String, dynamic>.from(obs['value']);
    } else {
      return [];
    }

    return _buildVitalSigns(vitals);
  }

  List<Widget> _buildPrescriptionData(Map<String, dynamic> obs) {
    if (obs['value'] == null) return [];

    Map<String, dynamic> prescData;
    if (obs['value'] is String) {
      try {
        prescData = jsonDecode(obs['value']);
      } catch (e) {
        return [];
      }
    } else if (obs['value'] is Map) {
      prescData = Map<String, dynamic>.from(obs['value']);
    } else {
      return [];
    }

    List<Map<String, dynamic>> prescriptionsList = [];

    // Check if medications array exists
    if (prescData['medications'] != null && prescData['medications'] is List) {
      final medications = prescData['medications'] as List;
      for (var med in medications) {
        if (med is Map) {
          prescriptionsList.add({
            'medicationName': med['name'],
            'dosage': med['dosage'],
            'frequency': med['frequency'],
            'duration': med['duration'],
            'instructions': med['instructions'],
          });
        }
      }
    } else {
      prescriptionsList.add(prescData);
    }

    return _buildPrescriptions(prescriptionsList);
  }

  List<Widget> _buildLabTestData(Map<String, dynamic> obs) {
    if (obs['value'] == null) return [];

    return [
      SizedBox(height: 16),
      Row(
        children: [
          Icon(Icons.biotech, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Text(
            'Lab Test Result',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, size: 16, color: Colors.blue[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    obs['code']
                            ?.toString()
                            .replaceAll('_', ' ')
                            .toUpperCase() ??
                        'Lab Test',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (obs['value'] is Map) ...[
              ...((obs['value'] as Map).entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (obs['unit'] != null) ...[
                        SizedBox(width: 4),
                        Text(
                          obs['unit'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )),
            ] else ...[
              Text(
                obs['value'].toString(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              if (obs['unit'] != null) ...[
                SizedBox(height: 4),
                Text(
                  'Unit: ${obs['unit']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildDiagnosisData(Map<String, dynamic> obs) {
    if (obs['value'] == null) return [];

    List<String> diagnosisList = [];
    if (obs['value'] is String) {
      diagnosisList.add(obs['value']);
    } else if (obs['value'] is List) {
      diagnosisList = (obs['value'] as List).map((e) => e.toString()).toList();
    }

    return _buildDiagnosis(diagnosisList);
  }

  Widget _buildSectionNavigation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Navigation',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildNavChip('Vital Signs', Icons.favorite, Colors.red),
            _buildNavChip(
              'Diagnosis',
              Icons.medical_information,
              Colors.orange,
            ),
            _buildNavChip('Prescriptions', Icons.medication, Colors.green),
            _buildNavChip('Lab Tests', Icons.biotech, Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildNavChip(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEncounterDetails(Map<String, dynamic> record) {
    List<Widget> widgets = [];
    final raw = record['raw'];

    if (raw == null) return widgets;

    // Extract vital signs, diagnosis, prescriptions, lab tests from observations
    Map<String, dynamic> vitalSigns = {};
    List<String> diagnosisList = [];
    List<Map<String, dynamic>> prescriptionsList = [];
    List<Map<String, dynamic>> labTestsList = [];

    // Parse observations if available
    if (raw['observations'] != null && raw['observations'] is List) {
      final observations = raw['observations'] as List;

      print('🔍 DEBUG: Encounter ID: ${raw['id']}');
      print('🔍 DEBUG: Total observations: ${observations.length}');
      for (var obs in observations) {
        print(
          '🔍 DEBUG: - Code: ${obs['code']}, Value keys: ${obs['value'] is Map ? (obs['value'] as Map).keys.toList() : 'not a map'}',
        );
      }

      for (var obs in observations) {
        final code = obs['code']?.toString().toUpperCase();

        // Check for vitals
        if (code == 'VITALS' || code == 'VITAL_SIGNS') {
          if (obs['value'] != null) {
            if (obs['value'] is Map) {
              vitalSigns = Map<String, dynamic>.from(obs['value']);
            } else if (obs['value'] is String) {
              try {
                vitalSigns = jsonDecode(obs['value']);
              } catch (e) {
                // Skip malformed data
              }
            }
          }
        }
        // Check for diagnosis
        else if (code == 'DIAGNOSIS') {
          if (obs['value'] != null) {
            if (obs['value'] is String) {
              diagnosisList.add(obs['value']);
            } else if (obs['value'] is Map) {
              if (obs['value']['diagnosis'] != null) {
                diagnosisList.add(obs['value']['diagnosis'].toString());
              } else if (obs['value']['name'] != null) {
                diagnosisList.add(obs['value']['name'].toString());
              } else {
                diagnosisList.add(obs['value'].toString());
              }
            }
          }
        }
        // Check for prescriptions
        else if (code == 'PRESCRIPTION' ||
            code == 'MEDICATION' ||
            code?.toLowerCase() == 'prescription') {
          print('Found prescription observation: ${obs['id']}');
          print('Value type: ${obs['value'].runtimeType}');
          print('Value content: ${obs['value']}');

          if (obs['value'] != null) {
            try {
              Map<String, dynamic> prescData;

              if (obs['value'] is String) {
                prescData = jsonDecode(obs['value']);
              } else if (obs['value'] is Map) {
                prescData = Map<String, dynamic>.from(obs['value']);
              } else {
                print('Unknown prescription value type');
                continue;
              }

              print('Parsed prescription data: $prescData');

              // Check if medications array exists
              if (prescData['medications'] != null &&
                  prescData['medications'] is List) {
                final medications = prescData['medications'] as List;
                for (var med in medications) {
                  if (med is Map) {
                    prescriptionsList.add({
                      'medicationName': med['name'],
                      'dosage': med['dosage'],
                      'frequency': med['frequency'],
                      'duration': med['duration'],
                      'instructions': med['instructions'],
                    });
                  }
                }
              } else {
                // Fallback: treat as single prescription
                prescriptionsList.add(prescData);
              }
            } catch (e) {
              print('Error parsing prescription: $e');
              continue;
            }
          }
        }
        // Check for lab tests
        else if (code == 'LAB_TEST' || code == 'LABORATORY' || code == 'LAB') {
          if (obs['value'] != null) {
            Map<String, dynamic> labData;
            if (obs['value'] is String) {
              try {
                labData = jsonDecode(obs['value']);
                labTestsList.add(labData);
              } catch (e) {
                continue;
              }
            } else if (obs['value'] is Map) {
              labData = Map<String, dynamic>.from(obs['value']);
              labTestsList.add(labData);
            }
          }
        }
      }
    }

    // Show vital signs if available
    if (vitalSigns.isNotEmpty) {
      widgets.addAll(_buildVitalSigns(vitalSigns));
    }

    // Show diagnosis if available
    if (diagnosisList.isNotEmpty) {
      widgets.addAll(_buildDiagnosis(diagnosisList));
    }

    // Show prescriptions if available
    if (prescriptionsList.isNotEmpty) {
      widgets.addAll(_buildPrescriptions(prescriptionsList));
    }

    // Show lab tests if available
    if (labTestsList.isNotEmpty) {
      widgets.addAll(_buildLabTests(labTestsList));
    }

    return widgets;
  }

  List<Widget> _buildVitalSigns(Map<String, dynamic> vitalSigns) {
    return [
      SizedBox(height: 16),
      Row(
        children: [
          Icon(Icons.favorite, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Text(
            'Vital Signs',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            if (vitalSigns['bloodPressure'] != null)
              _buildVitalRow(
                'Blood Pressure',
                vitalSigns['bloodPressure'],
                Icons.monitor_heart,
              ),
            if (vitalSigns['heartRate'] != null)
              _buildVitalRow(
                'Heart Rate',
                '${vitalSigns['heartRate']} bpm',
                Icons.favorite,
              ),
            if (vitalSigns['temperature'] != null)
              _buildVitalRow(
                'Temperature',
                '${vitalSigns['temperature']}°F',
                Icons.thermostat,
              ),
            if (vitalSigns['weight'] != null)
              _buildVitalRow(
                'Weight',
                '${vitalSigns['weight']} kg',
                Icons.monitor_weight,
              ),
            if (vitalSigns['height'] != null)
              _buildVitalRow(
                'Height',
                '${vitalSigns['height']} cm',
                Icons.height,
              ),
            if (vitalSigns['oxygenSaturation'] != null)
              _buildVitalRow(
                'O2 Saturation',
                '${vitalSigns['oxygenSaturation']}%',
                Icons.air,
              ),
          ],
        ),
      ),
    ];
  }

  Widget _buildVitalRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.red[700]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDiagnosis(List<dynamic> diagnosis) {
    return [
      SizedBox(height: 16),
      Row(
        children: [
          Icon(Icons.medical_information, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Text(
            'Diagnosis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 12),
      ...diagnosis
          .map(
            (diag) => Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.blue[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      diag.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ];
  }

  List<Widget> _buildPrescriptions(List<dynamic> prescriptions) {
    return [
      SizedBox(height: 16),
      Row(
        children: [
          Icon(Icons.medication, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(
            'Prescriptions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 12),
      ...prescriptions.map((prescription) {
        final presc = prescription as Map<String, dynamic>;
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medication, size: 16, color: Colors.green[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      presc['medicationName'] ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              if (presc['dosage'] != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Dosage: ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      presc['dosage'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
              if (presc['frequency'] != null) ...[
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 6),
                    Text(
                      'Frequency: ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      presc['frequency'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
              if (presc['duration'] != null) ...[
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Duration: ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      presc['duration'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
              if (presc['instructions'] != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.green[700],
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          presc['instructions'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    ];
  }

  List<Widget> _buildLabTests(List<dynamic> labTests) {
    return [
      SizedBox(height: 16),
      Row(
        children: [
          Icon(Icons.science, color: Colors.purple, size: 20),
          SizedBox(width: 8),
          Text(
            'Lab Tests & Results',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 12),
      ...labTests.map((test) {
        final labTest = test as Map<String, dynamic>;
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.science, size: 16, color: Colors.purple[700]),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labTest['testName'] ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (labTest['result'] != null) ...[
                      SizedBox(height: 4),
                      Text(
                        'Result: ${labTest['result']}${labTest['unit'] ?? ''}',
                        style: TextStyle(
                          color: Colors.purple[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ];
  }
}
