class TouristSpot {
  final String id;
  final String name;
  final String description;
  final String province;
  final double lat;
  final double lng;
  final List<String> photos;

  TouristSpot({
    required this.id,
    required this.name,
    required this.description,
    required this.province,
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
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      photos: List<String>.from(data['photos'] ?? []),
    );
  }
}
