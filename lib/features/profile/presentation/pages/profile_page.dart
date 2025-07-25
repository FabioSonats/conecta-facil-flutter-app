import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity? user;
  final String? userId;
  const ProfilePage({super.key, this.user, this.userId});

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
          if (!snapshot.hasData) {
            return const Scaffold(
                body: Center(child: Text('Usuário não encontrado.')));
          }
          if (snapshot.data == null) {
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.fotoPerfilUrl != null &&
                          user.fotoPerfilUrl!.isNotEmpty
                      ? NetworkImage(user.fotoPerfilUrl!)
                      : null,
                  child:
                      user.fotoPerfilUrl == null || user.fotoPerfilUrl!.isEmpty
                          ? const Icon(Icons.person, size: 60)
                          : null,
                ),
                const SizedBox(height: 24),
                Text(
                  user.nome,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, size: 18),
                    const SizedBox(width: 8),
                    Text(user.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      user.tipoPerfil == 'prestador'
                          ? Icons.build
                          : Icons.person,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.tipoPerfil == 'prestador'
                          ? 'Prestador de Serviço'
                          : 'Contratante',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if ((user.cidade?.isNotEmpty ?? false) ||
                    (user.estado?.isNotEmpty ?? false))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${user.cidade ?? ''}${user.cidade != null && user.estado != null ? ', ' : ''}${user.estado ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                if ((user.cidade?.isNotEmpty ?? false) ||
                    (user.estado?.isNotEmpty ?? false))
                  const SizedBox(height: 16),
                if (user.telefone != null && user.telefone!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, size: 18),
                      const SizedBox(width: 8),
                      Text(user.telefone!,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                if (user.telefone != null && user.telefone!.isNotEmpty)
                  const SizedBox(height: 16),
                if (user.tipoPerfil == 'prestador')
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Serviços cadastrados: 0', // Aqui pode puxar do Firestore
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
