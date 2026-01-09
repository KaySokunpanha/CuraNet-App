import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Quick action buttons for common medical tasks
/// Provides thumb-friendly access to key features
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    final actions = [
      _QuickAction(
        icon: 'add_circle_outline',
        label: 'Add Record',
        color: theme.colorScheme.primary,
        onTap: () => _handleAddRecord(context),
      ),
      _QuickAction(
        icon: 'calendar_today',
        label: 'Schedule',
        color: theme.colorScheme.secondary,
        onTap: () => _handleSchedule(context),
      ),
      _QuickAction(
        icon: 'emergency',
        label: 'Emergency',
        color: theme.colorScheme.error,
        onTap: () => _handleEmergency(context),
      ),
      _QuickAction(
        icon: 'qr_code',
        label: 'Share ID',
        color: theme.colorScheme.tertiary,
        onTap: () => _handleShareId(context),
      ),
    ];


    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: _buildActionButton(context, action, theme),
            ),
          );
        }).toList(),
      ),
    );
  }


  /// Build individual action button
  Widget _buildActionButton(
    BuildContext context,
    _QuickAction action,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: action.color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: action.icon,
                    size: 24,
                    color: action.color,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                action.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Handle add record action
  void _handleAddRecord(BuildContext context) {
    Navigator.pushNamed(context, '/medical-records-screen');
  }


  /// Handle schedule appointment action
  void _handleSchedule(BuildContext context) {
    Navigator.pushNamed(context, '/patient-record-view');
  }


  /// Handle emergency SOS action
  void _handleEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              size: 24,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: 2.w),
            const Text('Emergency SOS'),
          ],
        ),
        content: const Text(
          'This will share your location and medical information with emergency contacts. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Emergency alert sent to contacts'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Activate SOS'),
          ),
        ],
      ),
    );
  }


  /// Handle share health ID action
  void _handleShareId(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Health ID',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'qr_code_scanner',
                size: 24,
              ),
              title: const Text('Show QR Code'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR code displayed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'share',
                size: 24,
              ),
              title: const Text('Share via Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health ID link copied'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/// Quick action data model
class _QuickAction {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;


  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
