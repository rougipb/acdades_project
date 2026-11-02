import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/boton_principal.dart';
import '../widgets/tarjeta_habito.dart';
import 'gestion_habitos_screen.dart';
import 'estadisticas_screen.dart';
import 'ajustes_screen.dart';
import 'administracion_screen.dart';

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

  void _completarHabito(Habito habito) async {
    final hoyStr = DateTime.now().toIso8601String().split('T')[0];
    setState(() {
      if (habito.completadoHoy) {
        habito.fechasCompletado.remove(hoyStr);
      } else {
        if (!habito.fechasCompletado.contains(hoyStr)) {
          habito.fechasCompletado.add(hoyStr);
        }
      }
    });
    await PreferenciasService.guardarHabitos(_listaHabitos);
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
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Administración',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdministracionScreen()),
            ),
          ),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de Perfil de Usuario
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 35),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nombreUsuario,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Objetivo diario: $_objetivoDiario hábitos'),
                          Text('Progreso de hoy: $completadosHoy de $_objetivoDiario'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Reemplazo por BotonPrincipal reutilizable
            BotonPrincipal(
              texto: 'Abrir Gestor de Hábitos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GestionHabitosScreen(habitosIniciales: _listaHabitos),
                  ),
                ).then((_) => _cargarDatos());
              },
            ),

            const SizedBox(height: 15),

            const Text(
              'Tus hábitos para hoy:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lista de hábitos utilizando TarjetaHabito reutilizable
            Expanded(
              child: habitosVisibles.isEmpty
                  ? const Center(child: Text('No tienes hábitos registrados en tu perfil.'))
                  : ListView.builder(
                itemCount: habitosVisibles.length,
                itemBuilder: (context, index) {
                  final h = habitosVisibles[index];
                  return TarjetaHabito(
                    nombre: h.nombre,
                    color: Color(h.colorValue),
                    completadoHoy: h.completadoHoy,
                    onCompletar: () => _completarHabito(h),
                    onEditar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GestionHabitosScreen(habitosIniciales: _listaHabitos),
                        ),
                      ).then((_) => _cargarDatos());
                    },
                    onEliminar: () async {
                      setState(() {
                        _listaHabitos.removeWhere((item) => item.id == h.id);
                      });
                      await PreferenciasService.guardarHabitos(_listaHabitos);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}