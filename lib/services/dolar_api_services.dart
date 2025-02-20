import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dolar_app/models/dolar.dart';

class DolarApiService {
  static const String _url = 'https://dolarapi.com/v1/dolares';

  static Future<List<Dolar>> fetchDolarData() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Dolar.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los datos');
    }
  }
}
