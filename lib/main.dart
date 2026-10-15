import 'package:flutter/material.dart';
import 'services/preferencias_service.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/home_screen.dart';s

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasService.registrarApertura();
  runApp(const HabitosApp());
}

class HabitosApp extends StatefulWidget {
  const HabitosApp({super.key});

  static _HabitosAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HabitosAppState>();

  @override
  State<HabitosApp> createState() => _HabitosAppState();
}

class _HabitosAppState extends State<HabitosApp> {
  bool _modoOscuro = false;
  double _tamanoLetra = 16.0;
  bool _cargando = true;
  bool _yaRegistrado = false;

  @override
  void initState() {
    super.initState();
    recargarAjustes();
  }

  Future<void> recargarAjustes() async {
    final oscuro = await PreferenciasService.getModoOscuro();
    final tamano = await PreferenciasService.getTamanoLetra();
    final nombre = await PreferenciasService.getNombreUsuario();

    setState(() {
      _modoOscuro = oscuro;
      _tamanoLetra = tamano;
      _yaRegistrado = nombre != null && nombre.isNotEmpty;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'HabitosApp',
      debugShowCheckedModeBanner: false,
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Escalamos la letra globalmente mediante textScaler en lugar de apply()
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(_tamanoLetra / 16.0),
          ),
          child: child!,
        );
      },
      home: _yaRegistrado ? const HomeScreen() : const BienvenidaScreen(),
    );
  }
}