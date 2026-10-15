import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'home_screen.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  final _nombreCtrl = TextEditingController();
  final _objetivoCtrl = TextEditingController();

  void _comenzar() async {
    final nombre = _nombreCtrl.text.trim();
    final objetivo = int.tryParse(_objetivoCtrl.text.trim()) ?? 5;

    if (nombre.isNotEmpty) {
      await PreferenciasService.guardarUsuario(nombre, objetivo);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenida - HabitosApp')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Tu nombre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _objetivoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Objetivo diario de hábitos', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: _comenzar, child: const Text('Comenzar')),
          ],
        ),
      ),
    );
  }
}