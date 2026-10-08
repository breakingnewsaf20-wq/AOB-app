class Product {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String city;
  final String categoryId;
  final List<String> imageUrls;
  final bool approved;

  const Product({required this.id, required this.sellerId, required this.title, required this.description, required this.price, required this.stock, required this.city, required this.categoryId, required this.imageUrls, required this.approved});

  Map<String, dynamic> toMap() => {'sellerId': sellerId, 'title': title, 'description': description, 'price': price, 'stock': stock, 'city': city, 'categoryId': categoryId, 'imageUrls': imageUrls, 'approved': approved};

  factory Product.fromMap(String id, Map<String, dynamic> m) => Product(id: id, sellerId: m['sellerId'] ?? '', title: m['title'] ?? '', description: m['description'] ?? '', price: (m['price'] as num?)?.toDouble() ?? 0, stock: (m['stock'] as num?)?.toInt() ?? 0, city: m['city'] ?? '', categoryId: m['categoryId'] ?? '', imageUrls: List<String>.from(m['imageUrls'] ?? const []), approved: m['approved'] == true);
}
