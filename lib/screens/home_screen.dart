import 'package:flutter/material.dart';
import '../models/tourist_spot.dart';
import '../services/firestore_service.dart';
import '../services/favorites_service.dart';
import '../widgets/spot_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestore = FirestoreService();
  final FavoritesService _favoritesService = FavoritesService();
  Set<String> _favorites = {};
  String _search = "";

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favorites = await _favoritesService.loadFavorites();
    setState(() {});
  }

  void _toggleFavorite(String id) {
    setState(() {
      _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    });
    _favoritesService.saveFavorites(_favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Spots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(favorites: _favorites),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search...'),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TouristSpot>>(
              stream: _firestore.getSpots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tourist spot found"));
                }

                final filtered = snapshot.data!
                    .where((s) => s.name.toLowerCase().contains(_search.toLowerCase()))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No matches found"));
                }

                return GridView.builder(
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
                    isFavorite: _favorites.contains(filtered[i].id),
                    onFavoriteToggle: () => _toggleFavorite(filtered[i].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
