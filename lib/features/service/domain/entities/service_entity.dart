class ServiceEntity {
  final String id;
  final String uidPrestador;
  final String titulo;
  final String descricao;
  final String categoria;
  final double preco;
  final String cidade;
  final String estado;
  final String? imagemUrl;
  final DateTime? criadoEm;

  ServiceEntity({
    required this.id,
    required this.uidPrestador,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.preco,
    required this.cidade,
    required this.estado,
    this.imagemUrl,
    this.criadoEm,
  });
} 