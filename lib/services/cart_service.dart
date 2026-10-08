import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _items {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    return _db.collection('users').doc(uid).collection('cart');
  }

  Future<void> add({required String productId, required String title, required double price, int quantity = 1}) async {
    if (quantity < 1) throw Exception('مقدار ناسم دی.');
    final ref = _items.doc(productId);
    final existing = await ref.get();
    final old = (existing.data()?['quantity'] as num?)?.toInt() ?? 0;
    await ref.set({'productId': productId, 'title': title, 'price': price, 'quantity': old + quantity, 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> remove(String productId) => _items.doc(productId).delete();
  Stream<QuerySnapshot<Map<String, dynamic>>> stream() => _items.snapshots();
}
