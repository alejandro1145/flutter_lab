import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late Future<List<Producto>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futureProductos = ApiService.getProductos();
  }

  void _refrescar() => setState(_cargar);

  void _abrirFormulario({Producto? producto}) {
    final nombreCtrl = TextEditingController(text: producto?.nombre);
    final precioCtrl = TextEditingController(text: producto?.precio.toString());
    final stockCtrl = TextEditingController(text: producto?.stock.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(producto == null ? 'Nuevo producto' : 'Editar producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: precioCtrl, decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number),
              TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              final ok = await ApiService.guardarProducto(
                idProducto: producto?.idProducto,
                nombre: nombreCtrl.text,
                precio: double.tryParse(precioCtrl.text) ?? 0,
                stock: int.tryParse(stockCtrl.text) ?? 0,
              );
              if (ok && context.mounted) {
                Navigator.pop(context);
                _refrescar();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final productos = snapshot.data ?? [];
          if (productos.isEmpty) {
            return const Center(child: Text('No hay productos registrados'));
          }
          return RefreshIndicator(
            onRefresh: () async => _refrescar(),
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) {
                final p = productos[i];
                return Dismissible(
                  key: ValueKey(p.idProducto),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await ApiService.eliminarProducto(p.idProducto);
                    return true;
                  },
                  onDismissed: (_) => _refrescar(),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
                    title: Text(p.nombre),
                    subtitle: Text('Stock: ${p.stock}'),
                    trailing: Text('\$${p.precio.toStringAsFixed(2)}'),
                    onTap: () => _abrirFormulario(producto: p),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}