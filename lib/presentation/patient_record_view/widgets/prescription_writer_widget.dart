import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Prescription writer widget for healthcare providers
class PrescriptionWriterWidget extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final VoidCallback onClose;


  const PrescriptionWriterWidget({
    super.key,
    required this.patientData,
    required this.onClose,
  });


  @override
  State<PrescriptionWriterWidget> createState() =>
      _PrescriptionWriterWidgetState();
}


class _PrescriptionWriterWidgetState extends State<PrescriptionWriterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _refillsController = TextEditingController();
  final _notesController = TextEditingController();
  final _pharmacyController = TextEditingController();


  // Mock drug database
  final List<Map<String, dynamic>> _drugDatabase = [
    {
      "name": "Metformin",
      "commonDosages": ["500mg", "850mg", "1000mg"],
      "defaultFrequency": "Twice daily with meals",
      "interactions": ["Alcohol", "Iodinated contrast"],
      "warnings": "Monitor kidney function regularly"
    },
    {
      "name": "Lisinopril",
      "commonDosages": ["5mg", "10mg", "20mg", "40mg"],
      "defaultFrequency": "Once daily",
      "interactions": ["NSAIDs", "Potassium supplements"],
      "warnings": "May cause dry cough"
    },
    {
      "name": "Atorvastatin",
      "commonDosages": ["10mg", "20mg", "40mg", "80mg"],
      "defaultFrequency": "Once daily at bedtime",
      "interactions": ["Grapefruit juice", "Gemfibrozil"],
      "warnings": "Monitor liver enzymes"
    },
    {
      "name": "Amlodipine",
      "commonDosages": ["2.5mg", "5mg", "10mg"],
      "defaultFrequency": "Once daily",
      "interactions": ["Simvastatin"],
      "warnings": "May cause ankle swelling"
    },
    {
      "name": "Omeprazole",
      "commonDosages": ["20mg", "40mg"],
      "defaultFrequency": "Once daily before breakfast",
      "interactions": ["Clopidogrel"],
      "warnings": "Long-term use may affect bone density"
    },
  ];


  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? _selectedDrug;
  bool _showInteractionWarning = false;
  List<String> _detectedInteractions = [];


  @override
  void dispose() {
    _medicationController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _quantityController.dispose();
    _refillsController.dispose();
    _notesController.dispose();
    _pharmacyController.dispose();
    super.dispose();
  }


  void _searchDrug(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }


    setState(() {
      _searchResults = _drugDatabase
          .where((drug) => (drug['name'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }


  void _selectDrug(Map<String, dynamic> drug) {
    setState(() {
      _selectedDrug = drug;
      _medicationController.text = drug['name'] as String;
      _frequencyController.text = drug['defaultFrequency'] as String;
      _searchResults = [];
      _checkInteractions(drug);
    });
  }


  void _checkInteractions(Map<String, dynamic> drug) {
    final currentMedications = widget.patientData['currentMedications'] as List;
    final interactions = drug['interactions'] as List;
    final detectedInteractions = <String>[];


    for (final med in currentMedications) {
      final medication = med as Map<String, dynamic>;
      final medName = medication['name'] as String;
      if (interactions.any((interaction) => medName
          .toLowerCase()
          .contains((interaction as String).toLowerCase()))) {
        detectedInteractions.add(medName);
      }
    }


    setState(() {
      _showInteractionWarning = detectedInteractions.isNotEmpty;
      _detectedInteractions = detectedInteractions;
    });
  }


  void _submitPrescription() {
    if (_formKey.currentState!.validate()) {
      final theme = Theme.of(context);
      widget.onClose();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Prescription submitted successfully',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 90.w,
          constraints: BoxConstraints(maxHeight: 85.h),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit_note',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write Prescription',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'For ${widget.patientData['name']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),


              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drug Search
                        Text(
                          'Medication',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _medicationController,
                          decoration: InputDecoration(
                            hintText: 'Search medication...',
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: _medicationController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _medicationController.clear();
                                        _selectedDrug = null;
                                        _searchResults = [];
                                        _showInteractionWarning = false;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: _searchDrug,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter medication name';
                            }
                            return null;
                          },
                        ),


                        // Search Results
                        if (_searchResults.isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          Container(
                            constraints: BoxConstraints(maxHeight: 20.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final drug = _searchResults[index];
                                return ListTile(
                                  title: Text(drug['name'] as String),
                                  subtitle: Text(
                                    'Common dosages: ${(drug['commonDosages'] as List).join(', ')}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  onTap: () => _selectDrug(drug),
                                );
                              },
                            ),
                          ),
                        ],


                        // Interaction Warning
                        if (_showInteractionWarning) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.error
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomIconWidget(
                                  iconName: 'warning',
                                  color: theme.colorScheme.error,
                                  size: 24,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Drug Interaction Warning',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        'May interact with: ${_detectedInteractions.join(', ')}',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],


                        // Dosage Recommendations
                        if (_selectedDrug != null) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'info',
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Dosage Recommendations',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Wrap(
                                  spacing: 2.w,
                                  runSpacing: 1.h,
                                  children:
                                      (_selectedDrug!['commonDosages'] as List)
                                          .map((dosage) {
                                    return ActionChip(
                                      label: Text(dosage as String),
                                      onPressed: () {
                                        setState(() {
                                          _dosageController.text =
                                              dosage;
                                        });
                                      },
                                      backgroundColor:
                                          theme.colorScheme.surface,
                                      side: BorderSide(
                                        color: theme.colorScheme.primary,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  _selectedDrug!['warnings'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],


                        SizedBox(height: 2.h),


                        // Dosage
                        Text(
                          'Dosage',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _dosageController,
                          decoration: InputDecoration(
                            hintText: 'e.g., 500mg',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter dosage';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Frequency
                        Text(
                          'Frequency',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _frequencyController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Twice daily with meals',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter frequency';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Duration and Quantity
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  TextFormField(
                                    controller: _durationController,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., 30 days',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  TextFormField(
                                    controller: _quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., 60',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),


                        // Refills
                        Text(
                          'Refills',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _refillsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Number of refills',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of refills';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Pharmacy
                        Text(
                          'Pharmacy',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _pharmacyController,
                          decoration: InputDecoration(
                            hintText: 'Select pharmacy',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select pharmacy';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),


                        // Notes
                        Text(
                          'Special Instructions',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Additional instructions for patient...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              // Actions
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onClose,
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitPrescription,
                        child: Text('Submit Prescription'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
