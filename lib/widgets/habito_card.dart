import 'package:flutter/material.dart';
import '../models/habito.dart';

class HabitoCard extends StatelessWidget {
  final Habito habito;
  final bool completado;
  final ValueChanged<bool?> onCambiar;
  final VoidCallback onEliminar;
  final double fontSize;

  const HabitoCard({
    super.key,
    required this.habito,
    required this.completado,
    required this.onCambiar,
    required this.onEliminar,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: completado,
          onChanged: onCambiar,
        ),
        title: Text(
          habito.nombre,
          style: TextStyle(
            fontSize: fontSize,
            decoration: completado ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onEliminar,
        ),
      ),
    );
  }
}