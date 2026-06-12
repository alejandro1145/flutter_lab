import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NeinsApp());
}

class NeinsApp extends StatelessWidget {
  const NeinsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neins',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}