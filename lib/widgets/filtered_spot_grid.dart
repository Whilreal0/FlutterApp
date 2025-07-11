import 'package:flutter/material.dart';
import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import 'spot_card.dart';

class FilteredSpotGrid extends StatelessWidget {
  final String? selectedCategory;
  final Set<String> favorites;
  final void Function(String) onFavoriteToggle;

  const FilteredSpotGrid({
    super.key,
    required this.selectedCategory,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TouristSpot>>(
      stream: FirestoreService().getAllTouristSpots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allSpots = snapshot.data!;
        final filtered = (selectedCategory == null ||
                selectedCategory!.toLowerCase() == 'all')
            ? allSpots
            : allSpots
                .where((s) =>
                    s.category.toLowerCase() == selectedCategory!.toLowerCase())
                .toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, i) {
            final spot = filtered[i];
            return SpotCard(
              spot: spot,
              isFavorite: favorites.contains(spot.id),
              onFavoriteToggle: onFavoriteToggle,
            );
          },
        );
      },
    );
  }
}
