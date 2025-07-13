import 'package:cloud_firestore/cloud_firestore.dart';

/// 📍 Main model representing a Municipality in La Union
class ElyuSpot {
  final String name; // From document ID
  final String description;
  final String history;
  final String classification;
  final int population;
  final int barangayCount;
  final double lat;
  final double lng;
  final List<String> festivals;
  final List<String> specialties;
  final List<TouristSpot> touristSpots;

  ElyuSpot({
    required this.name,
    required this.description,
    required this.history,
    required this.classification,
    required this.population,
    required this.barangayCount,
    required this.lat,
    required this.lng,
    required this.festivals,
    required this.specialties,
    required this.touristSpots,
  });

  /// 🏘️ Parses municipality document and embedded tourist spots
  factory ElyuSpot.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // 👇 tourist_spots embedded as inline list of maps
    final spotsList = data['tourist_spots'] as List<dynamic>? ?? [];
    final touristSpots = spotsList.map((spot) {
      final spotData = spot as Map<String, dynamic>;
      return TouristSpot.fromMap(spotData, municipality: doc.id, id: spotData['id'] ?? '');
    }).toList();

    return ElyuSpot(
      name: doc.id,
      description: data['description'] ?? '',
      history: data['history'] ?? '',
      classification: data['classification'] ?? '',
      population: data['population'] ?? 0,
      barangayCount: data['barangay_count'] ?? 0,
      lat: (data['lat'] ?? 0.0).toDouble(),
      lng: (data['lng'] ?? 0.0).toDouble(),
      festivals: List<String>.from(data['festivals'] ?? []),
      specialties: List<String>.from(data['specialties'] ?? []),
      touristSpots: touristSpots,
    );
  }
}

/// 🌄 Submodel for individual tourist spots inside municipalities
class TouristSpot {
  final String id;              // 🔑 Unique Firestore doc ID
  final String name;
  final String description;
  final String barangay;
  final double lat;
  final double lng;
  final List<String> photos;
  final List<String> categories; // ✅ CHANGED: support multiple categories
  final String municipality;   // 🏘️ Municipality it belongs to

  TouristSpot({
    required this.id,
    required this.name,
    required this.description,
    required this.barangay,
    required this.lat,
    required this.lng,
    required this.photos,
    required this.categories, // ✅ CHANGED
   
    required this.municipality,
  });

  /// 🔁 Factory to parse a Firestore map into TouristSpot
  factory TouristSpot.fromMap(
    Map<String, dynamic> map, {
    required String municipality,
    required String id,
  }) {
    final rawPhotos = map['photos'] as List<dynamic>? ?? [];
    final photoUrls = rawPhotos
        .map((photoMap) {
          if (photoMap is Map<String, dynamic>) {
            return photoMap['url'] ?? '';
          }
          return '';
        })
        .where((url) => url.isNotEmpty)
        .cast<String>()
        .toList();

    return TouristSpot(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      barangay: map['barangay'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
       categories: List<String>.from(map['categories'] ?? []), // ✅ CHANGED
      photos: photoUrls,
      municipality: municipality,
    );
  }
}
