import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/tarjeta_habito.dart';
import '../widgets/dato_estadistica.dart';

class AdministracionScreen extends StatefulWidget {
  const AdministracionScreen({super.key});

  @override
  State<AdministracionScreen> createState() => _AdministracionScreenState();
}

class _AdministracionScreenState extends State<AdministracionScreen> {
  List<Habito> _habitosGlobales = [];
  String? _usuarioRegistrado;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosGlobales();
  }

  Future<void> _cargarDatosGlobales() async {
    final habitos = await PreferenciasService.getHabitos();
    final usuario = await PreferenciasService.getNombreUsuario();

    setState(() {
      _habitosGlobales = habitos;
      _usuarioRegistrado = usuario ?? 'Ninguno registrado';
      _cargando = false;
    });
  }

  void _eliminarHabitoAdmin(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminación de Administrador'),
        content: const Text('¿Deseas eliminar este hábito del sistema global?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        _habitosGlobales.removeWhere((h) => h.id == id);
      });
      await PreferenciasService.guardarHabitos(_habitosGlobales);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.amber.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección 1: Información de Usuarios
            const Text(
              'Gestión Global de Usuarios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.amber),
                title: Text('Usuario Activo: $_usuarioRegistrado'),
                subtitle: const Text('Rol: Administrador del Sistema'),
                trailing: const Icon(Icons.verified_user, color: Colors.green),
              ),
            ),
            const SizedBox(height: 24),

            // Sección 2: Resumen Estadístico Global
            const Text(
              'Estadísticas Globales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DatoEstadistica(
                    etiqueta: 'Total Hábitos',
                    valor: '${_habitosGlobales.length}',
                    icono: Icons.format_list_bulleted,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DatoEstadistica(
                    etiqueta: 'Completados Hoy',
                    valor: '${_habitosGlobales.where((h) => h.completadoHoy).length}',
                    icono: Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sección 3: Control Global de Hábitos
            const Text(
              'Gestión Global de Hábitos Registrados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _habitosGlobales.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('No existen hábitos registrados en la aplicación.'),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _habitosGlobales.length,
              itemBuilder: (context, index) {
                final h = _habitosGlobales[index];
                return TarjetaHabito(
                  nombre: h.nombre,
                  color: Color(h.colorValue),
                  completadoHoy: h.completadoHoy,
                  onCompletar: () {},
                  onEditar: () {},
                  onEliminar: () {
                    if (h.id != null) {
                      _eliminarHabitoAdmin(h.id.toString());
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}