import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import '../providers/favorites_provider.dart';
import '../widgets/spot_card.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  late final Stream<List<TouristSpot>> _spotsStream;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Park',
    'River',
    'Beach',
    'Industrial',
    'Mountain',
    'Historical',
    'Cultural',
    'Religious',
    'Farm',
  ];

  @override
  void initState() {
    super.initState();
    _spotsStream = FirestoreService().getSpots('elyu');
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Horizontal scrollable small chips
          SizedBox(
            height: 36,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.teal
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.teal
                                : Colors.grey.shade400,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // 🔹 Favorites Grid
          Expanded(
            child: favoritesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Error loading favorites: $err')),
              data: (favorites) {
                return StreamBuilder<List<TouristSpot>>(
                  stream: _spotsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No tourist spots available.'),
                      );
                    }

                    final allSpots = snapshot.data!
                        .where((spot) => favorites.contains(spot.id))
                        .toList();

                    final filteredSpots = (_selectedCategory == 'All')
                        ? allSpots
                        : allSpots
                              .where(
                                (s) =>
                                    s.category.toLowerCase() ==
                                    _selectedCategory.toLowerCase(),
                              )
                              .toList();

                    if (filteredSpots.isEmpty) {
                      return const Center(
                        child: Text('No favorites found for this category.'),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                      itemCount: filteredSpots.length,
                      itemBuilder: (context, index) {
                        final spot = filteredSpots[index];
                        return SpotCard(
                          spot: spot,
                          isFavorite: true,
                          onFavoriteToggle: (id) async {
                            await ref
                                .read(favoritesProvider.notifier)
                                .toggle(spot.id);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
