import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/product_service.dart';
import '../../services/image_service.dart';
import '../../l10n/app_strings.dart';
import '../../models/product.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = LanguageScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.tr('sellerDashboard')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) => const AddProductDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Product>>(
        stream: ProductService().myProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('د محصولاتو په ترلاسه کولو کې ستونزه ده.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data ?? <Product>[];

          if (products.isEmpty) {
            return Center(
              child: Text(s.tr('noProducts')),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: product.imageUrls.isNotEmpty
                    ? Image.network(
                        product.imageUrls.first,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                      )
                    : const Icon(Icons.image),
                title: Text(product.title),
                subtitle: Text(
                  '${product.price.toStringAsFixed(0)} AFN',
                ),
                trailing: Text(
                  product.approved
                      ? s.tr('approved')
                      : s.tr('pending'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
