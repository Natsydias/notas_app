class Nota {
  int? id;
  String titulo;
  String contenido;
  String fecha;

  Nota({this.id, required this.titulo, required this.contenido, required this.fecha});

  factory Nota.fromMap(Map<String, dynamic> json) => Nota(
        id: json['id'],
        titulo: json['titulo'],
        contenido: json['contenido'],
        fecha: json['fecha'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'fecha': fecha,
    };
  }
}
