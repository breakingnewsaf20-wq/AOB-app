import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Product>> approvedProducts() => _db.collection('products').where('approved', isEqualTo: true).snapshots().map(
        (s) => s.docs.map((d) => Product.fromMap(d.id, d.data())).toList(),
      );

  Stream<List<Product>> myProducts() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _db.collection('products').where('sellerId', isEqualTo: uid).snapshots().map(
          (s) => s.docs.map((d) => Product.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<String> addProduct({required String title, required String description, required double price, required int stock, required String city, required String categoryId, List<String> imageUrls = const []}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    if (title.trim().isEmpty) throw Exception('د محصول نوم ولیکه.');
    if (price <= 0) throw Exception('قیمت باید له صفر څخه زیات وي.');
    if (stock < 0) throw Exception('موجودي ناسم ده.');
    if (city.trim().isEmpty) throw Exception('ښار ولیکه.');
    if (categoryId.trim().isEmpty) throw Exception('کټګوري ولیکه.');
    final ref = await _db.collection('products').add(Product(
      id: '', sellerId: uid, title: title.trim(), description: description.trim(), price: price,
      stock: stock, city: city.trim(), categoryId: categoryId.trim(), imageUrls: imageUrls, approved: false,
    ).toMap());
    return ref.id;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    final ref = _db.collection('products').doc(id);
    final snap = await ref.get();
    if (!snap.exists || snap.data()?['sellerId'] != uid) throw Exception('دا محصول ستا نه دی.');
    await ref.update({...data, 'approved': false});
  }

  Future<void> deleteProduct(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    final ref = _db.collection('products').doc(id);
    final snap = await ref.get();
    if (!snap.exists || snap.data()?['sellerId'] != uid) throw Exception('دا محصول ستا نه دی.');
    await ref.delete();
  }
}
