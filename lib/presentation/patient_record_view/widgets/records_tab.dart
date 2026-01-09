import 'package:flutter/material.dart';

class RecordsTab extends StatelessWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description_outlined, color: Colors.blue),
            ),
            title: const Text('Lab Report - Blood Work'),
            subtitle: const Text('15 Oct 2023 • City Lab'),
            trailing: IconButton(
              icon: const Icon(Icons.download_rounded),
              onPressed: () {},
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
