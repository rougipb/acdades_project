import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  int _aperturas = 0;
  String _ultima = '-';
  int _completados = 0;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() async {
    final a = await PreferenciasService.getContadorAperturas();
    final u = await PreferenciasService.getUltimaApertura() ?? '-';
    final h = await PreferenciasService.getHabitos();
    setState(() {
      _aperturas = a;
      _ultima = u.length >= 16 ? u.substring(0, 16).replaceFirst('T', ' ') : u;
      _completados = h.fold(0, (total, item) => total + item.fechasCompletado.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: ListView(
        children: [
          ListTile(title: const Text('Veces abierta la app'), trailing: Text('$_aperturas')),
          ListTile(title: const Text('Última apertura'), subtitle: Text(_ultima)),
          ListTile(title: const Text('Total hábitos completados'), trailing: Text('$_completados')),
        ],
      ),
    );
  }
}