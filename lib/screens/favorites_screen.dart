import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import '../providers/favorites_provider.dart';
import '../widgets/spot_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return favoritesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (favorites) {
        return StreamBuilder<List<TouristSpot>>(
          stream: FirestoreService().getSpots('elyu'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tourist spots available.'));
            }

            final favSpots = snapshot.data!
                .where((spot) => favorites.contains(spot.id))
                .toList();

            if (favSpots.isEmpty) {
              return const Center(child: Text('No favorites yet.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: favSpots.length,
              itemBuilder: (context, index) {
                final spot = favSpots[index];
                return SpotCard(
                  spot: spot,
                  isFavorite: true,
                  onFavoriteToggle: (id) =>
                      ref.read(favoritesProvider.notifier).toggle(id),
                );
              },
            );
          },
        );
      },
    );
  }
}
