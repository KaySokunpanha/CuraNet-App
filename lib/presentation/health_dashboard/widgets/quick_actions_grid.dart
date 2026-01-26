import 'package:flutter/material.dart';
import '../../add_record/add_record_bottom_sheet.dart';
import '../../main_screen/main_screen.dart';
import 'package:curanet/routes/app_routes.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(
      icon: Icons.add_circle_outline,
      label: 'Add Record',
      color: Color(0xFF2196F3),
      isAddRecord: true, // Special flag for bottom sheet
    ),
    _QuickAction(
      icon: Icons.calendar_today_outlined,
      label: 'Schedule',
      color: Color(0xFF4CAF50),
    ),
    _QuickAction(
      icon: Icons.add_box_outlined,
      label: 'Emergency',
      color: Color(0xFFF44336),
    ),
    _QuickAction(
      icon: Icons.local_hospital_rounded,
      label: 'Find Hospital',
      color: Color(0xFFD32F2F), // Red for Action/Urgency
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _actions.map((action) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () {
                    if (action.isAddRecord) {
                      // Show Add Record bottom sheet
                      AddRecordBottomSheet.show(context);
                    } else if (action.label == 'Schedule') {
                      // Navigate to Schedule Tab (Index 2 in MainScreen)
                      MainScreenState.of(context)?.switchToTab(2);
                    } else if (action.label == 'Emergency') {
                      Navigator.pushNamed(context, AppRoutes.emergencyScreen);
                    } else if (action.label == 'Find Hospital') {
                      Navigator.pushNamed(context, AppRoutes.nearbyCareScreen);
                    } else if (action.routeName != null) {
                      Navigator.pushNamed(context, action.routeName!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${action.label} coming soon'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: action.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(action.icon, color: action.color, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.routeName,
    this.isAddRecord = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String? routeName;
  final bool isAddRecord;
}
