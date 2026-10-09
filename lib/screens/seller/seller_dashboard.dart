import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/product_service.dart';
import '../../services/image_service.dart';
import '../../l10n/app_strings.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = LanguageScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.tr('sellerDashboard')),
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
      body: StreamBuilder(
        stream: ProductService().myProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('د محصولاتو په ترلاسه کولو کې ستونزه ده.'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return Center(
              child: Text(strings.tr('noProducts')),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                title: Text(product.title),
                subtitle: Text(
                  '${product.price.toStringAsFixed(0)} AFN',
                ),
                trailing: Text(
                  product.approved
                      ? strings.tr('approved')
                      : strings.tr('pending'),
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

  final picker = ImagePicker();
  final imageService = ImageService();

  final List<XFile> selectedImages = [];
  bool loading = false;

  Future<void> pickImages() async {
    final files = await picker.pickMultiImage(imageQuality: 85);

    if (!mounted || files.isEmpty) return;

    setState(() {
      selectedImages.addAll(files);
    });
  }

  Future<void> saveProduct() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final imageUrls = <String>[];

      for (final image in selectedImages) {
        imageUrls.add(
          await imageService.upload(File(image.path)),
        );
      }

      await ProductService().addProduct(
        title: titleController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? 0,
        stock: int.tryParse(stockController.text) ?? -1,
        city: cityController.text,
        categoryId: categoryController.text,
        imageUrls: imageUrls,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final strings = LanguageScope.of(context);

    return AlertDialog(
      title: Text(strings.tr('newProduct')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: strings.tr('productName'),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: strings.tr('description'),
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${strings.tr('price')} AFN',
              ),
            ),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: strings.tr('stock'),
              ),
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: strings.tr('city'),
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: strings.tr('category'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: loading ? null : pickImages,
              icon: const Icon(Icons.photo_library),
              label: Text(
                '${strings.tr('imageUpload')} '
                '(${selectedImages.length})',
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
          child: Text(strings.tr('cancel')),
        ),
        FilledButton(
          onPressed: loading ? null : saveProduct,
          child: Text(
            loading
                ? strings.tr('pleaseWait')
                : strings.tr('save'),
          ),
        ),
      ],
    );
  }
}
