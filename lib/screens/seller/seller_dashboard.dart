import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/product_service.dart';
import '../../services/image_service.dart';
import '../../l10n/app_strings.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});
  @override
  Widget build(BuildContext c) {
    final s = LanguageScope.of(c);
    return Scaffold(
      appBar: AppBar(title: Text(s.tr('sellerDashboard'))),
      floatingActionButton: FloatingActionButton(onPressed: () => showDialog(context: c, builder: (_) => const AddProductDialog()), child: const Icon(Icons.add)),
      body: StreamBuilder(
        stream: ProductService().myProducts(),
        builder: (c, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          if (list.isEmpty) return Center(child: Text(s.tr('noProducts')));
          return ListView.builder(itemCount: list.length, itemBuilder: (c, i) => ListTile(title: Text(list[i].title), subtitle: Text('${list[i].price.toStringAsFixed(0)} AFN'), trailing: Text(list[i].approved ? s.tr('approved') : s.tr('pending'))));
        },
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});
  @override State<AddProductDialog> createState() => _AddProductDialogState();
}
class _AddProductDialogState extends State<AddProductDialog> {
  final t=TextEditingController(), d=TextEditingController(), p=TextEditingController(), st=TextEditingController(), city=TextEditingController(), cat=TextEditingController();
  final picker = ImagePicker(); final imageService = ImageService();
  final List<XFile> selected = []; final List<String> urls=[]; bool loading=false;

  Future<void> pickImages() async { final files=await picker.pickMultiImage(imageQuality: 85); if(files.isNotEmpty)setState(()=>selected.addAll(files)); }
  Future<void> save() async {
    setState(()=>loading=true);
    try {
      for(final f in selected) urls.add(await imageService.upload(File(f.path)));
      await ProductService().addProduct(title:t.text,description:d.text,price:double.tryParse(p.text)??0,stock:int.tryParse(st.text)??-1,city:city.text,categoryId:cat.text,imageUrls:urls);
      if(mounted)Navigator.pop(context);
    } catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString())));} finally{if(mounted)setState(()=>loading=false);}
  }
  @override Widget build(BuildContext c){final s=LanguageScope.of(c);return AlertDialog(title:Text(s.tr('newProduct')),content:SingleChildScrollView(child:Column(children:[TextField(controller:t,decoration:InputDecoration(labelText:s.tr('productName'))),TextField(controller:d,decoration:InputDecoration(labelText:s.tr('description'))),TextField(controller:p,keyboardType:TextInputType.number,decoration:InputDecoration(labelText:'${s.tr('price')} AFN')),TextField(controller:st,keyboardType:TextInputType.number,decoration:InputDecoration(labelText:s.tr('stock'))),TextField(controller:city,decoration:InputDecoration(labelText:s.tr('city'))),TextField(controller:cat,decoration:InputDecoration(labelText:s.tr('category'))),const SizedBox(height:10),OutlinedButton.icon(onPressed:loading?null:pickImages,icon:const Icon(Icons.photo_library),label:Text('${s.tr('imageUpload')} (${selected.length})'))])),actions:[TextButton(onPressed:loading?null:()=>Navigator.pop(context),child:Text(s.tr('cancel'))),FilledButton(onPressed:loading?null:save,child:Text(loading?s.tr('pleaseWait'):s.tr('save')))]);}
}
