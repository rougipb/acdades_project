import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habito.dart';

/// Servicio encargado de centralizar todo el acceso a SharedPreferences.
/// Ninguna pantalla debe invocar SharedPreferences directamente.
class PreferenciasService {
  // Constantes para las claves para evitar errores tipográficos
  static const String _keyNombreUsuario = 'nombre_usuario'; // Tipo String
  static const String _keyObjetivoDiario = 'objetivo_diario'; // Tipo int
  static const String _keyModoOscuro = 'modo_oscuro'; // Tipo bool
  static const String _keyTamanoLetra = 'tamano_letra'; // Tipo double
  static const String _keyHabitos = 'lista_habitos'; // Tipo List<String> (JSON)
  static const String _keyContadorAperturas = 'contador_aperturas'; // Tipo int
  static const String _keyUltimaApertura = 'ultima_apertura'; // Tipo String
  static const String _keyOcultarCompletados = 'ocultar_completados'; // Tipo bool

  static SharedPreferences? _prefs;

  // Inicializa la instancia de SharedPreferences
  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }




  static Future<void> setUsuarioId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usuario_id', id);
  }

  static Future<int?> getUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }

  static Future<void> setRolUsuario(String rol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rol_usuario', rol);
  }

  static Future<String?> getRolUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rol_usuario');
  }


  // ---------------------------------------------------------------------------
  // REGISTRO DE APERTURAS
  // ---------------------------------------------------------------------------
  static Future<void> registrarApertura() async {
    final prefs = await _instance;
    int aperturas = prefs.getInt(_keyContadorAperturas) ?? 0;
    await prefs.setInt(_keyContadorAperturas, aperturas + 1);
    await prefs.setString(_keyUltimaApertura, DateTime.now().toIso8601String());
  }

  static Future<int> getContadorAperturas() async {
    final prefs = await _instance;
    return prefs.getInt(_keyContadorAperturas) ?? 0;
  }

  static Future<String?> getUltimaApertura() async {
    final prefs = await _instance;
    return prefs.getString(_keyUltimaApertura);
  }
  static const String _keyPasswordUsuario = 'password_usuario';

  static Future<void> setPasswordUsuario(String password) async {
    final prefs = await _instance;
    await prefs.setString(_keyPasswordUsuario, password);
  }

  static Future<String?> getPasswordUsuario() async {
    final prefs = await _instance;
    return prefs.getString(_keyPasswordUsuario);
  }
  // ---------------------------------------------------------------------------
  // DATOS DE USUARIO
  // ---------------------------------------------------------------------------
  static Future<void> guardarUsuario(String nombre, int objetivo) async {
    final prefs = await _instance;
    await prefs.setString(_keyNombreUsuario, nombre);
    await prefs.setInt(_keyObjetivoDiario, objetivo);
  }

  static Future<void> setNombreUsuario(String nombre) async {
    final prefs = await _instance;
    await prefs.setString(_keyNombreUsuario, nombre);
  }

  static Future<void> setObjetivoDiario(int objetivo) async {
    final prefs = await _instance;
    await prefs.setInt(_keyObjetivoDiario, objetivo);
  }

  static Future<String?> getNombreUsuario() async {
    final prefs = await _instance;
    return prefs.getString(_keyNombreUsuario);
  }

  static Future<int> getObjetivoDiario() async {
    final prefs = await _instance;
    return prefs.getInt(_keyObjetivoDiario) ?? 5;
  }
  // ---------------------------------------------------------------------------
  //ADMIN
  // ---------------------------------------------------------------------------

  static const String _keyEsAdmin = 'es_admin';

  static Future<void> setEsAdmin(bool esAdmin) async {
    final prefs = await _instance;
    await prefs.setBool(_keyEsAdmin, esAdmin);
  }

  static Future<bool> getEsAdmin() async {
    final prefs = await _instance;
    return prefs.getBool(_keyEsAdmin) ?? false;
  }

  // ---------------------------------------------------------------------------
  // AJUSTES DE APARIENCIA
  // ---------------------------------------------------------------------------
  static Future<void> setModoOscuro(bool valor) async {
    final prefs = await _instance;
    await prefs.setBool(_keyModoOscuro, valor);
  }

  static Future<bool> getModoOscuro() async {
    final prefs = await _instance;
    return prefs.getBool(_keyModoOscuro) ?? false;
  }

  static Future<void> setTamanoLetra(double valor) async {
    final prefs = await _instance;
    await prefs.setDouble(_keyTamanoLetra, valor);
  }

  static Future<double> getTamanoLetra() async {
    final prefs = await _instance;
    return prefs.getDouble(_keyTamanoLetra) ?? 16.0;
  }

  static Future<void> setOcultarCompletados(bool valor) async {
    final prefs = await _instance;
    await prefs.setBool(_keyOcultarCompletados, valor);
  }

  static Future<bool> getOcultarCompletados() async {
    final prefs = await _instance;
    return prefs.getBool(_keyOcultarCompletados) ?? false;
  }

  // ---------------------------------------------------------------------------
  // GESTIÓN DE HÁBITOS SERIALIZADOS
  // ---------------------------------------------------------------------------
  static Future<void> guardarHabitos(List<Habito> habitos) async {
    final prefs = await _instance;
    List<String> habitosJson = habitos.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList(_keyHabitos, habitosJson);
  }

  static Future<List<Habito>> getHabitos() async {
    final prefs = await _instance;
    List<String>? habitosJson = prefs.getStringList(_keyHabitos);

    if (habitosJson == null) return [];

    return habitosJson
        .map((item) => Habito.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // REINICIALIZAR APP
  // ---------------------------------------------------------------------------
  static Future<void> borrarTodo() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}