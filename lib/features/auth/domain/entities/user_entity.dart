class UserEntity {
  final String uid;
  final String nome;
  final String email;
  final String tipoPerfil;
  final String? telefone;
  final String? cidade;
  final String? estado;
  final String? fotoPerfilUrl;
  final DateTime? criadoEm;

  UserEntity({
    required this.uid,
    required this.nome,
    required this.email,
    required this.tipoPerfil,
    this.telefone,
    this.cidade,
    this.estado,
    this.fotoPerfilUrl,
    this.criadoEm,
  });
} 