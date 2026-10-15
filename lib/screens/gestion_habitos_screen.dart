import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import 'editar_habito_screen.dart';

class GestionHabitosScreen extends StatefulWidget {
  final List<Habito> habitosIniciales;

  const GestionHabitosScreen({super.key, required this.habitosIniciales});

  @override
  State<GestionHabitosScreen> createState() => _GestionHabitosScreenState();
}

class _GestionHabitosScreenState extends State<GestionHabitosScreen> {
  late List<Habito> _listaHabitos;

  @override
  void initState() {
    super.initState();
    _listaHabitos = List.from(widget.habitosIniciales);
  }

  Future<void> _guardar() async {
    await PreferenciasService.guardarHabitos(_listaHabitos);
  }

  Future<void> _crearOEditarHabito([Habito? habitoExistente]) async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarHabitoScreen(
          nombreActual: habitoExistente?.nombre ?? '',
          colorActualValue: habitoExistente?.colorValue ?? Colors.blue.value,
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    setState(() {
      if (habitoExistente != null) {
        habitoExistente.nombre = resultado['nombre'] as String;
        habitoExistente.colorValue = resultado['colorValue'] as int;
      } else {
        final nuevo = Habito(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: resultado['nombre'] as String,
          colorValue: resultado['colorValue'] as int,
        );
        _listaHabitos.add(nuevo);
      }
    });

    await _guardar();
  }

  void _borrarHabito(String id) async {
    setState(() {
      _listaHabitos.removeWhere((h) => h.id == id);
    });
    await _guardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Hábitos'),
      ),
      body: _listaHabitos.isEmpty
          ? const Center(child: Text('No hay hábitos. Crea uno con el botón +'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _listaHabitos.length,
        itemBuilder: (context, index) {
          final h = _listaHabitos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(h.colorValue),
                child: const Icon(Icons.star, color: Colors.white),
              ),
              title: Text(h.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Racha: ${h.rachaActual} días'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => _crearOEditarHabito(h),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _borrarHabito(h.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearOEditarHabito(),
        child: const Icon(Icons.add),
      ),
    );
  }
}