import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multi_screen_login_and_homeapp/feature/auth/presentation/screen/splash_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
