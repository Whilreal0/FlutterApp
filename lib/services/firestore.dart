import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/elyu_spot.dart';

/// 🔍 Fetches top tourist spots—one per municipality (up to [limit]).
/// Used for hero carousel or highlights on the home screen.
Future<List<Map<String, dynamic>>> getTopSpotsFromDocuments({int limit = 3}) async {
  final elyuCollection = FirebaseFirestore.instance.collection('elyu');
  final municipalityDocs = await elyuCollection.get();

  final spots = <Map<String, dynamic>>[];

  for (final municipalityDoc in municipalityDocs.docs.take(limit)) {
    // print('🏘️ Municipality: ${municipalityDoc.id}');

    final touristSpotsCollection = municipalityDoc.reference.collection('tourist_spots');
    final touristSpotsSnapshot = await touristSpotsCollection.get();

    if (touristSpotsSnapshot.docs.isNotEmpty) {
      for (final spotDoc in touristSpotsSnapshot.docs) {
        final spotData = spotDoc.data();
        final photos = spotData['photos'];

        if (photos != null && photos is List && photos.isNotEmpty) {
          final firstPhoto = photos.first;
          final imageUrl = firstPhoto['url'];

          if (imageUrl != null && imageUrl is String && imageUrl.isNotEmpty) {
            spots.add({
              'name': spotData['name'] ?? spotDoc.id,
              'photo': imageUrl,
            });
            // print('✅ Added spot: ${spotData['name']} from ${municipalityDoc.id}');
            break; // Only one spot per municipality
          }
        } else {
          // print('🚫 Skipped ${spotData['name'] ?? 'unknown'} — no valid photos.');
        }
      }
    } else {
      // print('⚠️ No tourist spots found in ${municipalityDoc.id}');
    }
  }

  // print('👉 Total selected spots for carousel: ${spots.length}');
  return spots;
}

/// 🔥 Centralized Firestore service class to stream tourist spots across all municipalities.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 📡 Streams ALL tourist spots from ALL municipalities using `collectionGroup`.
  /// This allows real-time updates from nested subcollections: `elyu/{municipality}/tourist_spots`
  Stream<List<TouristSpot>> getAllTouristSpots() {
    // print('🚀 Listening to all tourist spots via collectionGroup...');
    return _db.collectionGroup('tourist_spots').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final municipality = doc.reference.parent.parent?.id ?? 'Unknown';

        try {
          final spot = TouristSpot.fromMap(
            data,
            municipality: municipality,
            id: doc.id,
          );
          // print('📥 [Group] ${spot.name} (${spot.id}) from $municipality');
          return spot;
        } catch (e) {
          // print('❌ Error parsing tourist spot from $municipality: $e');
          return null;
        }
      }).whereType<TouristSpot>().toList();
    });
  }

  /// 🧭 Legacy fallback: Streams spots by iterating each document inside [collection]
  /// e.g., 'elyu' → iterate municipalities → subcollection('tourist_spots')
  Stream<List<TouristSpot>> getSpots(String collection) {
    // print('📡 Fetching spots from collection: $collection');

    return _db.collection(collection).snapshots().asyncMap((snapshot) async {
      List<TouristSpot> allSpots = [];

      for (var doc in snapshot.docs) {
        final municipalityId = doc.id;
        // print('🔎 Reading spots from: $municipalityId');

        final spotSnapshot = await _db
            .collection(collection)
            .doc(municipalityId)
            .collection('tourist_spots') // ✅ fixed name
            .get();

        for (var spotDoc in spotSnapshot.docs) {
          final data = spotDoc.data();
          try {
            final spot = TouristSpot.fromMap(
              data,
              municipality: municipalityId,
              id: spotDoc.id,
            );
            allSpots.add(spot);
            // print('✅ Added: ${spot.name} (${spot.id}) from $municipalityId');
          } catch (e) {
            // print('⚠️ Error parsing spot from $municipalityId: $e');
          }
        }
      }

      // print('📦 Total spots loaded: ${allSpots.length}');
      return allSpots;
    });
  }
}
