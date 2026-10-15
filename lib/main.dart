import 'package:flutter/material.dart';
import 'services/preferencias_service.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Asegura que las llamadas asíncronas de Flutter estén inicializadas
  WidgetsFlutterBinding.ensureInitialized();

  // Registramos la apertura de la app (cuenta aperturas y guarda fecha/hora)
  await PreferenciasService.registrarApertura();

  // Comprobamos si el usuario ya registró su nombre
  final String? nombre = await PreferenciasService.getNombreUsuario();
  final bool yaRegistrado = nombre != null && nombre.isNotEmpty;

  runApp(HabitosApp(yaRegistrado: yaRegistrado));
}

class HabitosApp extends StatelessWidget {
  final bool yaRegistrado;

  const HabitosApp({super.key, required this.yaRegistrado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitosApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Si ya está registrado abre HomeScreen, si no, BienvenidaScreen
      home: yaRegistrado ? const HomeScreen() : BienvenidaScreen(),
    );
  }
}