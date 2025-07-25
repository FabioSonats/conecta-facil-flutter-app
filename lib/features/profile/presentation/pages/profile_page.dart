import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserEntity? user;
        if (state is AuthAuthenticated) {
          user = state.user;
        }
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
          ),
          body: Center(
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
        );
      },
    );
  }
}
