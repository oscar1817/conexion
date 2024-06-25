import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avistamientos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List avistamientos = [];

  @override
  void initState() {
    super.initState();
    fetchAvistamientos();
  }

  fetchAvistamientos() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:3306/avistamientos_general'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        avistamientos = data['baul'];
      });
    } else {
      throw Exception('Error al cargar los avistamientos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avistamientos'),
      ),
      body: avistamientos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: avistamientos.length,
              itemBuilder: (context, index) {
                var avistamiento = avistamientos[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Ubicación: ${avistamiento['ubicacion']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hora: ${avistamiento['hora']}'),
                        Text('Aspecto: ${avistamiento['aspecto']}'),
                        Text('Atacó: ${avistamiento['ataco']}'),
                      ],
                    ),
                    // Aquí puedes agregar más detalles o un botón para ver la imagen
                  ),
                );
              },
            ),
    );
  }
}
