import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required String id,
    required String uidPrestador,
    required String titulo,
    required String descricao,
    required String categoria,
    required double preco,
    required String cidade,
    required String estado,
    String? imagemUrl,
    DateTime? criadoEm,
  }) : super(
          id: id,
          uidPrestador: uidPrestador,
          titulo: titulo,
          descricao: descricao,
          categoria: categoria,
          preco: preco,
          cidade: cidade,
          estado: estado,
          imagemUrl: imagemUrl,
          criadoEm: criadoEm,
        );

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      uidPrestador: map['uidPrestador'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      categoria: map['categoria'],
      preco: map['preco'] != null ? (map['preco'] as num).toDouble() : 0.0,
      cidade: map['cidade'],
      estado: map['estado'],
      imagemUrl: map['imagemUrl'],
      criadoEm:
          map['criadoEm'] != null ? DateTime.parse(map['criadoEm']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uidPrestador': uidPrestador,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'preco': preco,
      'cidade': cidade,
      'estado': estado,
      'imagemUrl': imagemUrl,
      'criadoEm': criadoEm?.toIso8601String(),
    };
  }
}
