import 'package:flutter/material.dart';

class InstitutesPage extends StatelessWidget {
  const InstitutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final institutes = const [
      'Institute of Technology',
      'National Institute of Arts',
      'Regional Science Academy',
      'College of Engineering',
      'Business Institute',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Institutes')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: institutes.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final name = institutes[index];
          return ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(name),
            subtitle: const Text('Tap to view details'),
            onTap: () {
              // Placeholder for institute details/route
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Open: $name')));
            },
          );
        },
      ),
    );
  }
}
