import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/habito_card.dart';
import 'estadisticas_screen.dart';
import 'ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onThemeChanged;
  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nombre = '';
  int _objetivo = 3;
  double _fontSize = 16.0;
  bool _ocultarCompletados = false;
  List<Habito> _habitos = [];

  String get _hoy => DateTime.now().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final n = await PreferenciasService.getNombreUsuario() ?? 'Usuario';
    final o = await PreferenciasService.getObjetivoDiario();
    final f = await PreferenciasService.getTamanoLetra();
    final oc = await PreferenciasService.getOcultarCompletados();
    final h = await PreferenciasService.getHabitos();

    setState(() {
      _nombre = n;
      _objetivo = o;
      _fontSize = f;
      _ocultarCompletados = oc;
      _habitos = h;
    });
  }

  void _agregarHabito() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo hábito'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final nuevo = Habito(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nombre: ctrl.text.trim(),
                  colorValue: Colors.blue.value,
                );
                setState(() => _habitos.add(nuevo));
                await PreferenciasService.guardarHabitos(_habitos);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hechosHoy = _habitos.where((h) => h.fechasCompletado.contains(_hoy)).length;
    final lista = _ocultarCompletados
        ? _habitos.where((h) => !h.fechasCompletado.contains(_hoy)).toList()
        : _habitos;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EstadisticasScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AjustesScreen(onThemeChanged: widget.onThemeChanged ?? () {})),
              );
              _cargar();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Progreso: $hechosHoy / $_objetivo',
              style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final h = lista[i];
                final done = h.fechasCompletado.contains(_hoy);
                return HabitoCard(
                  habito: h,
                  completado: done,
                  fontSize: _fontSize,
                  onCambiar: (val) async {
                    setState(() {
                      if (val == true) {
                        h.fechasCompletado.add(_hoy);
                      } else {
                        h.fechasCompletado.remove(_hoy);
                      }
                    });
                    await PreferenciasService.guardarHabitos(_habitos);
                  },
                  onEliminar: () async {
                    setState(() => _habitos.remove(h));
                    await PreferenciasService.guardarHabitos(_habitos);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarHabito,
        child: const Icon(Icons.add),
      ),
    );
  }
}