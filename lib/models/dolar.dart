class Dolar {
  final String nombre;
  final double compra;
  final double venta;

  Dolar({required this.nombre, required this.compra, required this.venta});

  // Método para convertir el JSON en un objeto Dolar
  factory Dolar.fromJson(Map<String, dynamic> json) {
    return Dolar(
      nombre: json['nombre'],
      compra: double.tryParse(json['compra'].toString()) ?? 0.0,
      venta: double.tryParse(json['venta'].toString()) ?? 0.0,
    );
  }
}
