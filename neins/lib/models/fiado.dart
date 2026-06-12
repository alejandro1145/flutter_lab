class Fiado {
  final int idFiado;
  final String fechaFiado;
  final String fechaLimitePago;
  final String? fechaPago;
  final double valor;
  final int idCliente;
  final int idMedioPago;
  final String nombreCliente;
  final String medioPago;

  Fiado({
    required this.idFiado,
    required this.fechaFiado,
    required this.fechaLimitePago,
    this.fechaPago,
    required this.valor,
    required this.idCliente,
    required this.idMedioPago,
    required this.nombreCliente,
    required this.medioPago,
  });

  factory Fiado.fromJson(Map<String, dynamic> json) {
    return Fiado(
      idFiado: json['id_fiado'],
      fechaFiado: json['fecha_fiado'] ?? '',
      fechaLimitePago: json['fecha_limite_pago'] ?? '',
      fechaPago: json['fecha_pago'],
      valor: (json['valor'] as num).toDouble(),
      idCliente: json['id_cliente'],
      idMedioPago: json['id_medio_pago'],
      nombreCliente: json['nombre_cliente'] ?? '',
      medioPago: json['medio_pago'] ?? '',
    );
  }
}