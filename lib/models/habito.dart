
class Habito {
  final String id;
  String nombre;
  int colorValue; // Guardamos el valor entero del color (ARGB)
  List<String> fechasCompletado; // Formato "YYYY-MM-DD"

  Habito({
    required this.id,
    required this.nombre,
    required this.colorValue,
    List<String>? fechasCompletado,
  }) : fechasCompletado = fechasCompletado ?? [];

  // Calcula la racha actual consecutiva de días completados
  int get rachaActual {
    if (fechasCompletado.isEmpty) return 0;

    final fechasOrdenadas = fechasCompletado.map((f) => DateTime.parse(f)).toList()
      ..sort((a, b) => b.compareTo(a));

    final hoy = DateTime.now();
    final hoyNormalizado = DateTime(hoy.year, hoy.month, hoy.day);

    int racha = 0;
    DateTime fechaEsperada = hoyNormalizado;

    // Si no se ha completado hoy, comprobamos si se completó ayer para no romper la racha aún
    final ultimaFecha = DateTime(fechasOrdenadas.first.year, fechasOrdenadas.first.month, fechasOrdenadas.first.day);
    final diferenciaDias = hoyNormalizado.difference(ultimaFecha).inDays;

    if (diferenciaDias > 1) {
      return 0; // Se rompió la racha
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'colorValue': colorValue,
      'fechasCompletado': fechasCompletado,
    };
  }

  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      colorValue: json['colorValue'] as int,
      fechasCompletado: List<String>.from(json['fechasCompletado'] as List),
    );
  }
}