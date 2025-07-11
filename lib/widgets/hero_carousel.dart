import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elyu_app/services/firestore.dart';
import 'package:elyu_app/widgets/carousel_indicator.dart';

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late Future<List<Map<String, dynamic>>> _spotsFuture;
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _autoScrollTimer;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _spotsFuture = getTopSpotsFromDocuments();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients && _itemCount > 1) {
        final nextPage = (_currentIndex + 1) % _itemCount;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.5;

    return SizedBox(
      height: height,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _spotsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No images available"));
          }

          final spots = snapshot.data!;
          _itemCount = spots.length;

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: spots.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final spot = spots[index];
                  final imageUrl = spot['photo'] ?? '';
                  final title = spot['name'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      // TODO: Navigate to detail screen
                    },
                    child: Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.broken_image, size: 80));
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30), // ➕ adds more space at the bottom
                            alignment: Alignment.bottomCenter, // ✅ Center horizontally at the bottom
                            child: Text(
                              title,
                              textAlign: TextAlign.center, // ✅ Align text center inside container
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
                      ),
                    ),
                  );
                },
              ),
              CarouselIndicator(currentIndex: _currentIndex, itemCount: spots.length),
            ],
          );
        },
      ),
    );
  }
}
