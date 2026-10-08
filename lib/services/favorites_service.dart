import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _ref(String productId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    return _db.collection('users').doc(uid).collection('favorites').doc(productId);
  }

  Future<void> setFavorite(String productId, bool value) async {
    final ref = _ref(productId);
    if (value) {
      await ref.set({'productId': productId, 'createdAt': FieldValue.serverTimestamp()});
    } else {
      await ref.delete();
    }
  }

  Stream<bool> isFavorite(String productId) => _ref(productId).snapshots().map((d) => d.exists);
}
