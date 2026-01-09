import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Overview tab widget displaying patient summary information
class OverviewTabWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;


  const OverviewTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Critical Alerts
          _buildCriticalAlerts(theme),
          SizedBox(height: 3.h),


          // Demographics
          _buildDemographicsCard(theme),
          SizedBox(height: 2.h),


          // Insurance
          _buildInsuranceCard(theme),
          SizedBox(height: 2.h),


          // Current Medications
          _buildCurrentMedicationsCard(theme),
          SizedBox(height: 2.h),


          // Recent Activity Timeline
          _buildRecentActivityTimeline(theme),
        ],
      ),
    );
  }


  Widget _buildCriticalAlerts(ThemeData theme) {
    final allergies = patientData['allergies'] as List;
    final conditions = patientData['conditions'] as List;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Critical Alerts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),


        // Allergies
        ...allergies.map((allergy) {
          final allergyMap = allergy as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ALLERGY: ',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            allergyMap['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Severity: ${allergyMap['severity']} | Reaction: ${allergyMap['reaction']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),


        // Conditions
        ...conditions.map((condition) {
          final conditionMap = condition as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'medical_information',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conditionMap['name'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Diagnosed: ${conditionMap['diagnosedDate']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }


  Widget _buildDemographicsCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demographics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
                theme, 'phone', 'Phone', patientData['phone'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(
                theme, 'email', 'Email', patientData['email'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(theme, 'location_on', 'Address',
                patientData['address'] as String),
          ],
        ),
      ),
    );
  }


  Widget _buildInsuranceCard(ThemeData theme) {
    final insurance = patientData['insurance'] as Map<String, dynamic>;


    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
                theme, 'business', 'Provider', insurance['provider'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(theme, 'badge', 'Policy Number',
                insurance['policyNumber'] as String),
            SizedBox(height: 1.h),
            _buildInfoRow(theme, 'calendar_today', 'Valid Until',
                insurance['validUntil'] as String),
          ],
        ),
      ),
    );
  }


  Widget _buildCurrentMedicationsCard(ThemeData theme) {
    final medications = patientData['currentMedications'] as List;


    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Medications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...medications.map((med) {
              final medication = med as Map<String, dynamic>;
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'medication',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            medication['name'] as String,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '${medication['dosage']} - ${medication['frequency']}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Prescribed by: ${medication['prescribedBy']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Since: ${medication['startDate']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _buildRecentActivityTimeline(ThemeData theme) {
    final visits = patientData['recentVisits'] as List;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...visits.map((visit) {
          final visitMap = visit as Map<String, dynamic>;
          final attachments = visitMap['attachments'] as List;


          return Card(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'event',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ),
                title: Text(
                  visitMap['type'] as String,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    Text(
                      visitMap['date'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${visitMap['provider']} - ${visitMap['department']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVisitDetailRow(theme, 'Chief Complaint',
                            visitMap['chiefComplaint'] as String),
                        SizedBox(height: 1.h),
                        _buildVisitDetailRow(theme, 'Diagnosis',
                            visitMap['diagnosis'] as String),
                        SizedBox(height: 1.h),
                        _buildVisitDetailRow(
                            theme, 'Notes', visitMap['notes'] as String),
                        if (attachments.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            'Attachments',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          ...attachments.map((attachment) {
                            final attachmentMap =
                                attachment as Map<String, dynamic>;
                            return Container(
                              margin: EdgeInsets.only(bottom: 1.h),
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CustomImageWidget(
                                      imagePath: attachmentMap['url'] as String,
                                      width: 12.w,
                                      height: 12.w,
                                      fit: BoxFit.cover,
                                      semanticLabel:
                                          attachmentMap['semanticLabel']
                                              as String,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          attachmentMap['type'] as String,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          attachmentMap['name'] as String,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomIconWidget(
                                    iconName: 'chevron_right',
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }


  Widget _buildInfoRow(
      ThemeData theme, String iconName, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildVisitDetailRow(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
