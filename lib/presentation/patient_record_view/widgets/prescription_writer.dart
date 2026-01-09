import 'package:flutter/material.dart';

class PrescriptionWriter extends StatefulWidget {
  const PrescriptionWriter({super.key});

  @override
  State<PrescriptionWriter> createState() => _PrescriptionWriterState();
}

class _PrescriptionWriterState extends State<PrescriptionWriter> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> _medications = [];

  void _addMedication() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Dosage'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Prescription'),
        actions: [
          TextButton(
            onPressed: () {
              // Save logic
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Medications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (_medications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No medications added yet'),
                ),
              ),
            ElevatedButton.icon(
              onPressed: _addMedication,
              icon: const Icon(Icons.add),
              label: const Text('Add Medication'),
            ),
            const SizedBox(height: 24),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes / Instructions',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
