import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MunicipalityListScreen extends StatefulWidget {
  final String municipality;

  const MunicipalityListScreen({super.key, required this.municipality});

  @override
  State<MunicipalityListScreen> createState() => _MunicipalityListScreenState();
}

class _MunicipalityListScreenState extends State<MunicipalityListScreen> {
  bool _didPrecache = false;

  Future<void> _precache(Map<String, dynamic> data) async {
    if (_didPrecache) return;
    _didPrecache = true;

    final urls = <String>[];

    final headerUrl = data['photo'] as String?;
    if (headerUrl != null && headerUrl.isNotEmpty) {
      urls.add(headerUrl);
    }

    if (data['tourist_spots'] != null) {
      for (final spot in List<Map<String, dynamic>>.from(data['tourist_spots'])) {
        if (spot['photos'] != null &&
            spot['photos'].isNotEmpty &&
            spot['photos'][0]['url'] != null) {
          urls.add(spot['photos'][0]['url']);
        }
      }
    }

    for (final url in urls) {
      await precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('elyu')
        .doc(widget.municipality);

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Municipality data not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          _precache(data);

          final headerUrl = data['photo'] ??
              'https://via.placeholder.com/600x300?text=${Uri.encodeComponent(widget.municipality)}';

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Image with overlay and back button
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: headerUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 240,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        errorWidget: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image)),
                      ),
                      Positioned.fill(
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0.3),
                          child: Text(
                            widget.municipality,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['description'] != null)
                          Text(data['description'], style: const TextStyle(fontSize: 16)),

                        const SizedBox(height: 12),

                        if (data['history'] != null) ...[
                          Text('History',
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(data['history']),
                          const SizedBox(height: 12),
                        ],

                        if (data['classification'] != null)
                          Text('Classification: ${data['classification']}'),
                        if (data['barangay_count'] != null)
                          Text('Barangays: ${data['barangay_count']}'),
                        if (data['population'] != null)
                          Text('Population: ${data['population']}'),

                        const SizedBox(height: 12),

                        if (data['festivals'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Festivals',
                                  style: Theme.of(context).textTheme.titleMedium),
                              ...List<String>.from(data['festivals'])
                                  .map((f) => Text('• $f')),
                            ],
                          ),

                        const SizedBox(height: 12),

                        if (data['specialties'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Specialties',
                                  style: Theme.of(context).textTheme.titleMedium),
                              ...List<String>.from(data['specialties'])
                                  .map((s) => Text('• $s')),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
