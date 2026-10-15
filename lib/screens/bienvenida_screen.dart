import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'home_screen.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  // Controladores fuera del build y liberados en dispose
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _objetivoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _objetivoController.dispose();
    super.dispose();
  }

  void _comenzar() {
    final nombre = _nombreController.text.trim();
    final objetivoStr = _objetivoController.text.trim();

    if (nombre.isEmpty || objetivoStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
      return;
    }

    final objetivo = int.tryParse(objetivoStr) ?? 1;

    // Navegación pasando datos al constructor de HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          nombreUsuario: nombre,
          objetivoDiario: objetivo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenida - HabitosApp'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              '¡Bienvenido a HabitosApp!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _objetivoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Objetivo diario de hábitos (número)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _comenzar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Comenzar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}