import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final email=TextEditingController(), password=TextEditingController(); bool loading=false;
  Future<void> submit() async { setState(()=>loading=true); try { await AuthService.instance.login(email: email.text, password: password.text); } catch(e) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ننوتل ناکام شو: ${e.toString()}'))); } finally { if(mounted)setState(()=>loading=false); } }
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Afghan Online Bazaar')),body:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email')),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password')),const SizedBox(height:20),FilledButton(onPressed:loading?null:submit,child:Text(loading?'مهرباني...':'ننوتل')),TextButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RegisterScreen())),child:const Text('نوی حساب جوړول'))]));
}
