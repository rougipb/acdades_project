import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/dato_estadistica.dart';

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
          DatoEstadistica(
            etiqueta: 'Aperturas de la app',
            valor: '$_aperturas veces (Última: $_ultimaApertura)',
            icono: Icons.app_shortcut,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 20),
          const Text(
            'Rachas por hábito:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ..._habitos.map((h) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                DatoEstadistica(
                  etiqueta: 'Racha actual - ${h.nombre}',
                  valor: '${h.rachaActual} días',
                  icono: Icons.local_fire_department,
                  color: Color(h.colorValue),
                ),
                const SizedBox(height: 6),
                DatoEstadistica(
                  etiqueta: 'Días completados - ${h.nombre}',
                  valor: '${h.fechasCompletado.length} días',
                  icono: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}