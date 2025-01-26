// lib/widgets/orgs/org_card.dart
import 'package:flutter/material.dart';
import '../../models/org_model.dart';

class OrgCard extends StatelessWidget {
  final Org org;

  const OrgCard({super.key, required this.org});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              org.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Address: ${org.address}'),
            Text('Contact: ${org.contact}'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Dispose
                  },
                  child: const Text('Dispose'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // Handle Give Rating
                  },
                  child: const Text('Give Rating'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}