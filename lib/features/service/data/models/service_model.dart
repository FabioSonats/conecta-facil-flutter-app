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
    // Tratamento mais robusto para o campo preco
    double preco = 0.0;
    if (map['preco'] != null) {
      if (map['preco'] is num) {
        preco = (map['preco'] as num).toDouble();
      } else if (map['preco'] is String) {
        preco = double.tryParse(map['preco'] as String) ?? 0.0;
      }
    }

    return ServiceModel(
      id: map['id']?.toString() ?? '',
      uidPrestador: map['uidPrestador']?.toString() ?? '',
      titulo: map['titulo']?.toString() ?? 'Sem título',
      descricao: map['descricao']?.toString() ?? '',
      categoria: map['categoria']?.toString() ?? '',
      preco: preco,
      cidade: map['cidade']?.toString() ?? '',
      estado: map['estado']?.toString() ?? '',
      imagemUrl: map['imagemUrl']?.toString(),
      criadoEm: map['criadoEm'] != null
          ? DateTime.tryParse(map['criadoEm'].toString())
          : null,
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
