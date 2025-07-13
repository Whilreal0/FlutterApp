import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/elyu_spot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/details_chips/category_chip.dart';

class DetailScreen extends StatelessWidget {
  final TouristSpot spot;

  const DetailScreen({super.key, required this.spot});

  void _openInMaps() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${spot.lat},${spot.lng}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top image with back button and Hero animation
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Hero(
                          tag: spot.id,
                          child: CachedNetworkImage(
                            imageUrl: spot.photos.isNotEmpty
                                ? spot.photos.first
                                : 'https://via.placeholder.com/400x300?text=No+Image',
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (_, __, ___) =>
                                const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        spot.name,
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Category Chip (reusable)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        children: spot.categories
                            .map((cat) => CategoryChip(category: cat))
                            .toList(),
                      ),
                    ),
                  ),

                  // Barangay + Municipality Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Barangay + Municipality text
                        Expanded(
                          child: Text(
                            'Brgy ${spot.barangay}, ${spot.municipality}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // Google Maps icon button
                        IconButton(
                          onPressed: _openInMaps,
                          icon: const Icon(Icons.location_on_outlined),
                          tooltip: 'Open in Google Maps',
                          color: Colors.teal.shade600,
                          iconSize: 20,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.teal.shade50,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      spot.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
