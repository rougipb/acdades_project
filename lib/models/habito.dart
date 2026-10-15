
class Habito {
  final String id;
  String nombre;
  int colorValue; // Guardamos el color como entero (ARGB)
  List<String> fechasCompletado; // Lista de fechas en formato String (yyyy-MM-dd)

  Habito({
    required this.id,
    required this.nombre,
    required this.colorValue,
    List<String>? fechasCompletado,
  }) : fechasCompletado = fechasCompletado ?? [];

  // Convierte el objeto Habito a un Map para poder serializarlo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'colorValue': colorValue,
      'fechasCompletado': fechasCompletado,
    };
  }

  // Crea un objeto Habito a partir de un Map obtenido de un JSON
  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      colorValue: json['colorValue'] as int,
      fechasCompletado: List<String>.from(json['fechasCompletado'] as List),
    );
  }
}