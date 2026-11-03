import 'dart:convert';

class Habito {
  final int? id;
  final int usuarioId; // Relación con el usuario creador
  String nombre;
  int colorValue;
  List<String> fechasCompletado;

  Habito({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.colorValue,
    List<String>? fechasCompletado,
  }) : fechasCompletado = fechasCompletado ?? [];

  int get rachaActual {
    if (fechasCompletado.isEmpty) return 0;

    final fechasOrdenadas = fechasCompletado.map((f) => DateTime.parse(f)).toList()
      ..sort((a, b) => b.compareTo(a));

    final hoy = DateTime.now();
    final hoyNormalizado = DateTime(hoy.year, hoy.month, hoy.day);

    int racha = 0;
    DateTime fechaEsperada = hoyNormalizado;

    final ultimaFecha = DateTime(fechasOrdenadas.first.year, fechasOrdenadas.first.month, fechasOrdenadas.first.day);
    final diferenciaDias = hoyNormalizado.difference(ultimaFecha).inDays;

    if (diferenciaDias > 1) {
      return 0;
    } else if (diferenciaDias == 1) {
      fechaEsperada = ultimaFecha;
    }

    for (var fecha in fechasOrdenadas) {
      final fechaNorm = DateTime(fecha.year, fecha.month, fecha.day);
      if (fechaNorm.isAtSameMomentAs(fechaEsperada)) {
        racha++;
        fechaEsperada = fechaEsperada.subtract(const Duration(days: 1));
      } else if (fechaNorm.isBefore(fechaEsperada)) {
        break;
      }
    }
    return racha;
  }

  bool get completadoHoy {
    final hoyStr = DateTime.now().toIso8601String().split('T')[0];
    return fechasCompletado.contains(hoyStr);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'nombre': nombre,
      'color_value': colorValue,
      'fechas_completado': jsonEncode(fechasCompletado), // Convertimos la lista a String JSON
    };
  }

  factory Habito.fromMap(Map<String, dynamic> map) {
    return Habito(
      id: map['id'] as int?,
      usuarioId: map['usuario_id'] as int,
      nombre: map['nombre'] ?? '',
      colorValue: map['color_value'] ?? 0,
      fechasCompletado: map['fechas_completado'] != null
          ? List<String>.from(jsonDecode(map['fechas_completado']))
          : [],
    );
  }
}