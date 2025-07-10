import 'package:flutter/material.dart';
import '../models/tourist_spot.dart';
// add url launcher
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final TouristSpot spot;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DetailScreen({
    super.key,
    required this.spot,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });
  // function for url launcher map
  Future<void> _openGoogleMaps(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
      body: ListView(
        children: [
          Image.network(
            spot.photos.isNotEmpty
                ? spot.photos[0]
                : 'https://via.placeholder.com/400',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spot.name,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    spot.category,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.teal,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${spot.barangay}, ${spot.municipality}, ${spot.province}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Region: ${spot.region}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                Text(spot.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Text(
                  '📍 Latitude: ${spot.lat}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  '📍 Longitude: ${spot.lng}',
                  style: const TextStyle(color: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openGoogleMaps(spot.lat, spot.lng),
                  icon: const Icon(Icons.map),
                  label: const Text("Open in Google Maps"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
