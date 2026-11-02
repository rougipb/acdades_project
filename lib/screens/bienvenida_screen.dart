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

    // 1. Validar que los campos no estén vacíos
    if (usuarioIngresado.isEmpty || passwordIngresada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan datos por rellenar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 2. Obtener datos guardados en SharedPreferences
    final usuarioGuardado = await PreferenciasService.getNombreUsuario();
    final passwordGuardada = await PreferenciasService.getPasswordUsuario();

    // 3. Casos especiales para el Administrador genérico (si entra directo como admin)
    if (usuarioIngresado.toLowerCase() == 'admin' && passwordIngresada == 'admin123') {
      await PreferenciasService.setNombreUsuario('admin');
      await PreferenciasService.setEsAdmin(true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    // 4. Si no hay ningún usuario registrado en la base de datos local
    if (usuarioGuardado == null || usuarioGuardado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No existe ninguna cuenta registrada. Regístrate primero.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 5. Comprobar si las credenciales coinciden con las registradas
    if (usuarioIngresado != usuarioGuardado || passwordIngresada != passwordGuardada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o contraseña incorrectos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Si todo es correcto, permite entrar
    if (!mounted) return;
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