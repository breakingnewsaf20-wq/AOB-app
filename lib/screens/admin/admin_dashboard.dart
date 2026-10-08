import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext c) {
    final s = LanguageScope.of(c);
    return Scaffold(
      appBar: AppBar(title: Text(s.tr('adminPanel'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(s.tr('management'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _Count(title: s.tr('users'), query: FirebaseFirestore.instance.collection('users')),
          _Count(title: s.tr('products'), query: FirebaseFirestore.instance.collection('products')),
          _Count(title: s.tr('orders'), query: FirebaseFirestore.instance.collection('orders')),
          const SizedBox(height: 20),
          Text(s.tr('pendingProducts'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('products').where('approved', isEqualTo: false).snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final docs = snap.data?.docs ?? const [];
              if (docs.isEmpty) return Padding(padding: const EdgeInsets.all(16), child: Text(s.tr('noPendingProducts')));
              return Column(children: docs.map((d) => Card(
                child: ListTile(
                  title: Text((d.data()['title'] ?? '') as String),
                  subtitle: Text('${d.data()['price'] ?? 0} AFN'),
                  trailing: FilledButton(
                    onPressed: () => FirebaseFirestore.instance.collection('products').doc(d.id).update({'approved': true}),
                    child: Text(s.tr('approve')),
                  ),
                ),
              )).toList());
            },
          ),
        ],
      ),
    );
  }
}

class _Count extends StatelessWidget {
  final String title;
  final Query<Map<String, dynamic>> query;
  const _Count({required this.title, required this.query});
  @override
  Widget build(BuildContext c) => Card(
    child: ListTile(
      title: Text(title),
      trailing: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: query.snapshots(), builder: (c, s) => Text('${s.data?.docs.length ?? 0}')),
    ),
  );
}
