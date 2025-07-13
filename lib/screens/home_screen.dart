import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../widgets/category_filter.dart';
import '../widgets/filtered_spot_grid.dart';
import '../widgets/hero_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      
      body: Column(
        children: [
          // ✅ HeroCarousel 
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: const HeroCarousel(),
          ),
          // ✅ Category Filter Chips
          CategoryFilter(
            selected: _selectedCategory,
            onChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: favoritesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (favorites) {
                return FilteredSpotGrid(
                  selectedCategory: _selectedCategory,
                  favorites: favorites,
                  onFavoriteToggle: (spotId) =>
                      ref.read(favoritesProvider.notifier).toggle(spotId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
