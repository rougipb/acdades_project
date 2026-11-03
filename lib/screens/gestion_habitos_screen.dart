import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../services/database_helper.dart';
import 'editar_habito_screen.dart';
import '../widgets/tarjeta_habito.dart';

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

  Future<void> _crearOEditarHabito([Habito? habitoExistente]) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarHabitoScreen(
          nombreActual: habitoExistente?.nombre ?? '',
          colorActualValue: habitoExistente?.colorValue ?? Colors.blue.value,
        ),
      ),
    );

    if (!mounted || res == null) return;

    final resultado = res as Map<String, dynamic>;
    final nombre = resultado['nombre'] as String;
    final colorValue = resultado['colorValue'] as int;

    if (habitoExistente != null) {
      // Editar hábito existente en la Base de Datos
      setState(() {
        habitoExistente.nombre = nombre;
        habitoExistente.colorValue = colorValue;
      });
      await DatabaseHelper.instance.updateHabito(habitoExistente);
    } else {
      // Crear un nuevo hábito asignado al usuario actual logueado
      final usuarioId = await PreferenciasService.getUsuarioId() ?? 1;

      final nuevoHabito = Habito(
        usuarioId: usuarioId,
        nombre: nombre,
        colorValue: colorValue,
      );

      final newId = await DatabaseHelper.instance.insertHabito(nuevoHabito);

      setState(() {
        _listaHabitos.add(
          Habito(
            id: newId,
            usuarioId: usuarioId,
            nombre: nombre,
            colorValue: colorValue,
          ),
        );
      });
    }
  }

  void _borrarHabito(int? id) async {
    if (id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Hábito'),
        content: const Text('¿Seguro que quieres eliminar este hábito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await DatabaseHelper.instance.deleteHabito(id);
      setState(() {
        _listaHabitos.removeWhere((h) => h.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Hábitos'),
      ),
      body: _listaHabitos.isEmpty
          ? const Center(child: Text('No hay hábitos. Crea uno con el botón +'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        itemCount: _listaHabitos.length,
        itemBuilder: (context, index) {
          final h = _listaHabitos[index];
          final esCompletadoHoy = h.fechasCompletado.contains(hoy);

          return TarjetaHabito(
            nombre: h.nombre,
            color: Color(h.colorValue),
            completadoHoy: esCompletadoHoy,
            onCompletar: () async {
              setState(() {
                if (esCompletadoHoy) {
                  h.fechasCompletado.remove(hoy);
                } else {
                  h.fechasCompletado.add(hoy);
                }
              });
              await DatabaseHelper.instance.updateHabito(h);
            },
            onEditar: () => _crearOEditarHabito(h),
            onEliminar: () => _borrarHabito(h.id),
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