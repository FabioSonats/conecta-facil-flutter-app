import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String uid,
    required String nome,
    required String email,
    required String tipoPerfil,
    String? telefone,
    String? cidade,
    String? estado,
    String? fotoPerfilUrl,
    DateTime? criadoEm,
  }) : super(
          uid: uid,
          nome: nome,
          email: email,
          tipoPerfil: tipoPerfil,
          telefone: telefone,
          cidade: cidade,
          estado: estado,
          fotoPerfilUrl: fotoPerfilUrl,
          criadoEm: criadoEm,
        );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        uid: map['uid']?.toString() ?? '',
        nome: map['nome']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        tipoPerfil: map['tipoPerfil']?.toString() ?? 'contratante',
        telefone: map['telefone']?.toString(),
        cidade: map['cidade']?.toString(),
        estado: map['estado']?.toString(),
        fotoPerfilUrl: map['fotoPerfilUrl']?.toString(),
        criadoEm: map['criadoEm'] != null
            ? DateTime.tryParse(map['criadoEm'].toString())
            : null,
      );
    } catch (e) {
      print('Erro ao criar UserModel.fromMap: $e');
      print('Dados recebidos: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'tipoPerfil': tipoPerfil,
      'telefone': telefone,
      'cidade': cidade,
      'estado': estado,
      'fotoPerfilUrl': fotoPerfilUrl,
      'criadoEm': criadoEm?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? nome,
    String? email,
    String? tipoPerfil,
    String? telefone,
    String? cidade,
    String? estado,
    String? fotoPerfilUrl,
    DateTime? criadoEm,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      tipoPerfil: tipoPerfil ?? this.tipoPerfil,
      telefone: telefone ?? this.telefone,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      fotoPerfilUrl: fotoPerfilUrl ?? this.fotoPerfilUrl,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      nome: entity.nome,
      email: entity.email,
      tipoPerfil: entity.tipoPerfil,
      telefone: entity.telefone,
      cidade: entity.cidade,
      estado: entity.estado,
      fotoPerfilUrl: entity.fotoPerfilUrl,
      criadoEm: entity.criadoEm,
    );
  }
}
