class Usuario {
  final int? id;
  final String usuario;
  final String nombre;
  final String apellidos;
  final String email;
  final String contrasena;
  final String fechaCreacion;
  final String rol; // 'administrador' o 'usuario'

  Usuario({
    this.id,
    required this.usuario,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.contrasena,
    required this.fechaCreacion,
    required this.rol,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'contrasena': contrasena,
      'fecha_creacion': fechaCreacion,
      'rol': rol,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      usuario: map['usuario'] ?? '',
      nombre: map['nombre'] ?? '',
      apellidos: map['apellidos'] ?? '',
      email: map['email'] ?? '',
      contrasena: map['contrasena'] ?? '',
      fechaCreacion: map['fecha_creacion'] ?? '',
      rol: map['rol'] ?? 'usuario',
    );
  }
}