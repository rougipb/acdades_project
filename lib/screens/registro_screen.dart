import 'package:flutter/material.dart';
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

  void _registrarse() {
    if (_usuarioController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // Guardar el registro a través del servicio y volver
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            BotonPrincipal(
              texto: 'Crear Cuenta',
              onPressed: _registrarse,
            ),
          ],
        ),
      ),
    );
  }
}