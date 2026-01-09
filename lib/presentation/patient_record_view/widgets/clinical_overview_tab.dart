import 'package:flutter/material.dart';

class ClinicalOverviewTab extends StatelessWidget {
  const ClinicalOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          title: 'Active Conditions',
          children: [
            _buildConditionChip('Hypertension', Colors.orange),
            _buildConditionChip('Type 2 Diabetes', Colors.red),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          title: 'Allergies',
          children: [
            _buildConditionChip('Penicillin', Colors.red),
            _buildConditionChip('Peanuts', Colors.red),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          title: 'Current Medications',
          children: [
            _buildMedicationCard('Lisinopril', '10mg', 'Daily'),
            _buildMedicationCard('Metformin', '500mg', 'Twice daily'),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: children,
        ),
      ],
    );
  }

  Widget _buildConditionChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
    );
  }

  Widget _buildMedicationCard(String name, String dosage, String frequency) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.medication),
        title: Text(name),
        subtitle: Text('$dosage • $frequency'),
      ),
    );
  }
}
