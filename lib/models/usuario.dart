class Usuario {
  final String id;
  final String nombreUsuario;
  final String contrasena;
  final bool esAdmin;
  final DateTime fechaCreacion;

  Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.contrasena,
    this.esAdmin = false,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  // Convertir un objeto Usuario a un Map (para SQLite o SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreUsuario': nombreUsuario,
      'contrasena': contrasena,
      'esAdmin': esAdmin ? 1 : 0,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  // Crear un objeto Usuario a partir de un Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nombreUsuario: map['nombreUsuario'] ?? '',
      contrasena: map['contrasena'] ?? '',
      esAdmin: map['esAdmin'] == 1 || map['esAdmin'] == true,
      fechaCreacion: map['fechaCreacion'] != null
          ? DateTime.parse(map['fechaCreacion'])
          : DateTime.now(),
    );
  }
}