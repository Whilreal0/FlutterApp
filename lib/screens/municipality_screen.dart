import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourist_spot.dart';
import '../widgets/spot_card.dart';

class MunicipalityScreen extends StatelessWidget {
  final Set<String> favorites;
  final Function(String id) onFavoriteToggle;

  const MunicipalityScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spots by Municipality")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('spots').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final spots = snapshot.data!.docs
              .map((doc) => TouristSpot.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          // Group spots by municipality
          final Map<String, List<TouristSpot>> grouped = {};
          for (var spot in spots) {
            grouped.putIfAbsent(spot.municipality, () => []).add(spot);
          }

          return ListView(
            children: grouped.entries.map((entry) {
              final municipality = entry.key;
              final spots = entry.value;

              return ExpansionTile(
                title: Text(
                  municipality,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: spots.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (_, i) => SpotCard(
                      spot: spots[i],
                      isFavorite: favorites.contains(spots[i].id),
                      onFavoriteToggle: () => onFavoriteToggle(spots[i].id),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
