import 'package:flutter/material.dart';
import '../models/fiado.dart';
import '../services/api_service.dart';

class FiadosScreen extends StatefulWidget {
  const FiadosScreen({super.key});

  @override
  State<FiadosScreen> createState() => _FiadosScreenState();
}

class _FiadosScreenState extends State<FiadosScreen> {
  late Future<List<Fiado>> _futureFiados;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futureFiados = ApiService.getFiados();
  }

  void _refrescar() => setState(_cargar);

  Future<void> _seleccionarFecha(TextEditingController ctrl) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (fecha != null) {
      ctrl.text =
          '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    }
  }

  void _abrirFormulario({Fiado? fiado}) {
    final fechaFiadoCtrl = TextEditingController(text: fiado?.fechaFiado);
    final fechaLimiteCtrl = TextEditingController(text: fiado?.fechaLimitePago);
    final valorCtrl = TextEditingController(text: fiado?.valor.toString());
    final idClienteCtrl = TextEditingController(text: fiado?.idCliente.toString());
    final idMedioPagoCtrl = TextEditingController(text: fiado?.idMedioPago.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(fiado == null ? 'Nuevo fiado' : 'Editar fiado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fechaFiadoCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Fecha del fiado'),
                onTap: () => _seleccionarFecha(fechaFiadoCtrl),
              ),
              TextField(
                controller: fechaLimiteCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Fecha límite de pago'),
                onTap: () => _seleccionarFecha(fechaLimiteCtrl),
              ),
              TextField(controller: valorCtrl, decoration: const InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number),
              TextField(controller: idClienteCtrl, decoration: const InputDecoration(labelText: 'ID Cliente'),
                  keyboardType: TextInputType.number),
              TextField(controller: idMedioPagoCtrl, decoration: const InputDecoration(labelText: 'ID Medio de pago (1=Efectivo, 2=Transferencia, 3=Nequi, 4=Daviplata)'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              final ok = await ApiService.guardarFiado(
                idFiado: fiado?.idFiado,
                fechaFiado: fechaFiadoCtrl.text,
                fechaLimitePago: fechaLimiteCtrl.text,
                fechaPago: fiado?.fechaPago,
                valor: double.tryParse(valorCtrl.text) ?? 0,
                idCliente: int.tryParse(idClienteCtrl.text) ?? 0,
                idMedioPago: int.tryParse(idMedioPagoCtrl.text) ?? 0,
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
      appBar: AppBar(title: const Text('Fiados')),
      body: FutureBuilder<List<Fiado>>(
        future: _futureFiados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final fiados = snapshot.data ?? [];
          if (fiados.isEmpty) {
            return const Center(child: Text('No hay fiados registrados'));
          }
          return RefreshIndicator(
            onRefresh: () async => _refrescar(),
            child: ListView.builder(
              itemCount: fiados.length,
              itemBuilder: (context, i) {
                final f = fiados[i];
                return Dismissible(
                  key: ValueKey(f.idFiado),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await ApiService.eliminarFiado(f.idFiado);
                    return true;
                  },
                  onDismissed: (_) => _refrescar(),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                    title: Text(f.nombreCliente.isNotEmpty ? f.nombreCliente : 'Cliente #${f.idCliente}'),
                    subtitle: Text('Vence: ${f.fechaLimitePago} · ${f.medioPago}'),
                    trailing: Text('\$${f.valor.toStringAsFixed(2)}'),
                    onTap: () => _abrirFormulario(fiado: f),
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