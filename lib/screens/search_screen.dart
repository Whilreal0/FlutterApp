import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourist_spot.dart';
import '../widgets/spot_card.dart';
import '../services/favorites_service.dart';

class SearchScreen extends StatefulWidget {
  final Set<String> favorites;
  final Function(String id) onFavoriteToggle;

  const SearchScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search Destination'),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          if (_query.isEmpty)
            const Expanded(
              child: Center(child: Text("Start typing to search")),
            )
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('spots').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final spots = snapshot.data!.docs
                      .map((doc) => TouristSpot.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                      .where((spot) => spot.name.toLowerCase().contains(_query.toLowerCase()))
                      .toList();

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
                    itemBuilder: (_, i) => SpotCard(
                      spot: spots[i],
                      isFavorite: widget.favorites.contains(spots[i].id),
                      onFavoriteToggle: () => widget.onFavoriteToggle(spots[i].id),
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