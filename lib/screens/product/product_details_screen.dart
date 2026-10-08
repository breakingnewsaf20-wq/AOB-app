import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';
import '../../services/favorites_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final s = LanguageScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (product.imageUrls.isNotEmpty)
            SizedBox(height: 230, child: PageView(children: product.imageUrls.map((u) => Image.network(u, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 80))).toList()))
          else
            const SizedBox(height: 180, child: Icon(Icons.image, size: 80)),
          const SizedBox(height: 16),
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${product.price.toStringAsFixed(0)} AFN', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('${s.tr('city')}: ${product.city}'),
          Text('${s.tr('stock')}: ${product.stock}'),
          const SizedBox(height: 16),
          Text(product.description),
          const SizedBox(height: 20),
          Row(children: [
            StreamBuilder<bool>(
              stream: FavoritesService().isFavorite(product.id),
              builder: (_, snap) => IconButton(
                onPressed: () => FavoritesService().setFavorite(product.id, !(snap.data ?? false)),
                icon: Icon(snap.data == true ? Icons.favorite : Icons.favorite_border),
              ),
            ),
            Expanded(child: FilledButton.icon(
              onPressed: product.stock <= 0 ? null : () async {
                await CartService().add(productId: product.id, title: product.title, price: product.price);
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.tr('addToCart'))));
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text(s.tr('addToCart')),
            )),
          ]),
        ],
      ),
    );
  }
}
