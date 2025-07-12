import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MunicipalityListScreen extends StatelessWidget {
  final String municipality;

  const MunicipalityListScreen({super.key, required this.municipality});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('elyu') // 👈 your actual collection
        .doc(municipality);

    return Scaffold(
      appBar: AppBar(title: Text(municipality)),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Municipality data not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom + 16, // ✅ prevent overflow
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🌄 Static placeholder image (replace later if needed)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://via.placeholder.com/600x300?text=${municipality.replaceAll(' ', '+')}',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    data['description'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 12),

                  // History
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(data['history'] ?? ''),

                  const SizedBox(height: 12),

                  // Classification / Stats
                  Text('Classification: ${data['classification'] ?? 'Unknown'}'),
                  Text('Barangays: ${data['barangay_count'] ?? 'N/A'}'),
                  Text('Population: ${data['population'] ?? 'N/A'}'),

                  const SizedBox(height: 12),

                  // Festivals
                  if (data['festivals'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Festivals',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ...List.from(data['festivals']).map((f) => Text('• $f')),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // Specialties
                  if (data['specialties'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Specialties',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ...List.from(data['specialties']).map((s) => Text('• $s')),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
