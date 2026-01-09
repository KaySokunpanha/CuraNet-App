import 'package:flutter/material.dart';

class VitalsTab extends StatelessWidget {
  const VitalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVitalCard(
          context,
          title: 'Blood Pressure',
          value: '120/80',
          unit: 'mmHg',
          date: 'Today, 9:00 AM',
          icon: Icons.favorite,
          color: Colors.red,
        ),
        _buildVitalCard(
          context,
          title: 'Heart Rate',
          value: '72',
          unit: 'bpm',
          date: 'Today, 9:00 AM',
          icon: Icons.monitor_heart,
          color: Colors.blue,
        ),
        _buildVitalCard(
          context,
          title: 'Temperature',
          value: '98.6',
          unit: '°F',
          date: 'Today, 9:00 AM',
          icon: Icons.thermostat,
          color: Colors.orange,
        ),
        _buildVitalCard(
          context,
          title: 'Weight',
          value: '75',
          unit: 'kg',
          date: 'Today, 9:00 AM',
          icon: Icons.monitor_weight,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildVitalCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
