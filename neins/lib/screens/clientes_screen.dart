import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  late Future<List<Cliente>> _futureClientes;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futureClientes = ApiService.getClientes();
  }

  void _refrescar() => setState(_cargar);

  void _abrirFormulario({Cliente? cliente}) {
    final nombreCtrl = TextEditingController(text: cliente?.nombre);
    final telefonoCtrl = TextEditingController(text: cliente?.telefono);
    final identCtrl = TextEditingController(text: cliente?.identificacion);
    final cupoCtrl = TextEditingController(text: cliente?.cupoCredito);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cliente == null ? 'Nuevo cliente' : 'Editar cliente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: 'Teléfono')),
              TextField(controller: identCtrl, decoration: const InputDecoration(labelText: 'Identificación')),
              TextField(controller: cupoCtrl, decoration: const InputDecoration(labelText: 'Cupo de crédito'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              final ok = await ApiService.guardarCliente(
                idCliente: cliente?.idCliente,
                nombre: nombreCtrl.text,
                telefono: telefonoCtrl.text,
                identificacion: identCtrl.text,
                cupoCredito: cupoCtrl.text,
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
      appBar: AppBar(title: const Text('Clientes')),
      body: FutureBuilder<List<Cliente>>(
        future: _futureClientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final clientes = snapshot.data ?? [];
          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados'));
          }
          return RefreshIndicator(
            onRefresh: () async => _refrescar(),
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, i) {
                final c = clientes[i];
                return Dismissible(
                  key: ValueKey(c.idCliente),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await ApiService.eliminarCliente(c.idCliente);
                    return true;
                  },
                  onDismissed: (_) => _refrescar(),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(c.nombre),
                    subtitle: Text('Tel: ${c.telefono} · ID: ${c.identificacion}'),
                    trailing: Text('\$${c.cupoCredito}'),
                    onTap: () => _abrirFormulario(cliente: c),
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