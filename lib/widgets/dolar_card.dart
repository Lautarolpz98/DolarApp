import 'package:flutter/material.dart';
import '../models/dolar.dart';

class DolarCard extends StatelessWidget {
  final Dolar dolar;

  const DolarCard({required this.dolar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          dolar.nombre,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Compra: \$${dolar.compra} | Venta: \$${dolar.venta}'),
      ),
    );
  }
}
