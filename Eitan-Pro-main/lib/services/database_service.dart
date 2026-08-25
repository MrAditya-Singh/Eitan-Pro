import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a member (Join Community)
  Future<void> addMember(String name, String email, {String? uid}) async {
    await _db.collection('members').add({
      'uid': uid,
      'name': name,
      'email': email,
      'timestamp': FieldValue.serverTimestamp(),
      'level': 'Premium Member',
    });
  }

  // Get all recipes
  Stream<List<Map<String, dynamic>>> get recipes {
    return _db.collection('recipes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }
}
