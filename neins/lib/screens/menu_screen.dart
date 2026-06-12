import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'clientes_screen.dart';
import 'productos_screen.dart';
import 'fiados_screen.dart';

class MenuScreen extends StatelessWidget {
  final String nombre;
  final String rol;

  const MenuScreen({super.key, required this.nombre, required this.rol});

  @override
  Widget build(BuildContext context) {
    final opciones = [
      _Opcion('Clientes', Icons.people, Colors.blue, const ClientesScreen()),
      _Opcion('Productos', Icons.inventory_2, Colors.green, const ProductosScreen()),
      _Opcion('Fiados', Icons.receipt_long, Colors.orange, const FiadosScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $nombre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: opciones.map((o) => _MenuCard(opcion: o)).toList(),
        ),
      ),
    );
  }
}

class _Opcion {
  final String titulo;
  final IconData icono;
  final Color color;
  final Widget pantalla;
  _Opcion(this.titulo, this.icono, this.color, this.pantalla);
}

class _MenuCard extends StatelessWidget {
  final _Opcion opcion;
  const _MenuCard({required this.opcion});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => opcion.pantalla),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(opcion.icono, size: 48, color: opcion.color),
            const SizedBox(height: 12),
            Text(opcion.titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}