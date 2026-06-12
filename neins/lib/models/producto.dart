class Producto {
  final int idProducto;
  final String nombre;
  final double precio;
  final int stock;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.precio,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }
}