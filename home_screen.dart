import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';
import '../seller/seller_dashboard.dart';
import '../admin/admin_dashboard.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen>{ String role='customer'; bool loading=true;
@override void initState(){super.initState(); load();}
Future<void> load() async { final r=await AuthService.instance.getRole(); if(mounted)setState(()=>role=r); setState(()=>loading=false); }
@override Widget build(BuildContext c){ if(loading)return const Scaffold(body:Center(child:CircularProgressIndicator())); return Scaffold(appBar:AppBar(title:const Text('Afghan Online Bazaar'),actions:[IconButton(onPressed:()=>AuthService.instance.logout(),icon:const Icon(Icons.logout))]),drawer:Drawer(child:ListView(children:[const DrawerHeader(child:Text('Afghan Online Bazaar',style:TextStyle(fontSize:20))),if(role=='seller')ListTile(title:const Text('Seller Dashboard'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const SellerDashboard()))),if(role=='admin')ListTile(title:const Text('Admin Panel'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const AdminDashboard()))) ]),body:StreamBuilder<List<Product>>(stream:ProductService().approvedProducts(),builder:(c,s){if(!s.hasData)return const Center(child:CircularProgressIndicator()); final p=s.data!; if(p.isEmpty)return const Center(child:Text('تر اوسه محصول نشته.')); return ListView.builder(itemCount:p.length,itemBuilder:(c,i)=>Card(child:ListTile(title:Text(p[i].title),subtitle:Text('${p[i].price.toStringAsFixed(0)} AFN • ${p[i].city}'),trailing:Text('Stock: ${p[i].stock}'))));}));}
}
