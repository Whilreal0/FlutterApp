import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import 'municipality/municipality_list.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  /// Keep track so we don't precache the same URL twice.
  final _precached = <String>{};

  Future<String> _getPhotoForMunicipality(String muni) async {
    final doc =
        await FirebaseFirestore.instance.collection('elyu').doc(muni).get();
    return (doc.exists && doc.data()?['photo'] != null)
        ? doc.data()!['photo'] as String
        : 'https://via.placeholder.com/600x300?text=${Uri.encodeComponent(muni)}';
  }

  /// Pre‑cache an image once.
  void _precacheImage(String url) {
    if (_precached.contains(url)) return;
    _precached.add(url);
    precacheImage(CachedNetworkImageProvider(url), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<TouristSpot>>(
          stream: FirestoreService().getSpots('elyu'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            // ---- unique municipalities ----
            final muniSet = <String>{};
            for (final spot in snapshot.data!) {
              if (spot.municipality.trim().isNotEmpty) {
                muniSet.add(spot.municipality.trim());
              }
            }
            final municipalities = muniSet.toList()..sort();

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: municipalities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final muni = municipalities[index];

                return FutureBuilder<String>(
                  future: _getPhotoForMunicipality(muni),
                  builder: (context, urlSnap) {
                    final photoUrl = urlSnap.data ??
                        'https://via.placeholder.com/600x300?text=${Uri.encodeComponent(muni)}';

                    // Pre‑cache once (after URL determined)
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _precacheImage(photoUrl);
                    });

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MunicipalityListScreen(municipality: muni),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 180,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: photoUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(color: Colors.grey),
                                ),
                                errorWidget: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                color: Colors.black.withOpacity(0.35),
                                child: Text(
                                  muni,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: const [
                                              Shadow(
                                                  blurRadius: 4,
                                                  color: Colors.black),
                                            ],
                                          ) ??
                                      const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
