import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'home_screen.dart';

class BienvenidaScreen extends StatelessWidget {
  BienvenidaScreen({super.key});

  final _nombreCtrl = TextEditingController();
  final _objetivoCtrl = TextEditingController(text: '3');

  void _guardar(BuildContext context) async {
    final nombre = _nombreCtrl.text.trim();
    final objetivo = int.tryParse(_objetivoCtrl.text.trim()) ?? 3;

    if (nombre.isNotEmpty) {
      await PreferenciasService.guardarUsuario(nombre, objetivo);
      if (context.mounted) {
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
      appBar: AppBar(title: const Text('Bienvenida')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Tu nombre'),
            ),
            TextField(
              controller: _objetivoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Objetivo diario de hábitos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _guardar(context),
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}