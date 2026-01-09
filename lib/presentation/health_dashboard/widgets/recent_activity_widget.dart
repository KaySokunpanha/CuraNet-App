import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Recent activity timeline showing medical record updates
/// Displays chronological feed with swipe-to-archive functionality
class RecentActivityWidget extends StatefulWidget {
  const RecentActivityWidget({super.key});


  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}


class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  final List<Map<String, dynamic>> _activities = [
    {
      "id": 1,
      "type": "record_upload",
      "title": "Lab Results Uploaded",
      "description":
          "Complete Blood Count (CBC) test results from City Hospital",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "icon": "science",
      "color": "primary",
      "category": "Lab",
    },
    {
      "id": 2,
      "type": "access_grant",
      "title": "Access Granted",
      "description": "Dr. Michael Chen can now view your medical records",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "icon": "verified_user",
      "color": "success",
      "category": "Access",
    },
    {
      "id": 3,
      "type": "appointment",
      "title": "Upcoming Appointment",
      "description": "Cardiology consultation with Dr. Sarah Williams",
      "timestamp": DateTime.now().add(const Duration(days: 2)),
      "icon": "event",
      "color": "secondary",
      "category": "Appointment",
    },
    {
      "id": 4,
      "type": "record_upload",
      "title": "Prescription Added",
      "description": "Medication prescription for hypertension management",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "icon": "medication",
      "color": "tertiary",
      "category": "Prescription",
    },
    {
      "id": 5,
      "type": "record_upload",
      "title": "X-Ray Imaging",
      "description": "Chest X-ray imaging uploaded from Radiology Center",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "icon": "medical_services",
      "color": "primary",
      "category": "Imaging",
    },
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final activity = _activities[index];
          return Dismissible(
            key: Key(activity["id"].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 4.w),
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'archive',
                size: 24,
                color: theme.colorScheme.error,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                _activities.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${activity["title"]} archived',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _activities.insert(index, activity);
                      });
                    },
                  ),
                ),
              );
            },
            child: _buildActivityItem(context, activity, theme),
          );
        },
        childCount: _activities.length,
      ),
    );
  }


  /// Build individual activity item
  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    ThemeData theme,
  ) {
    final Color activityColor = _getActivityColor(
      activity["color"] as String,
      theme,
    );


    return Container(
      margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleActivityTap(context, activity),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: activityColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: activity["icon"] as String,
                      size: 20,
                      color: activityColor,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),


                // Activity details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              activity["title"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: activityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              activity["category"] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: activityColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        activity["description"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatTimestamp(activity["timestamp"] as DateTime),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  /// Get activity color based on type
  Color _getActivityColor(String colorType, ThemeData theme) {
    switch (colorType) {
      case 'primary':
        return theme.colorScheme.primary;
      case 'secondary':
        return theme.colorScheme.secondary;
      case 'tertiary':
        return theme.colorScheme.tertiary;
      case 'success':
        return const Color(0xFF10B981);
      case 'error':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }


  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = timestamp.difference(now);


    if (difference.isNegative) {
      final absDifference = difference.abs();
      if (absDifference.inMinutes < 60) {
        return '${absDifference.inMinutes}m ago';
      } else if (absDifference.inHours < 24) {
        return '${absDifference.inHours}h ago';
      } else {
        return '${absDifference.inDays}d ago';
      }
    } else {
      if (difference.inHours < 24) {
        return 'In ${difference.inHours}h';
      } else {
        return 'In ${difference.inDays}d';
      }
    }
  }


  /// Handle activity item tap
  void _handleActivityTap(BuildContext context, Map<String, dynamic> activity) {
    final type = activity["type"] as String;


    if (type == "record_upload") {
      Navigator.pushNamed(context, '/medical-records-screen');
    } else if (type == "appointment") {
      Navigator.pushNamed(context, '/patient-record-view');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Viewing ${activity["title"]}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
