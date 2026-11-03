import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/database_helper.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _rolSeleccionado = 'usuario';

  Future<void> _registrarse() async {
    final usuarioTxt = _usuarioController.text.trim();
    final nombreTxt = _nombreController.text.trim();
    final apellidosTxt = _apellidosController.text.trim();
    final emailTxt = _emailController.text.trim();
    final passwordTxt = _passwordController.text.trim();

    if (usuarioTxt.isEmpty ||
        nombreTxt.isEmpty ||
        apellidosTxt.isEmpty ||
        emailTxt.isEmpty ||
        passwordTxt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nuevoUsuario = Usuario(
      usuario: usuarioTxt,
      nombre: nombreTxt,
      apellidos: apellidosTxt,
      email: emailTxt,
      contrasena: passwordTxt,
      fechaCreacion: DateTime.now().toIso8601String(),
      rol: _rolSeleccionado,
    );

    try {
      await DatabaseHelper.instance.insertUsuario(nuevoUsuario);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta registrada con éxito en la base de datos.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar usuario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
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
                etiqueta: 'Nombre de Usuario',
                controller: _usuarioController,
              ),
              CampoTextoApp(
                etiqueta: 'Nombre',
                controller: _nombreController,
              ),
              CampoTextoApp(
                etiqueta: 'Apellidos',
                controller: _apellidosController,
              ),
              CampoTextoApp(
                etiqueta: 'Correo Electrónico',
                controller: _emailController,
              ),
              CampoTextoApp(
                etiqueta: 'Contraseña',
                controller: _passwordController,
                ocultarTexto: true,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _rolSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Rol de Usuario',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'usuario',
                    child: Text('Usuario'),
                  ),
                  DropdownMenuItem(
                    value: 'administrador',
                    child: Text('Administrador'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _rolSeleccionado = value;
                    });
                  }
                },
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