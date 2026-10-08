import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = LanguageScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tr('cart'))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: CartService().stream(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? const [];
          if (docs.isEmpty) return Center(child: Text(s.tr('cartEmpty')));
          double subtotal = 0;
          for (final d in docs) subtotal += ((d.data()['price'] as num?)?.toDouble() ?? 0) * ((d.data()['quantity'] as num?)?.toInt() ?? 0);
          return Column(children: [
            Expanded(child: ListView(children: docs.map((d) {
              final m = d.data();
              final q = (m['quantity'] as num?)?.toInt() ?? 0;
              final price = (m['price'] as num?)?.toDouble() ?? 0;
              return ListTile(title: Text((m['title'] ?? '') as String), subtitle: Text('$price AFN × $q'), trailing: IconButton(onPressed: () => CartService().remove(d.id), icon: const Icon(Icons.delete_outline)));
            }).toList())),
            Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text('${s.tr('subtotal')}: ${subtotal.toStringAsFixed(0)} AFN'), const SizedBox(height: 8), FilledButton(onPressed: () => _checkout(context, docs, subtotal), child: Text(s.tr('checkout')))])),
          ]);
        },
      ),
    );
  }

  Future<void> _checkout(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, double subtotal) async {
    final s = LanguageScope.of(context);
    final address = TextEditingController();
    final phone = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: Text(s.tr('checkout')), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: address, decoration: InputDecoration(labelText: s.tr('address'))), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: s.tr('phone')))]), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.tr('cancel'))), FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.tr('save')))]));
    if (ok != true || !context.mounted) return;
    final items = docs.map((d) => {'productId': d.id, 'title': d.data()['title'], 'price': d.data()['price'], 'quantity': d.data()['quantity']}).toList();
    try {
      await OrderService().createOrder(items: items, subtotal: subtotal, deliveryFee: 0, address: address.text, phone: phone.text);
      for (final d in docs) await CartService().remove(d.id);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.tr('orderCreated'))));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
