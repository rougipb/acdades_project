import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'bienvenida_screen.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _oscuro = false;
  double _tamano = 16.0;
  bool _ocultar = false;

  @override
  void initState() {
    super.initState();
    _cargarAjustes();
  }

  Future<void> _cargarAjustes() async {
    final o = await PreferenciasService.getModoOscuro();
    final t = await PreferenciasService.getTamanoLetra();
    final oc = await PreferenciasService.getOcultarCompletados();
    setState(() {
      _oscuro = o;
      _tamano = t;
      _ocultar = oc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: _oscuro,
            onChanged: (val) async {
              setState(() => _oscuro = val);
              await PreferenciasService.setModoOscuro(val);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Tamaño de letra'),
            subtitle: Slider(
              value: _tamano,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: _tamano.toStringAsFixed(0),
              onChanged: (val) async {
                setState(() => _tamano = val);
                await PreferenciasService.setTamanoLetra(val);
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Ocultar hábitos completados hoy'),
            value: _ocultar,
            onChanged: (val) async {
              setState(() => _ocultar = val);
              await PreferenciasService.setOcultarCompletados(val);
            },
          ),
          const Divider(),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Borrar todos los datos'),
                  content: const Text('¿Estás seguro? La app quedará como recién instalada.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Borrar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                await PreferenciasService.borrarTodo();
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Borrar datos de la app', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}