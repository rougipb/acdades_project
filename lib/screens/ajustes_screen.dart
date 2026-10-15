import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'bienvenida_screen.dart';

class AjustesScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const AjustesScreen({super.key, required this.onThemeChanged});

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
    _cargar();
  }

  void _cargar() async {
    final o = await PreferenciasService.getModoOscuro();
    final t = await PreferenciasService.getTamanoLetra();
    final oc = await PreferenciasService.getOcultarCompletados();
    setState(() {
      _oscuro = o;
      _tamano = t;
      _ocultar = oc;
    });
  }

  void _borrar(BuildContext context) async {
    await PreferenciasService.borrarTodo();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => BienvenidaScreen()),
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: _oscuro,
            onChanged: (val) async {
              setState(() => _oscuro = val);
              await PreferenciasService.setModoOscuro(val);
              widget.onThemeChanged();
            },
          ),
          SwitchListTile(
            title: const Text('Ocultar completados hoy'),
            value: _ocultar,
            onChanged: (val) async {
              setState(() => _ocultar = val);
              await PreferenciasService.setOcultarCompletados(val);
            },
          ),
          ListTile(
            title: Text('Tamaño de letra: ${_tamano.toInt()}'),
            subtitle: Slider(
              min: 12.0,
              max: 22.0,
              value: _tamano,
              onChanged: (v) => setState(() => _tamano = v),
              onChangeEnd: (v) => PreferenciasService.setTamanoLetra(v),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Restablecer aplicación', style: TextStyle(color: Colors.red)),
            onTap: () => _borrar(context),
          ),
        ],
      ),
    );
  }
}