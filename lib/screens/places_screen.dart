import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/elyu_spot.dart';
import '../services/firestore.dart';
import 'municipality/municipality_list.dart';
import '../widgets/places/shimmer_loader.dart';
import '../widgets/places/shimmer_list_loader.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _precached = <String>{};
  bool _isRefreshing = false;

  Future<String?> _getPhotoForMunicipality(String muni) async {
    final doc = await FirebaseFirestore.instance
        .collection('elyu')
        .doc(muni)
        .get();
    return (doc.exists && doc.data()?['photo'] != null)
        ? doc.data()!['photo'] as String
        : null;
  }

  void _precacheImage(String url) {
    if (_precached.contains(url)) return;
    _precached.add(url);

    final ImageProvider imageProvider = kIsWeb
        ? NetworkImage(url)
        : CachedNetworkImageProvider(url);

    try {
      precacheImage(imageProvider, context);
    } catch (e, stackTrace) {
      debugPrint('⚠️ Failed to precache image: $url\n$e\n$stackTrace');
    }
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Scaffold(
      body: SafeArea(
        child: _isRefreshing
            ? const ShimmerListLoader()
            : RefreshIndicator(
                onRefresh: _refresh,
                child: StreamBuilder<List<TouristSpot>>(
                  stream: FirestoreService().getSpots('elyu'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ShimmerListLoader();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data found.'));
                    }

                    final muniSet = <String>{};
                    for (final spot in snapshot.data!) {
                      if (spot.municipality.trim().isNotEmpty) {
                        muniSet.add(spot.municipality.trim());
                      }
                    }

                    final municipalities = muniSet.toList()..sort();

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: municipalities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final muni = municipalities[index];

                        return FutureBuilder<String?>(
                          future: _getPhotoForMunicipality(muni),
                          builder: (context, urlSnap) {
                            final photoUrl = urlSnap.data;

                            if (photoUrl != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _precacheImage(photoUrl);
                              });
                            }

                            return ClipRRect(
                              borderRadius: borderRadius,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MunicipalityListScreen(
                                        municipality: muni,
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 180,
                                    child: (photoUrl == null)
                                        ? MunicipalityShimmer(
                                            borderRadius: borderRadius,
                                          )
                                        : Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: photoUrl,
                                                fit: BoxFit.cover,
                                                placeholder: (_, __) =>
                                                    MunicipalityShimmer(
                                                      borderRadius:
                                                          borderRadius,
                                                    ),
                                                errorWidget: (_, __, ___) =>
                                                    MunicipalityShimmer(
                                                      borderRadius:
                                                          borderRadius,
                                                    ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                color: Colors.black.withOpacity(
                                                  0.35,
                                                ),
                                                child: Text(
                                                  muni,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            shadows: const [
                                                              Shadow(
                                                                blurRadius: 4,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ],
                                                          ) ??
                                                      const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
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
      ),
    );
  }
}
