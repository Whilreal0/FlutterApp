import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourist_spot.dart';
import '../widgets/spot_card.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('spots').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allSpots = snapshot.data!.docs
              .map((doc) => TouristSpot.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .where((spot) => favorites.contains(spot.id))
              .toList();

          if (allSpots.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: allSpots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (_, i) => SpotCard(
              spot: allSpots[i],
              isFavorite: true,
              onFavoriteToggle: () {}, // Read-only on this screen
            ),
          );
        },
      ),
    );
  }
}
