import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registrarse() async {
    final usuario = _usuarioController.text.trim();
    final password = _passwordController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 1. Identificar si se está registrando la cuenta de Administrador
    final esAdmin = (usuario.toLowerCase() == 'admin' && password == 'admin123');

    // 2. Guardar el nuevo usuario y rol en SharedPreferences
    await PreferenciasService.setNombreUsuario(usuario);
    await PreferenciasService.setEsAdmin(esAdmin);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta creada con éxito. Ahora puedes iniciar sesión.'),
        backgroundColor: Colors.green,
      ),
    );

    // 3. Volver a la pantalla de Inicio de Sesión
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CampoTextoApp(
                etiqueta: 'Nombre de usuario',
                controller: _usuarioController,
              ),
              CampoTextoApp(
                etiqueta: 'Contraseña',
                controller: _passwordController,
                ocultarTexto: true,
              ),
              const SizedBox(height: 20),
              BotonPrincipal(
                texto: 'Crear Cuenta',
                onPressed: _registrarse,
              ),
            ],
          ),
        ),
      ),
    );
  }
}