class TouristSpot {
  final String id;
  final String name;
  final String description;
  final String province;
  final String region;
  final String municipality;
  final String barangay;
  final String category;
  final double lat;
  final double lng;
  final List<String> photos;

  TouristSpot({
    required this.id,
    required this.name,
    required this.description,
    required this.province,
    required this.region,
    required this.municipality,
    required this.barangay,
    required this.category,
    required this.lat,
    required this.lng,
    required this.photos,
  });

  factory TouristSpot.fromMap(String id, Map<String, dynamic> data) {
    return TouristSpot(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      province: data['province'] ?? '',
      region: data['region'] ?? '',
      municipality: data['municipality'] ?? '',
      barangay: data['barangay'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      photos: List<String>.from(data['photos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'province': province,
      'region': region,
      'municipality': municipality,
      'barangay': barangay,
      'category': category,
      'lat': lat,
      'lng': lng,
      'photos': photos,
    };
  }
}
