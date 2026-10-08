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

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen>{ String role='customer'; bool loading=true; String query='';
@override void initState(){super.initState(); load();}
Future<void> load() async { try { final r=await AuthService.instance.getRole(); if(mounted)setState(()=>role=r); } finally { if(mounted)setState(()=>loading=false); } }
@override Widget build(BuildContext c){ final s=LanguageScope.of(c); if(loading)return const Scaffold(body:Center(child:CircularProgressIndicator())); return Scaffold(appBar:AppBar(title:Text(s.tr('appName')),actions:[IconButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const CartScreen())),icon:const Icon(Icons.shopping_cart),tooltip:s.tr('cart')),IconButton(onPressed:()=>AuthService.instance.logout(),icon:const Icon(Icons.logout),tooltip:s.tr('logout'))]),drawer:Drawer(child:ListView(children:[DrawerHeader(child:Text(s.tr('appName'),style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold))),ListTile(leading:const Icon(Icons.home),title:Text(s.tr('home')),onTap:()=>Navigator.pop(c)),ListTile(leading:const Icon(Icons.language),title:Text(s.tr('language')),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const LanguageScreen()))),if(role=='seller')ListTile(leading:const Icon(Icons.store),title:Text(s.tr('sellerDashboard')),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const SellerDashboard()))),if(role=='admin')ListTile(leading:const Icon(Icons.admin_panel_settings),title:Text(s.tr('adminPanel')),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const AdminDashboard()))) ]),body:Column(children:[Padding(padding:const EdgeInsets.all(12),child:TextField(onChanged:(v)=>setState(()=>query=v.trim().toLowerCase()),decoration:InputDecoration(prefixIcon:const Icon(Icons.search),labelText:s.tr('search'),border:const OutlineInputBorder()))),Expanded(child:StreamBuilder<List<Product>>(stream:ProductService().approvedProducts(),builder:(c,snap){if(!snap.hasData)return const Center(child:CircularProgressIndicator()); final p=snap.data!.where((x)=>query.isEmpty||x.title.toLowerCase().contains(query)||x.city.toLowerCase().contains(query)||x.categoryId.toLowerCase().contains(query)).toList(); if(p.isEmpty)return Center(child:Text(s.tr('noProducts'))); return ListView.builder(itemCount:p.length,itemBuilder:(c,i)=>Card(child:ListTile(leading:p[i].imageUrls.isNotEmpty?Image.network(p[i].imageUrls.first,width:56,height:56,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Icon(Icons.image)):const Icon(Icons.image),title:Text(p[i].title),subtitle:Text('${p[i].price.toStringAsFixed(0)} AFN • ${p[i].city}'),trailing:Text('${s.tr('stock')}: ${p[i].stock}'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>ProductDetailsScreen(product:p[i])))));}))]);}
}
