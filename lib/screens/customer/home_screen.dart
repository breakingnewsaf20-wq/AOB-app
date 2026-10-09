import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';
import '../seller/seller_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../settings/language_screen.dart';
import '../product/product_details_screen.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String role = 'customer';
  bool loading = true;
  String query = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final r = await AuthService.instance.getRole();
      if (mounted) {
        setState(() => role = r);
      }
    } catch (_) {
      // Keep the default customer role if loading fails.
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = LanguageScope.of(context);

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(s.tr('appName')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () => AuthService.instance.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                s.tr('appName'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(s.tr('home')),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(s.tr('language')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LanguageScreen(),
                  ),
                );
              },
            ),
            if (role == 'seller')
              ListTile(
                leading: const Icon(Icons.store),
                title: Text(s.tr('sellerDashboard')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerDashboard(),
                    ),
                  );
                },
              ),
            if (role == 'admin')
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: Text(s.tr('adminPanel')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboard(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) {
                setState(() => query = v.trim().toLowerCase());
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: s.tr('search'),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: ProductService().approvedProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data!.where((product) {
                  return query.isEmpty ||
                      product.title.toLowerCase().contains(query) ||
                      product.city.toLowerCase().contains(query) ||
                      product.categoryId.toLowerCase().contains(query);
                }).toList();

                if (products.isEmpty) {
                  return Center(
                    child: Text(s.tr('noProducts')),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Card(
                      child: ListTile(
                        leading: product.imageUrls.isNotEmpty
                            ? Image.network(
                                product.imageUrls.first,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image),
                              )
                            : const Icon(Icons.image),
                        title: Text(product.title),
                        subtitle: Text(
                          '${product.price.toStringAsFixed(0)} AFN • ${product.city}',
                        ),
                        trailing: Text(
                          '${s.tr('stock')}: ${product.stock}',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                product: product,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
