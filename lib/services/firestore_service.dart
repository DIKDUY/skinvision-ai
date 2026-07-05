import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> saveDiagnosis({
    required String userId,
    required String disease,
    required double confidence,
    required String imageUrl,
  }) async {
    await _firestore.collection('diagnosis').add({
      'userId': userId,
      'disease': disease,
      'confidence': confidence,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }
}