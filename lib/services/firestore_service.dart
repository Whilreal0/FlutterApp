import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourist_spot.dart';

class FirestoreService {
  final _spots = FirebaseFirestore.instance.collection('spots');

  Stream<List<TouristSpot>> getSpots() {
    return _spots.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TouristSpot.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
