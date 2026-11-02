import 'package:flutter/material.dart';

class AdministracionScreen extends StatelessWidget {
  const AdministracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Gestión Global de Usuarios'),
            subtitle: Text('Consultar, editar y eliminar usuarios registrados'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Estadísticas Globales'),
            subtitle: Text('Ver rendimiento de hábitos de todos los usuarios'),
          ),
        ],
      ),
    );
  }
}