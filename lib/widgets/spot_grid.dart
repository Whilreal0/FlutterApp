import 'package:flutter/material.dart';
import '../models/tourist_spot.dart';
import 'spot_card.dart';

class SpotGrid extends StatelessWidget {
  final List<TouristSpot> spots;
  final Set<String> favorites;
  final void Function(String id) onFavoriteToggle;

  const SpotGrid({
    super.key,
    required this.spots,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(child: Text("No matches found"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: spots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, i) {
        final spot = spots[i];
        return SpotCard(
          spot: spot,
          isFavorite: favorites.contains(spot.id),
          onFavoriteToggle: () => onFavoriteToggle(spot.id),
        );
      },
    );
  }
}
