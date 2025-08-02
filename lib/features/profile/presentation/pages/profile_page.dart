import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;
  const ProfilePage({super.key, this.userId});

  Future<UserEntity?> _fetchUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return UserEntity(
      uid: data['uid'],
      nome: data['nome'],
      email: data['email'],
      tipoPerfil: data['tipoPerfil'],
      telefone: data['telefone'],
      cidade: data['cidade'],
      estado: data['estado'],
      fotoPerfilUrl: data['fotoPerfilUrl'],
      criadoEm:
          data['criadoEm'] != null ? DateTime.tryParse(data['criadoEm']) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId != null) {
      return FutureBuilder<UserEntity?>(
        future: _fetchUser(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Scaffold(
                body: Center(child: Text('Usuário não encontrado.')));
          }
          return _ProfileContent(user: snapshot.data!);
        },
      );
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserEntity? user;
        if (state is AuthAuthenticated) {
          user = state.user;
        }
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _ProfileContent(user: user);
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserEntity user;
  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.uid ==
                (BlocProvider.of<AuthBloc>(context).state is AuthAuthenticated
                    ? (BlocProvider.of<AuthBloc>(context).state
                            as AuthAuthenticated)
                        .user
                        .uid
                    : '')
            ? 'Meu Perfil'
            : 'Perfil do Profissional'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.fotoPerfilUrl != null &&
                              user.fotoPerfilUrl!.isNotEmpty
                          ? NetworkImage(user.fotoPerfilUrl!)
                          : null,
                      child: user.fotoPerfilUrl == null ||
                              user.fotoPerfilUrl!.isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(user.nome,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(user.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text('Perfil: ${user.tipoPerfil}'),
                    const SizedBox(height: 8),
                    if (user.telefone != null && user.telefone!.isNotEmpty)
                      Text('Telefone: ${user.telefone}'),
                    if (user.cidade != null && user.cidade!.isNotEmpty)
                      Text('Cidade: ${user.cidade}'),
                    if (user.estado != null && user.estado!.isNotEmpty)
                      Text('Estado: ${user.estado}'),
                    const SizedBox(height: 24),
                    if (user.uid ==
                        (BlocProvider.of<AuthBloc>(context).state
                                is AuthAuthenticated
                            ? (BlocProvider.of<AuthBloc>(context).state
                                    as AuthAuthenticated)
                                .user
                                .uid
                            : ''))
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implementar edição de perfil
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar perfil'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
