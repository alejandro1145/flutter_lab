import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import '../models/producto.dart';
import '../models/fiado.dart';

class ApiService {
  // 10.0.2.2 = localhost de tu computador, visto desde el emulador de Android
  static const String baseUrl = 'http://localhost:8080/Neins/api';

  // ---------- LOGIN ----------
  static Future<Map<String, dynamic>> login(String correo, String clave) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'correo': correo, 'clave': clave},
    );
    return jsonDecode(res.body);
  }

  // ---------- CLIENTES ----------
  static Future<List<Cliente>> getClientes() async {
    final res = await http.get(Uri.parse('$baseUrl/clientes'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Cliente.fromJson(e)).toList();
  }

  static Future<bool> guardarCliente({
    int? idCliente,
    required String nombre,
    required String telefono,
    required String identificacion,
    required String cupoCredito,
  }) async {
    final body = {
      'accion': idCliente == null ? 'insertar' : 'actualizar',
      'nombre': nombre,
      'telefono': telefono,
      'identificacion': identificacion,
      'cupo_credito': cupoCredito,
      if (idCliente != null) 'id_cliente': idCliente.toString(),
    };
    final res = await http.post(Uri.parse('$baseUrl/clientes'), body: body);
    return jsonDecode(res.body)['ok'] == true;
  }

  static Future<bool> eliminarCliente(int idCliente) async {
    final res = await http.post(Uri.parse('$baseUrl/clientes'), body: {
      'accion': 'eliminar',
      'id_cliente': idCliente.toString(),
    });
    return jsonDecode(res.body)['ok'] == true;
  }

  // ---------- PRODUCTOS ----------
  static Future<List<Producto>> getProductos() async {
    final res = await http.get(Uri.parse('$baseUrl/productos'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Producto.fromJson(e)).toList();
  }

  static Future<bool> guardarProducto({
    int? idProducto,
    required String nombre,
    required double precio,
    required int stock,
  }) async {
    final body = {
      'accion': idProducto == null ? 'insertar' : 'actualizar',
      'nombre': nombre,
      'precio': precio.toString(),
      'stock': stock.toString(),
      if (idProducto != null) 'id_producto': idProducto.toString(),
    };
    final res = await http.post(Uri.parse('$baseUrl/productos'), body: body);
    return jsonDecode(res.body)['ok'] == true;
  }

  static Future<bool> eliminarProducto(int idProducto) async {
    final res = await http.post(Uri.parse('$baseUrl/productos'), body: {
      'accion': 'eliminar',
      'id_producto': idProducto.toString(),
    });
    return jsonDecode(res.body)['ok'] == true;
  }

  // ---------- FIADOS ----------
  static Future<List<Fiado>> getFiados() async {
    final res = await http.get(Uri.parse('$baseUrl/fiados'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Fiado.fromJson(e)).toList();
  }

  static Future<bool> guardarFiado({
    int? idFiado,
    required String fechaFiado,
    required String fechaLimitePago,
    String? fechaPago,
    required double valor,
    required int idCliente,
    required int idMedioPago,
  }) async {
    final body = {
      'accion': idFiado == null ? 'insertar' : 'actualizar',
      'fecha_fiado': fechaFiado,
      'fecha_limite_pago': fechaLimitePago,
      'fecha_pago': fechaPago ?? '',
      'valor': valor.toString(),
      'id_cliente': idCliente.toString(),
      'id_medio_pago': idMedioPago.toString(),
      if (idFiado != null) 'id_fiado': idFiado.toString(),
    };
    final res = await http.post(Uri.parse('$baseUrl/fiados'), body: body);
    return jsonDecode(res.body)['ok'] == true;
  }

  static Future<bool> eliminarFiado(int idFiado) async {
    final res = await http.post(Uri.parse('$baseUrl/fiados'), body: {
      'accion': 'eliminar',
      'id_fiado': idFiado.toString(),
    });
    return jsonDecode(res.body)['ok'] == true;
  }
}