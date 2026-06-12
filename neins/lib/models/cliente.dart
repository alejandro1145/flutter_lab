class Cliente {
  final int idCliente;
  final String nombre;
  final String telefono;
  final String identificacion;
  final String cupoCredito;

  Cliente({
    required this.idCliente,
    required this.nombre,
    required this.telefono,
    required this.identificacion,
    required this.cupoCredito,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['id_cliente'],
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
      identificacion: json['identificacion'] ?? '',
      cupoCredito: json['cupo_credito']?.toString() ?? '0',
    );
  }
}