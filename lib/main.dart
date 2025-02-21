import 'package:flutter/material.dart';
import 'package:notas_app/database/db_helper.dart';
import 'package:notas_app/nota_model.dart';

void main() {
  runApp(NotasApp());
}

class NotasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotasScreen(),
    );
  }
}

class NotasScreen extends StatefulWidget {
  @override
  _NotasScreenState createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  List<Nota> notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final datos = await DatabaseHelper.instance.getNotas();
    setState(() {
      notas = datos.map((item) => Nota.fromMap(item)).toList();
    });
  }

  Future<void> _agregarNota() async {
    final tituloController = TextEditingController();
    final contenidoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Agregar Nota"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: contenidoController,
              decoration: InputDecoration(labelText: "Contenido"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final nuevaNota = Nota(
                titulo: tituloController.text,
                contenido: contenidoController.text,
                fecha: DateTime.now().toString(),
              );
              await DatabaseHelper.instance.insertNota(nuevaNota.toMap());
              _cargarNotas();
              Navigator.pop(context);
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarNota(int id) async {
    await DatabaseHelper.instance.deleteNota(id);
    _cargarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestor de Notas")),
      body: ListView.builder(
        itemCount: notas.length,
        itemBuilder: (context, index) {
          final nota = notas[index];
          return ListTile(
            title: Text(nota.titulo),
            subtitle: Text(nota.fecha),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _eliminarNota(nota.id!),
            ),
            onTap: () {}, // Aquí puedes agregar una función para editar notas
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarNota,
        child: Icon(Icons.add),
      ),
    );
  }
}
