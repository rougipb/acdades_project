import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  int _aperturas = 0;
  String _ultimaApertura = 'No registrada';
  List<Habito> _habitos = [];

  @override
  void initState() {
    super.initState();
    _cargarStats();
  }

  Future<void> _cargarStats() async {
    final ap = await PreferenciasService.getContadorAperturas();
    final ult = await PreferenciasService.getUltimaApertura();
    final h = await PreferenciasService.getHabitos();

    setState(() {
      _aperturas = ap;
      _ultimaApertura = ult != null ? DateTime.parse(ult).toLocal().toString().split('.')[0] : 'Hoy';
      _habitos = h;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              title: const Text('Aperturas de la app'),
              subtitle: Text('Abierta $_aperturas veces. Última: $_ultimaApertura'),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Rachas por hábito:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ..._habitos.map((h) => Card(
            child: ListTile(
              title: Text(h.nombre),
              subtitle: Text('Racha actual: ${h.rachaActual} días | Total completado: ${h.fechasCompletado.length} días'),
            ),
          )),
        ],
      ),
    );
  }
}