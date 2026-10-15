import 'package:flutter/material.dart';
import 'services/preferencias_service.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HabitosApp());
}

class HabitosApp extends StatelessWidget {
  const HabitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitosApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BienvenidaScreen(),
    );
  }
}