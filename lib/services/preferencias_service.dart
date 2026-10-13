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
  static Future<SharedPreferences> get _instance async {      _prefs ??= await SharedPreferences.getInstance();
  return _prefs!;
  }

  // ---------------------------------------------------------------------------
  // REGISTRO DE APERTURAS (Muestra uso de int y String)
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

  // ---------------------------------------------------------------------------
  // DATOS DE USUARIO (Muestra uso de String e int)
  // ---------------------------------------------------------------------------
  static Future<void> guardarUsuario(String nombre, int objetivo) async {
    final prefs = await _instance;
    await prefs.setString(_keyNombreUsuario, nombre);
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
  // AJUSTES DE APARIENCIA (Muestra uso de bool y double)
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
  // GESTIÓN DE HÁBITOS SERIALIZADOS (Muestra uso de List<String> con JSON)
  // ---------------------------------------------------------------------------
  static Future<void> guardarHabitos(List<Habito> habitos) async {
    final prefs = await _instance;
    // Mapeamos cada objeto Habito a un String en formato JSON mediante jsonEncode
    List<String> habitosJson = habitos.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList(_keyHabitos, habitosJson);
  }

  static Future<List<Habito>> getHabitos() async {
    final prefs = await _instance;
    List<String>? habitosJson = prefs.getStringList(_keyHabitos);

    if (habitosJson == null) return [];

    // Reconstruimos los objetos Habito desde JSON usando jsonDecode
    return habitosJson
        .map((item) => Habito.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // REINICIALIZAR APP (Borrado completo)
  // ---------------------------------------------------------------------------
  static Future<void> borrarTodo() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}