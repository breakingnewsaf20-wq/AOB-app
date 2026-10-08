import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Product>> approvedProducts() => _db.collection('products').where('approved', isEqualTo: true).snapshots().map((s) => s.docs.map((d) => Product.fromMap(d.id, d.data())).toList());

  Stream<List<Product>> myProducts() {
    final uid = _auth.currentUser!.uid;
    return _db.collection('products').where('sellerId', isEqualTo: uid).snapshots().map((s) => s.docs.map((d) => Product.fromMap(d.id, d.data())).toList());
  }

  Future<void> addProduct({required String title, required String description, required double price, required int stock, required String city, required String categoryId, List<String> imageUrls = const []}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('کاروونکی ننوتی نه دی.');
    if (title.trim().isEmpty) throw Exception('د محصول نوم ولیکه.');
    if (price <= 0) throw Exception('قیمت باید له صفر څخه زیات وي.');
    if (stock < 0) throw Exception('Stock ناسم دی.');
    await _db.collection('products').add(Product(id: '', sellerId: uid, title: title.trim(), description: description.trim(), price: price, stock: stock, city: city.trim(), categoryId: categoryId.trim(), imageUrls: imageUrls, approved: false).toMap());
  }
}
