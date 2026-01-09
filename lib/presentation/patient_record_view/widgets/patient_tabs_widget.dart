import 'package:flutter/material.dart';


/// Patient tabs widget for organizing patient data
class PatientTabsWidget extends StatelessWidget {
  final TabController tabController;


  const PatientTabsWidget({
    super.key,
    required this.tabController,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor: theme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Records'),
          Tab(text: 'Vitals'),
          Tab(text: 'Prescriptions'),
        ],
      ),
    );
  }
}
