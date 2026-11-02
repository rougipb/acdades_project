import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';
import 'home_screen.dart';
import 'registro_screen.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  final TextEditingController _usuarioCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  static const Color colorNaranjaOscuro = Colors.deepOrange;

  Future<void> _iniciarSesion() async {
    final usuarioIngresado = _usuarioCtrl.text.trim();
    final passwordIngresada = _passwordCtrl.text.trim();

    if (usuarioIngresado.isEmpty || passwordIngresada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Identificar si es cuenta de administrador
    final esAdmin = (usuarioIngresado.toLowerCase() == 'admin' && passwordIngresada == 'admin123');

    // Guardar usuario y rol en SharedPreferences
    await PreferenciasService.setNombreUsuario(usuarioIngresado);
    await PreferenciasService.setEsAdmin(esAdmin);

    if (!mounted) return;

    // Navegar a la pantalla principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'HabitosApp',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorNaranjaOscuro,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para gestionar tus hábitos',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Campo 1: Usuario
                CampoTextoApp(
                  etiqueta: 'Nombre de usuario',
                  controller: _usuarioCtrl,
                ),

                // Campo 2: Contraseña
                CampoTextoApp(
                  etiqueta: 'Contraseña',
                  controller: _passwordCtrl,
                  ocultarTexto: true,
                ),
                const SizedBox(height: 20),

                // Botón principal reutilizable
                BotonPrincipal(
                  texto: 'Iniciar Sesión',
                  onPressed: _iniciarSesion,
                ),

                const SizedBox(height: 10),

                // Botón alternativo de registro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegistroScreen()),
                    );
                  },
                  child: const Text('¿No tienes cuenta? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}