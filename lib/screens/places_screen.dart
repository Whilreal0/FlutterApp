import 'package:flutter/material.dart';
import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import 'municipality/municipality_list.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(                    // 👈 added
        child: StreamBuilder<List<TouristSpot>>(
          stream: FirestoreService().getSpots('elyu'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            // Get unique municipalities
            final muniSet = <String>{};
            for (final spot in snapshot.data!) {
              if (spot.municipality.trim().isNotEmpty) {
                muniSet.add(spot.municipality.trim());
              }
            }
            final municipalities = muniSet.toList()..sort();

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: municipalities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final muni = municipalities[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MunicipalityListScreen(municipality: muni),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 180,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 🌄 TODO: Replace with a real image per municipality
                          Image.network(
                            'https://picsum.photos/id/13/200/300',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),

                          // Centered overlay with background tint
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Text(
                              muni,
                              style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: const [
                                          Shadow(
                                              blurRadius: 4,
                                              color: Colors.black),
                                        ],
                                      ) ??
                                  const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
