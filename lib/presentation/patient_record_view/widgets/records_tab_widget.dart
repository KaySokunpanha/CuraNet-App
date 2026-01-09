import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Records tab widget displaying patient medical records
class RecordsTabWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;


  const RecordsTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final records = patientData['medicalHistory'] as List;


    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index] as Map<String, dynamic>;
        return _buildRecordCard(context, theme, record);
      },
    );
  }


  Widget _buildRecordCard(
      BuildContext context, ThemeData theme, Map<String, dynamic> record) {
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
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'description',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['condition'] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Diagnosed on ${record['date']}',
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
                    color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    record['status'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),


            // Details
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                      theme, 'Diagnosed By', record['diagnosedBy'] as String),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      theme, 'Treatment', record['treatment'] as String),
                  if (record['notes'] != null) ...[
                    SizedBox(height: 1.h),
                    Divider(height: 2.h),
                    Text(
                      'Notes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      record['notes'] as String,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),


            // Actions
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening full report...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'visibility',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  label: Text('View Report'),
                ),
              ],
            ),
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
