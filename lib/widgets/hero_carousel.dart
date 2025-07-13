import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elyu_app/widgets/carousel_indicator.dart';

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late Future<List<Map<String, dynamic>>> _randomSpotsFuture;
  final _pageController = PageController();
  final _rand = Random();
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _randomSpotsFuture = _get3RandomSpotsOnce(); // ← only once per app open
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.hasClients) {
        final next = (_currentIndex + 1) % 3;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Picks 3 distinct municipalities, one random spot each,
/// reading EITHER the inline array OR the `tourist_spots` sub‑collection.
Future<List<Map<String, dynamic>>> _get3RandomSpotsOnce() async {
  final allTownDocs =
      (await FirebaseFirestore.instance.collection('elyu').get()).docs.toList()
        ..shuffle(_rand);

  final List<Map<String, dynamic>> result = [];

  for (final townDoc in allTownDocs) {
    if (result.length >= 3) break;

    final townName = townDoc.id;
    final townData = townDoc.data();

    // 1️⃣ Try inline array
    List<Map<String, dynamic>> spots =
        List<Map<String, dynamic>>.from(townData['tourist_spots'] ?? []);

    // 2️⃣ If no inline array, try sub‑collection
    if (spots.isEmpty) {
      final sub = await townDoc.reference.collection('tourist_spots').get();
       spots = sub.docs.map((d) => d.data()).toList();
    }

    if (spots.isEmpty) {
      debugPrint('⚠️  $townName has no tourist spots.');
      continue; // next municipality
    }

    spots.shuffle(_rand);

    for (final spot in spots) {
      final photos = List<Map<String, dynamic>>.from(spot['photos'] ?? []);
      if (photos.isEmpty) continue;

      final url = photos.first['url']?.toString() ?? '';
      if (url.isEmpty) continue;

      result.add({
        'id': '${townName}_${spot['name']}',
        'name': spot['name'] ?? 'Unknown',
        'photo': url,
      });

      debugPrint('✅ Added "${spot['name']}" from $townName');
      break; // only 1 spot per municipality
    }
  }

  debugPrint('🎯 Total spots selected for carousel: ${result.length}');
  return result;
}


  // ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.3;

    return SizedBox(
      height: height,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _randomSpotsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('No images available'));
          }

          final spots = snap.data!;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: spots.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (_, i) {
                  final spot = spots[i];
                  final url = spot['photo'] ?? '';
                  final title = spot['name'] ?? '';

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image)),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: CarouselIndicator(
                  currentIndex: _currentIndex,
                  itemCount: spots.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
