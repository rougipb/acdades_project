import 'package:flutter/material.dart';

class EditarHabitoScreen extends StatefulWidget {
  final String nombreActual;
  final int colorActualValue;

  const EditarHabitoScreen({
    super.key,
    required this.nombreActual,
    required this.colorActualValue,
  });

  @override
  State<EditarHabitoScreen> createState() => _EditarHabitoScreenState();
}

class _EditarHabitoScreenState extends State<EditarHabitoScreen> {
  late TextEditingController _nombreController;
  late int _colorSeleccionadoValue;

  final Map<String, Color> _opcionesColor = {
    'Azul': Colors.blue,
    'Verde': Colors.green,
    'Naranja': Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreActual);
    _colorSeleccionadoValue = widget.colorActualValue;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    final nuevoNombre = _nombreController.text.trim();
    if (nuevoNombre.isEmpty) return;

    Navigator.pop(context, {
      'nombre': nuevoNombre,
      'colorValue': _colorSeleccionadoValue,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Hábito')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del hábito',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _opcionesColor.entries.map((entry) {
                final esSeleccionado = _colorSeleccionadoValue == entry.value.value;
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: esSeleccionado,
                  avatar: CircleAvatar(backgroundColor: entry.value),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() => _colorSeleccionadoValue = entry.value.value);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text('Guardar Hábito'),
            ),
          ],
        ),
      ),
    );
  }
}