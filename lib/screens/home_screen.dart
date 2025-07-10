import 'package:flutter/material.dart';
import '../models/tourist_spot.dart';
import '../services/firestore_service.dart';
import '../widgets/spot_card.dart';
import '../widgets/spot_carousel.dart';
import '../widgets/category_filter.dart';

class HomeScreen extends StatefulWidget {
  final Set<String> favorites;
  final Function(String id) onFavoriteToggle;

  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestore = FirestoreService();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tourist Spots")),
      body: StreamBuilder<List<TouristSpot>>(
        stream: _firestore.getSpots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final spots = snapshot.data!;
          final topSpots = spots.take(5).toList();

          final filtered = _selectedCategory == 'All'
              ? spots
              : spots.where((s) => s.category == _selectedCategory).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpotCarousel(spots: topSpots),
              CategoryFilter(
                selected: _selectedCategory,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
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
                    isFavorite: widget.favorites.contains(filtered[i].id),
                    onFavoriteToggle: () =>
                        widget.onFavoriteToggle(filtered[i].id),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
