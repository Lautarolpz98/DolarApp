import 'dart:async';
import 'package:dolar_app/models/dolar.dart';
import 'package:dolar_app/services/dolar_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:intl/intl.dart'; // Para formatear las fechas

class DolarScreen extends StatefulWidget {
  @override
  _DolarScreenState createState() => _DolarScreenState();
}

class _DolarScreenState extends State<DolarScreen> {
  List<Dolar> dolares = [];
  bool isLoading = true;
  String errorMessage = '';
  Timer? _timer; // Variable para el temporizador
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String lastUpdatedTime =
      ''; // Variable para almacenar la última hora de actualización

  @override
  void initState() {
    super.initState();
    _fetchDolarData();

    // Iniciar el temporizador para actualizar los datos cada 30 minutos
    _timer =
        Timer.periodic(Duration(minutes: 1), (Timer t) => _fetchDolarData());
  }

  @override
  void dispose() {
    // Cancelamos el temporizador cuando el widget se destruye para evitar fugas de memoria
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDolarData() async {
    try {
      final dolarData = await DolarApiService.fetchDolarData();
      setState(() {
        dolares = dolarData;
        isLoading = false;
        // Actualizamos la hora de la última actualización (hora y minutos)
        lastUpdatedTime = DateFormat('HH:mm').format(DateTime.now());
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar los datos: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true; // Mostrar el indicador de carga
    });
    await _fetchDolarData(); // Actualizar los datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Título con solo padding en el top
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, bottom: 10), // Solo padding en el top
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Dólar en Argentina',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage.isNotEmpty)
                Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)))
              else if (dolares.isEmpty)
                Center(child: Text('No se encontraron datos.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: dolares.length,
                    itemBuilder: (context, index) {
                      final dolar = dolares[index];

                      // Formateamos la fecha actual al formato dd/MM/yyyy
                      DateTime fecha = DateTime.now();
                      String fechaFormateada =
                          DateFormat('dd/MM/yyyy').format(fecha);

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      dolar.nombre,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Fecha: $fechaFormateada',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Solo mostramos la hora y los minutos
                                    Text(
                                      lastUpdatedTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Compra',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '\$${dolar.compra.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Venta',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '\$${dolar.venta.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Datos obtenidos de ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final url = 'https://dolarapi.com';
                        try {
                          await FlutterWebBrowser.openWebPage(
                            url: url,
                            customTabsOptions: CustomTabsOptions(
                              colorScheme: CustomTabsColorScheme.dark,
                              toolbarColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          print('Error al abrir la URL: $e');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'DolarAPI.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
