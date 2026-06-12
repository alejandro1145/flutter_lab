import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  bool _cargando = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final resp = await ApiService.login(_correoCtrl.text.trim(), _claveCtrl.text);
      if (resp['ok'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MenuScreen(
              nombre: resp['nombre'] ?? '',
              rol: resp['rol'] ?? 'cliente',
            ),
          ),
        );
      } else {
        setState(() => _error = resp['mensaje'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      setState(() => _error = 'No se pudo conectar con el servidor');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.store, size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Neins', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const Text('Iniciar sesión'),
              const SizedBox(height: 32),
              TextField(
                controller: _correoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _claveCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _cargando ? null : _login,
                  child: _cargando
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}