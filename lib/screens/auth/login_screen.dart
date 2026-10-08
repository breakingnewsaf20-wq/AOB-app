import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final email=TextEditingController(), password=TextEditingController(); bool loading=false;
  Future<void> submit() async {
    final s=LanguageScope.of(context);
    if(email.text.trim().isEmpty || password.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(s.tr('fillRequired')))); return; }
    setState(()=>loading=true);
    try { await AuthService.instance.login(email: email.text, password: password.text); }
    catch(e) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s.tr('loginFailed')}: ${e.toString()}'))); }
    finally { if(mounted)setState(()=>loading=false); }
  }
  @override Widget build(BuildContext context){ final s=LanguageScope.of(context); return Scaffold(appBar:AppBar(title:Text(s.tr('appName'))),body:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:InputDecoration(labelText:s.tr('email'))),TextField(controller:password,obscureText:true,decoration:InputDecoration(labelText:s.tr('password'))),const SizedBox(height:20),FilledButton(onPressed:loading?null:submit,child:Text(loading?s.tr('pleaseWait'):s.tr('login'))),TextButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RegisterScreen())),child:Text(s.tr('newAccount')))]))); }
}
