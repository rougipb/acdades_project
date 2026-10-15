import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/habito_card.dart';
import 'estadisticas_screen.dart';
import 'ajustes_screen.dart';
import 'editar_habito_screen.dart';




class HomeScreen extends StatefulWidget {
  final String nombreUsuario;
  final int objetivoDiario;

  const HomeScreen({
    super.key,
    required this.nombreUsuario,
    required this.objetivoDiario,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Datos del hábito de ejemplo en memoria
  String _nombreHabito = 'Beber agua';
  String _colorNombre = 'Azul';
  bool _completadoHoy = false;

  final Map<String, Color> _mapaColores = {
    'Azul': Colors.blue,
    'Verde': Colors.green,
    'Naranja': Colors.orange,
  };

  // Método para abrir el editor recogiéndolo con await e idóneo chequeo de mounted
  Future<void> _abrirEditor() async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarHabitoScreen(
          nombreActual: _nombreHabito,
          colorActualNombre: _colorNombre,
        ),
      ),
    );

    // Comprobamos si el widget sigue montado después del await
    if (!mounted) return;

    // Si el resultado no es null, actualizamos la ficha con setState
    if (resultado != null) {
      setState(() {
        _nombreHabito = resultado['nombre'] as String;
        _colorNombre = resultado['colorNombre'] as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorActual = _mapaColores[_colorNombre] ?? Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitosApp - Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo y objetivo
            Text(
              '¡Hola, ${widget.nombreUsuario}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu objetivo diario es: ${widget.objetivoDiario} hábitos',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            // Ficha del hábito de ejemplo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorActual,
                          child: const Icon(Icons.water_drop, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nombreHabito,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Color: $_colorNombre',
                                style: TextStyle(
                                  color: colorActual,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: _abrirEditor,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    // Requisito extra opcional: marcar/desmarcar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _completadoHoy ? 'Estado: Completado hoy' : 'Estado: Pendiente',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _completadoHoy ? Colors.green : Colors.orange,
                          ),
                        ),
                        Checkbox(
                          value: _completadoHoy,
                          onChanged: (val) {
                            setState(() {
                              _completadoHoy = val ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}