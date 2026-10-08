import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> createOrder({required List<Map<String, dynamic>> items, required double subtotal, required double deliveryFee, required String address, required String phone}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    if (items.isEmpty) throw Exception('سفارش کې محصول نشته.');
    if (address.trim().isEmpty) throw Exception('د سپارلو پته اړینه ده.');
    if (phone.trim().isEmpty) throw Exception('د اړیکې شمېره اړینه ده.');
    final total = subtotal + deliveryFee;
    final ref = await _db.collection('orders').add({
      'customerId': uid,
      'items': items,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'address': address.trim(),
      'phone': phone.trim(),
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> myOrders() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _db.collection('orders').where('customerId', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots();
  }
}
