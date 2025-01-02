import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:listenit/page/welcome_page.dart';
import 'package:listenit/page/register_page.dart';
import 'package:listenit/utils/splash_screen.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Aktifkan Device Preview hanya di mode debug
      builder: (context) => MyApp(), // Bungkus aplikasi Anda
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true, // Menggunakan inherited media query
      locale:
          DevicePreview.locale(context), // Mengatur locale dari Device Preview
      builder:
          DevicePreview.appBuilder, // Menggunakan builder dari Device Preview
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AppSplashScreen(),
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
      },
    );
  }
}
