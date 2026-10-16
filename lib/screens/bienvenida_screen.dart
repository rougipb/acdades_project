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

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _objetivoCtrl.dispose();
    super.dispose();
  }

  void _comenzar() async {
    final nombre = _nombreCtrl.text.trim();
    final objetivoStr = _objetivoCtrl.text.trim();

    if (nombre.isEmpty || objetivoStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos'),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    final objetivo = int.tryParse(objetivoStr) ?? 5;

    await PreferenciasService.guardarUsuario(nombre, objetivo);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definimos la paleta de colores basada en el color naranja
    const colorNaranjaPrincipal = Colors.orange;
    const colorNaranjaOscuro = Colors.deepOrange;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo/Icono destacado de la aplicación
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: colorNaranjaPrincipal.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.screen_lock_portrait,
                    size: 80,
                    color: colorNaranjaOscuro,
                  ),
                ),
                const SizedBox(height: 24),

                // Título y Subtítulo
                const Text(
                  'HabitosApp',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorNaranjaOscuro,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Construye tu rutina día a día',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Campo: Nombre de usuario
                TextField(
                  controller: _nombreCtrl,
                  decoration: InputDecoration(
                    labelText: 'Tu nombre',
                    prefixIcon: const Icon(Icons.person_outline, color: colorNaranjaOscuro),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: colorNaranjaOscuro, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo: Objetivo diario de hábitos
                TextField(
                  controller: _objetivoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Objetivo diario de hábitos (número)',
                    prefixIcon: const Icon(Icons.flag_outlined, color: colorNaranjaOscuro),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: colorNaranjaOscuro, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Botón principal de Comenzar
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _comenzar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorNaranjaOscuro,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Comenzar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}