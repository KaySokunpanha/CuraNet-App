import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Patient header widget displaying basic patient information
class PatientHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;


  const PatientHeaderWidget({
    super.key,
    required this.patientData,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
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
        children: [
          // Patient Photo
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imagePath: patientData['profilePhoto'] as String,
                width: 16.w,
                height: 16.w,
                fit: BoxFit.cover,
                semanticLabel: patientData['semanticLabel'] as String,
              ),
            ),
          ),
          SizedBox(width: 4.w),


          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientData['name'] as String,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      '${patientData['age']} yrs',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      patientData['gender'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      patientData['bloodGroup'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'ID: ${patientData['patientId']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),


          // Quick Actions
          Column(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling patient...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'phone',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                tooltip: 'Call Patient',
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sending message...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'message',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                tooltip: 'Message Patient',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
