// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Import your folder files
import 'screens/splash_screen.dart';
import 'screens/admin/admin_login.dart';

void main() {
  runApp(const Waste2WageApp());
}

class Waste2WageApp extends StatelessWidget {
  const Waste2WageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste2Wage',
      theme: ThemeData(primarySwatch: Colors.green),
      
      // LOGIC: 
      // If Web -> Go to Admin Folder
      // If Phone -> Go to Auth Folder (Welcome Screen)
      home: kIsWeb ? const AdminLoginScreen() : const SplashScreen(), // Change MobileLogin to SplashScreen
    );
  }
}