import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialMenu extends StatelessWidget {
  const SpeedDialMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: theme.primaryColor,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.note_add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Add Record',
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.calendar_today),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Book Appointment',
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.monitor_heart),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'Log Vitals',
          onTap: () {},
        ),
      ],
    );
  }
}
