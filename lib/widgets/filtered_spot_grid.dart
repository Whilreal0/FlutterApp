import 'package:flutter/material.dart';
import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import 'spot_card.dart';

class FilteredSpotGrid extends StatefulWidget {
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
  State<FilteredSpotGrid> createState() => _FilteredSpotGridState();
}

class _FilteredSpotGridState extends State<FilteredSpotGrid> {
  List<TouristSpot> _filteredSpots = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheFilteredImages(); // preload images when widget first builds
  }

  Future<void> _precacheFilteredImages() async {
    for (final spot in _filteredSpots) {
      final imageUrl = (spot.photos.isNotEmpty) ? spot.photos.first : null;
      if (imageUrl != null && imageUrl.startsWith('http')) {
        try {
          await precacheImage(NetworkImage(imageUrl), context);
        } catch (e) {
          debugPrint('❌ Failed to preload image: $imageUrl\nError: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TouristSpot>>(
      stream: FirestoreService().getAllTouristSpots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allSpots = snapshot.data!;
        _filteredSpots = (widget.selectedCategory == null ||
                widget.selectedCategory!.toLowerCase() == 'all')
            ? allSpots
            : allSpots.where((s) {
                // 🔄 Match if any of the spot's categories matches the selected
                return s.categories.any((cat) =>
                    cat.toLowerCase() == widget.selectedCategory!.toLowerCase());
              }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _filteredSpots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, i) {
            final spot = _filteredSpots[i];
            return SpotCard(
              spot: spot,
              isFavorite: widget.favorites.contains(spot.id),
              onFavoriteToggle: widget.onFavoriteToggle,
            );
          },
        );
      },
    );
  }
}
