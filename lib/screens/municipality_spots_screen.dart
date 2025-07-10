import 'package:flutter/material.dart';
import '../models/tourist_spot.dart';
import '../widgets/spot_card.dart';

class MunicipalitySpotsScreen extends StatelessWidget {
  final String municipality;
  final List<TouristSpot> allSpots;
  final Set<String> favorites;
  final Function(String id) onFavoriteToggle;

  const MunicipalitySpotsScreen({
    super.key,
    required this.municipality,
    required this.allSpots,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = allSpots.where((s) => s.municipality == municipality).toList();

    return Scaffold(
      appBar: AppBar(title: Text(municipality)),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filtered.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (_, i) => SpotCard(
          spot: filtered[i],
          isFavorite: favorites.contains(filtered[i].id),
          onFavoriteToggle: () => onFavoriteToggle(filtered[i].id),
        ),
      ),
    );
  }
}
