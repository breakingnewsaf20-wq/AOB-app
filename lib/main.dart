import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_strings.dart';
import 'screens/auth/login_screen.dart';
import 'screens/customer/home_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString('languageCode') ?? 'ps';
  runApp(AfghanOnlineBazaarApp(initialLocale: Locale(code)));
}

class AfghanOnlineBazaarApp extends StatefulWidget {
  final Locale initialLocale;
  const AfghanOnlineBazaarApp({super.key, required this.initialLocale});
  @override State<AfghanOnlineBazaarApp> createState() => _AppState();
}

class _AppState extends State<AfghanOnlineBazaarApp> {
  late Locale locale = widget.initialLocale;
  Future<void> setLanguage(Locale value) async {
    setState(() => locale = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', value.languageCode);
  }

  @override Widget build(BuildContext context) {
    final isRtl = locale.languageCode == 'ps' || locale.languageCode == 'fa';
    return LanguageScope(
      locale: locale,
      onChanged: setLanguage,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.t(locale, 'appName'),
        locale: locale,
        supportedLocales: AppStrings.supportedLocales,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        builder: (context, child) => Directionality(textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr, child: child ?? const SizedBox.shrink()),
        home: StreamBuilder(
          stream: AuthService.instance.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData) {
              NotificationService().initialize().catchError((_) {});
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
