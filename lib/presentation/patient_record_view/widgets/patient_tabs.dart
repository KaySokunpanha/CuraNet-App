import 'package:flutter/material.dart';

class PatientTabs extends StatelessWidget {
  final TabController controller;

  const PatientTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Records'),
          Tab(text: 'Prescriptions'),
          Tab(text: 'Vitals'),
        ],
      ),
    );
  }
}
