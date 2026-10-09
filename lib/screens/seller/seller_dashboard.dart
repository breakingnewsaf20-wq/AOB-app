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
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image);
                        },
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

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final cityController = TextEditingController();
  final categoryController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final ImageService imageService = ImageService();

  final List<XFile> selectedImages = [];

  bool loading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    cityController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    try {
      final images = await picker.pickMultiImage(
        imageQuality: 85,
      );

      if (!mounted || images.isEmpty) return;

      setState(() {
        selectedImages.addAll(images);
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('د عکس ټاکلو ستونزه: $error')),
      );
    }
  }

  Future<void> saveProduct() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final imageUrls = <String>[];

      for (final image in selectedImages) {
        final url = await imageService.upload(
          File(image.path),
        );
        imageUrls.add(url);
      }

      await ProductService().addProduct(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0,
        stock: int.tryParse(stockController.text) ?? -1,
        city: cityController.text.trim(),
        categoryId: categoryController.text.trim(),
        imageUrls: imageUrls,
      );

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('محصول په بریالیتوب ثبت شو.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ستونزه: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = LanguageScope.of(context);

    return AlertDialog(
      title: Text(s.tr('newProduct')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: s.tr('productName'),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: s.tr('description'),
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${s.tr('price')} AFN',
              ),
            ),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: s.tr('stock'),
              ),
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: s.tr('city'),
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: s.tr('category'),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: loading ? null : pickImages,
              icon: const Icon(Icons.photo_library),
              label: Text(
                '${s.tr('imageUpload')} (${selectedImages.length})',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(s.tr('cancel')),
        ),
        FilledButton(
          onPressed: loading ? null : saveProduct,
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(s.tr('save')),
        ),
      ],
    );
  }
}
