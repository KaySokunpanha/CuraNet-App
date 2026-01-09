import 'package:flutter/material.dart';
import 'prescription_writer.dart';

class PrescriptionsTab extends StatelessWidget {
  const PrescriptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text('Prescription #${1001 + index}'),
              subtitle: const Text('Dr. Sarah Smith • 12 Oct 2023'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMedItem('Amoxicillin', '500mg', '3 times a day'),
                      const Divider(),
                      _buildMedItem('Paracetamol', '650mg', 'SOS'),
                      const SizedBox(height: 16),
                      const Text(
                        'Notes: Take after food. Complete full course.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrescriptionWriter()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedItem(String name, String dosage, String frequency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(dosage),
            ],
          ),
          Text(frequency),
        ],
      ),
    );
  }
}
