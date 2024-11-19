// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart'; // Import the login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool _isNightMode = false; // Night mode state
  
  // Toggle night mode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: _isNightMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 143, 79, 255)),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 143, 79, 255)),
            ),
      home: const LoginPage(),
    );
  }
}
