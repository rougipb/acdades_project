import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import 'editar_habito_screen.dart';
import 'estadisticas_screen.dart';
import 'ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nombreUsuario = '';
  int _objetivoDiario = 5;
  List<Habito> _listaHabitos = [];
  bool _ocultarCompletados = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final nombre = await PreferenciasService.getNombreUsuario() ?? 'Usuario';
    final objetivo = await PreferenciasService.getObjetivoDiario();
    final habitos = await PreferenciasService.getHabitos();
    final ocultar = await PreferenciasService.getOcultarCompletados();

    setState(() {
      _nombreUsuario = nombre;
      _objetivoDiario = objetivo;
      _listaHabitos = habitos;
      _ocultarCompletados = ocultar;
      _cargando = false;
    });
  }

  Future<void> _guardarYRecargar() async {
    await PreferenciasService.guardarHabitos(_listaHabitos);
    await _cargarDatos();
  }

  void _completarHabito(Habito habito, bool? valor) {
    final hoyStr = DateTime.now().toIso8601String().split('T')[0];
    setState(() {
      if (valor == true) {
        if (!habito.fechasCompletado.contains(hoyStr)) {
          habito.fechasCompletado.add(hoyStr);
        }
      } else {
        habito.fechasCompletado.remove(hoyStr);
      }
    });
    _guardarYRecargar();
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
        // Editar hábito existente
        habitoExistente.nombre = resultado['nombre'] as String;
        habitoExistente.colorValue = resultado['colorValue'] as int;
      } else {
        // Crear nuevo hábito
        final nuevoHabito = Habito(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: resultado['nombre'] as String,
          colorValue: resultado['colorValue'] as int,
        );
        _listaHabitos.add(nuevoHabito);
      }
    });

    _guardarYRecargar();
  }

  void _borrarHabito(String id) {
    setState(() {
      _listaHabitos.removeWhere((h) => h.id == id);
    });
    _guardarYRecargar();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final completadosHoy = _listaHabitos.where((h) => h.completadoHoy).length;
    final habitosVisibles = _ocultarCompletados
        ? _listaHabitos.where((h) => !h.completadoHoy).toList()
        : _listaHabitos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitosApp - Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Estadísticas',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
            ).then((_) => _cargarDatos()),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ajustes',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AjustesScreen()),
            ).then((_) => _cargarDatos()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, $_nombreUsuario!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Progreso de hoy: $completadosHoy de $_objetivoDiario hábitos',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: habitosVisibles.isEmpty
                  ? const Center(child: Text('No hay hábitos registrados.'))
                  : ListView.builder(
                itemCount: habitosVisibles.length,
                itemBuilder: (context, index) {
                  final h = habitosVisibles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(h.colorValue),
                        child: Icon(
                          h.completadoHoy ? Icons.check : Icons.star,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(h.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Racha actual: ${h.rachaActual} días 🔥'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: h.completadoHoy,
                            onChanged: (val) => _completarHabito(h, val),
                          ),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearOEditarHabito(),
        child: const Icon(Icons.add),
      ),
    );
  }
}