import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AiDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Recipes (Curated) ---
  
  Future<void> addCuratedRecipe(Map<String, dynamic> recipeHeader, Map<String, dynamic> foodDetails) async {
    // 1. Create the recipe header
    DocumentReference recipeRef = await _db.collection('recipes').add({
      ...recipeHeader,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Add the detailed food subcollection document
    await recipeRef.collection('food').add({
      ...foodDetails,
      'createdAt': FieldValue.serverTimestamp(),
      'aiGenerated': false,
      'version': '1.0',
    });
  }

  // --- Generated Food (AI Output) ---

  Future<String> saveAiGeneratedRecipe(Map<String, dynamic> foodData, {required List<String> sourceIngredients, String? prompt}) async {
    final user = FirebaseAuth.instance.currentUser;
    
    DocumentReference docRef = await _db.collection('generatedfood').add({
      ...foodData,
      'userId': user?.uid,
      'sourceIngredients': sourceIngredients,
      'aiPromptUsed': prompt,
      'modelVersion': 'gemini-1.5-flash',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    return docRef.id;
  }

  // --- User Profiles & Pantry ---

  Future<void> createUserProfile(User user, {String? name}) async {
    await _db.collection('users').doc(user.uid).set({
      'name': name ?? user.displayName ?? 'Chef',
      'email': user.email,
      'preferences': {
        'theme': 'dark',
        'notifications': true,
      },
      'dietaryRestrictions': [],
      'savedRecipes': [],
      'proUser': false,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updatePantryItem(String userId, String itemId, Map<String, dynamic> itemData) async {
    await _db.collection('users')
        .doc(userId)
        .collection('pantry')
        .doc(itemId)
        .set(itemData, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> getPantry(String userId) {
    return _db.collection('users')
        .doc(userId)
        .collection('pantry')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // --- Queries ---

  Stream<QuerySnapshot> getCuratedRecipes() {
    return _db.collection('recipes').orderBy('createdAt', descending: true).snapshots();
  }

  Future<List<Map<String, dynamic>>> getFoodDetails(String recipeId) async {
    QuerySnapshot snapshot = await _db.collection('recipes').doc(recipeId).collection('food').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
