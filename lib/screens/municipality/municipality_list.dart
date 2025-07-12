import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MunicipalityListScreen extends StatelessWidget {
  final String municipality;

  const MunicipalityListScreen({super.key, required this.municipality});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('elyu') // ✅ correct collection name
        .doc(municipality); // ✅ respect exact casing (e.g. "Agoo")

    return Scaffold(
      appBar: AppBar(title: Text(municipality)),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Municipality data not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final description = data['description'] ?? '';
          final history = data['history'] ?? '';
          final classification = data['classification'] ?? 'Unknown';
          final barangayCount = data['barangay_count'] ?? 'N/A';
          final population = data['population'] ?? 'N/A';
          final festivals = List<String>.from(data['festivals'] ?? []);
          final specialties = List<String>.from(data['specialties'] ?? []);
          final touristSpots = List<Map<String, dynamic>>.from(
            data['tourist_spots'] ?? [],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🌄 Static placeholder for header image
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

                Text(description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),

                Text('History', style: Theme.of(context).textTheme.titleMedium),
                Text(history),

                const SizedBox(height: 12),
                Text('Classification: $classification'),
                Text('Barangays: $barangayCount'),
                Text('Population: $population'),

                const SizedBox(height: 12),
                if (festivals.isNotEmpty) ...[
                  Text('Festivals', style: Theme.of(context).textTheme.titleMedium),
                  ...festivals.map((f) => Text('• $f')),
                ],

                const SizedBox(height: 12),
                if (specialties.isNotEmpty) ...[
                  Text('Specialties', style: Theme.of(context).textTheme.titleMedium),
                  ...specialties.map((s) => Text('• $s')),
                ],

                const SizedBox(height: 24),
                if (touristSpots.isNotEmpty) ...[
                  Text('Tourist Spots', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...touristSpots.map((spot) {
                    final name = spot['name'] ?? 'Unnamed';
                    final desc = spot['description'] ?? '';
                    final imgUrl = spot['photos']?[0]['url'] ??
                        // 'https://via.placeholder.com/400x300';
                        'https://picsum.photos/id/18/200/300';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              imgUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                                const SizedBox(height: 4),
                                Text(desc, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
