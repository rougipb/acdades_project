import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';
import '../models/habito.dart';
import '../models/estadistica.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habitos_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Tabla Usuarios
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        apellidos TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        contrasena TEXT NOT NULL,
        fecha_creacion TEXT NOT NULL,
        rol TEXT NOT NULL
      )
    ''');

    // 2. Tabla Habitos
    await db.execute('''
      CREATE TABLE habitos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        color_value INTEGER NOT NULL,
        fechas_completado TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    // 3. Tabla Estadisticas
    await db.execute('''
      CREATE TABLE estadisticas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habito_id INTEGER UNIQUE NOT NULL,
        racha_actual INTEGER NOT NULL,
        total_dias_completados INTEGER NOT NULL,
        FOREIGN KEY (habito_id) REFERENCES habitos (id) ON DELETE CASCADE
      )
    ''');
  }

  // ================= CRUD USUARIOS =================
  Future<int> insertUsuario(Usuario usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> loginUsuario(String email, String contrasena) async {
    final db = await instance.database;
    final res = await db.query(
      'usuarios',
      where: 'email = ? AND contrasena = ?',
      whereArgs: [email, contrasena],
    );
    if (res.isNotEmpty) {
      return Usuario.fromMap(res.first);
    }
    return null;
  }

  Future<List<Usuario>> getTodosUsuarios() async {
    final db = await instance.database;
    final res = await db.query('usuarios');
    return res.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<int> updateUsuario(Usuario usuario) async {
    final db = await instance.database;
    return await db.update('usuarios', usuario.toMap(), where: 'id = ?', whereArgs: [usuario.id]);
  }

  Future<int> deleteUsuario(int id) async {
    final db = await instance.database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  // ================= CRUD HÁBITOS =================
  Future<int> insertHabito(Habito habito) async {
    final db = await instance.database;
    int habitoId = await db.insert('habitos', habito.toMap());

    // Crear registro de estadística inicial para este hábito
    await db.insert('estadisticas', {
      'habito_id': habitoId,
      'racha_actual': 0,
      'total_dias_completados': 0,
    });

    return habitoId;
  }

  Future<List<Habito>> getHabitosPorUsuario(int usuarioId, String rol) async {
    final db = await instance.database;
    final res = (rol == 'administrador')
        ? await db.query('habitos')
        : await db.query('habitos', where: 'usuario_id = ?', whereArgs: [usuarioId]);

    return res.map((e) => Habito.fromMap(e)).toList();
  }

  Future<int> updateHabito(Habito habito) async {
    final db = await instance.database;
    int updated = await db.update('habitos', habito.toMap(), where: 'id = ?', whereArgs: [habito.id]);

    // Actualizar también la tabla estadísticas
    await db.update(
      'estadisticas',
      {
        'racha_actual': habito.rachaActual,
        'total_dias_completados': habito.fechasCompletado.length,
      },
      where: 'habito_id = ?',
      whereArgs: [habito.id],
    );

    return updated;
  }

  Future<int> deleteHabito(int id) async {
    final db = await instance.database;
    await db.delete('estadisticas', where: 'habito_id = ?', whereArgs: [id]);
    return await db.delete('habitos', where: 'id = ?', whereArgs: [id]);
  }

  // ================= CRUD ESTADÍSTICAS =================
  Future<Estadistica?> getEstadisticaPorHabito(int habitoId) async {
    final db = await instance.database;
    final res = await db.query('estadisticas', where: 'habito_id = ?', whereArgs: [habitoId]);
    if (res.isNotEmpty) {
      return Estadistica.fromMap(res.first);
    }
    return null;
  }
}