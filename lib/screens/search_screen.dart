import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elyu_app/models/elyu_spot.dart';
import 'package:elyu_app/screens/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elyu_app/widgets/search/shimmer_loader.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<TouristSpot> _results = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    final towns = await FirebaseFirestore.instance.collection('elyu').get();
    final List<TouristSpot> spots = [];

    for (final town in towns.docs) {
      final muniName = town.id;
      final sub = await town.reference.collection('tourist_spots').get();

      for (final doc in sub.docs) {
        final data = doc.data();
        final name = data['name']?.toString().toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        // 🔍 Match either name or municipality
        if (name.contains(queryLower) ||
            muniName.toLowerCase().contains(queryLower)) {
          final rawPhotos = data['photos'] as List<dynamic>? ?? [];
          final photoUrls = rawPhotos
              .map(
                (photo) => photo is Map && photo['url'] != null
                    ? photo['url'] as String
                    : '',
              )
              .where((url) => url.isNotEmpty)
              .toList();

          spots.add(
            TouristSpot(
              id: doc.id,
              name: data['name'] ?? '',
              description: data['description'] ?? '',
              barangay: data['barangay'] ?? '',
              lat: (data['lat'] ?? 0.0).toDouble(),
              lng: (data['lng'] ?? 0.0).toDouble(),
              municipality: muniName,
              photos: photoUrls,
              categories: List<String>.from(data['categories'] ?? []),
            ),
          );
        }
      }
    }

    setState(() {
      _results = spots;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search tourist spot name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            if (_isLoading)
              Expanded(
                child: ListView.builder(
                  itemCount: 8, // any placeholder count you like
                  itemBuilder: (_, __) => const ShimmerListTile(),
                ),
              )
            else if (_results.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No matching tourist spots found.'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final spot = _results[index];
                    final imageUrl = spot.photos.isNotEmpty
                        ? spot.photos.first
                        : 'https://via.placeholder.com/400x300?text=No+Image';

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(spot.name),
                      subtitle: Text('${spot.barangay}, ${spot.municipality}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(spot: spot),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
