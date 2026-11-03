import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../services/database_helper.dart';
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
  int _usuarioId = 0;
  String _rolUsuario = 'usuario';
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
    // 1. Obtener datos del usuario en sesión activa
    final nombre = await PreferenciasService.getNombreUsuario() ?? 'Usuario';
    final usuarioId = await PreferenciasService.getUsuarioId() ?? 0;
    final rol = await PreferenciasService.getRolUsuario() ?? 'usuario';
    final objetivo = await PreferenciasService.getObjetivoDiario();
    final ocultar = await PreferenciasService.getOcultarCompletados();

    // 2. Cargar hábitos desde la Base de Datos SQLite
    final habitosDB = await DatabaseHelper.instance.getHabitosPorUsuario(usuarioId, rol);

    setState(() {
      _nombreUsuario = nombre;
      _usuarioId = usuarioId;
      _rolUsuario = rol;
      _objetivoDiario = objetivo;
      _listaHabitos = habitosDB;
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

    // Actualizar registro en SQLite
    await DatabaseHelper.instance.updateHabito(habito);
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

    final esAdmin = _rolUsuario == 'administrador';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
              tooltip: 'Administración',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdministracionScreen()),
              ).then((_) => _cargarDatos()),
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
                          Text('Rol: $_rolUsuario'),
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
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar Hábito'),
                          content: const Text('¿Seguro que quieres eliminar este hábito?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirmar == true && h.id != null) {
                        await DatabaseHelper.instance.deleteHabito(h.id!);
                        _cargarDatos();
                      }
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