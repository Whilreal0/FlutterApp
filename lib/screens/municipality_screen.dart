import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourist_spot.dart';
import 'municipality_spots_screen.dart';

class MunicipalityScreen extends StatelessWidget {
  final Set<String> favorites;
  final Function(String id) onFavoriteToggle;

  const MunicipalityScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Browse by Municipality")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('spots').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final spots = snapshot.data!.docs
              .map((doc) => TouristSpot.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          final municipalities = {
            for (var spot in spots) spot.municipality
          }.toList();

          return ListView.builder(
            itemCount: municipalities.length,
            itemBuilder: (context, index) {
              final name = municipalities[index];
              final imageUrl = 'https://picsum.photos/seed/$index/600/300';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MunicipalitySpotsScreen(
                        municipality: name,
                        allSpots: spots,
                        favorites: favorites,
                        onFavoriteToggle: onFavoriteToggle,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
