class Peso {
  final int? id;
  final int? usuarioId;
  final double peso;
  final String data;

  Peso({this.id, this.usuarioId, required this.peso, required this.data});

  factory Peso.fromMap(Map<String, dynamic> map) {
    return Peso(
      id: map['id'],
      usuarioId: map['usuario_id'],
      peso: map['peso'],
      data: map['data'],
    );
  }
}
