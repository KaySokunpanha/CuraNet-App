import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Prescriptions tab widget displaying patient prescription history
class PrescriptionsTabWidget extends StatefulWidget {
  final Map<String, dynamic> patientData;


  const PrescriptionsTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  State<PrescriptionsTabWidget> createState() => _PrescriptionsTabWidgetState();
}


class _PrescriptionsTabWidgetState extends State<PrescriptionsTabWidget> {
  String _selectedStatus = 'All';
  final List<String> _statusTypes = ['All', 'Active', 'Completed'];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prescriptions = widget.patientData['prescriptionHistory'] as List;
    final filteredPrescriptions = _selectedStatus == 'All'
        ? prescriptions
        : prescriptions.where((prescription) {
            final prescriptionMap = prescription as Map<String, dynamic>;
            return prescriptionMap['status'] == _selectedStatus;
          }).toList();


    return Column(
      children: [
        // Status Filter
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: _statusTypes.map((status) {
              final isSelected = _selectedStatus == status;
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  backgroundColor: theme.colorScheme.surface,
                  selectedColor:
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                ),
              );
            }).toList(),
          ),
        ),


        // Prescriptions List
        Expanded(
          child: filteredPrescriptions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'medication',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No prescriptions found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: filteredPrescriptions.length,
                  itemBuilder: (context, index) {
                    final prescription =
                        filteredPrescriptions[index] as Map<String, dynamic>;
                    return _buildPrescriptionCard(theme, prescription);
                  },
                ),
        ),
      ],
    );
  }


  Widget _buildPrescriptionCard(
      ThemeData theme, Map<String, dynamic> prescription) {
    final isActive = prescription['status'] == 'Active';


    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'medication',
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescription['medication'] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        prescription['dosage'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    prescription['status'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),


            // Prescription Details
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                      theme, 'Frequency', prescription['frequency'] as String),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Duration', prescription['duration'] as String),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Quantity', '${prescription['quantity']} tablets'),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Refills', '${prescription['refills']} remaining'),
                ],
              ),
            ),
            SizedBox(height: 2.h),


            // Provider Info
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Prescribed by ${prescription['prescribedBy']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  prescription['date'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_pharmacy',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    prescription['pharmacy'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),


            // Notes
            if (prescription['notes'] != null) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: theme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        prescription['notes'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],


            // Actions
            if (isActive) ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Renewing prescription...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Renew'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Modifying prescription...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Modify'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
