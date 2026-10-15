import 'package:flutter/material.dart';

class EditarHabitoScreen extends StatefulWidget {
  final String nombreActual;
  final String colorActualNombre;

  const EditarHabitoScreen({
    super.key,
    required this.nombreActual,
    required this.colorActualNombre,
  });

  @override
  State<EditarHabitoScreen> createState() => _EditarHabitoScreenState();
}

class _EditarHabitoScreenState extends State<EditarHabitoScreen> {
  late TextEditingController _nombreController;
  late String _colorSeleccionadoNombre;

  // Mapa para gestionar los colores según las pautas de la ficha
  final Map<String, Color> _opcionesColor = {
    'Azul': Colors.blue,
    'Verde': Colors.green,
    'Naranja': Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    // Inicializar el controlador con el nombre recibido
    _nombreController = TextEditingController(text: widget.nombreActual);
    _colorSeleccionadoNombre = widget.colorActualNombre;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    final nuevoNombre = _nombreController.text.trim();
    if (nuevoNombre.isEmpty) return;

    // Retorna el resultado formateado
    Navigator.pop(context, {
      'nombre': nuevoNombre,
      'colorNombre': _colorSeleccionadoNombre,
    });
  }

  void _cancelar() {
    // Retorna null al cancelar
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar hábito'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del hábito',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Selecciona un color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Agrupar los botones de color en una Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _opcionesColor.keys.map((nombreColor) {
                final esSeleccionado = _colorSeleccionadoNombre == nombreColor;
                return ChoiceChip(
                  label: Text(nombreColor),
                  selected: esSeleccionado,
                  selectedColor: _opcionesColor[nombreColor]?.withOpacity(0.4),
                  avatar: CircleAvatar(
                    backgroundColor: _opcionesColor[nombreColor],
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _colorSeleccionadoNombre = nombreColor;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelar,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}