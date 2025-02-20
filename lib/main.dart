import 'package:flutter/material.dart';
import 'screens/dolar_screen.dart';

void main() {
  runApp(DolarApp());
}

class DolarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DolarScreen(),
    );
  }
}
