import 'package:conecta_facil/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  String _tipoPerfil = 'prestador';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AuthBloc>(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cadastro')),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is AuthAuthenticated) {
              Navigator.of(context).pop(); // Volta para login ou home
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (v) =>
                        v != null && v.contains('@') ? null : 'E-mail inválido',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (v) =>
                        v != null && v.length >= 6 ? null : 'Senha muito curta',
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _tipoPerfil,
                    items: const [
                      DropdownMenuItem(
                          value: 'prestador',
                          child: Text('Prestador de Serviço')),
                      DropdownMenuItem(
                          value: 'contratante', child: Text('Contratante')),
                    ],
                    onChanged: (v) =>
                        setState(() => _tipoPerfil = v ?? 'prestador'),
                    decoration:
                        const InputDecoration(labelText: 'Tipo de Perfil'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cidadeController,
                    decoration: const InputDecoration(labelText: 'Cidade'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _estadoController,
                    decoration: const InputDecoration(labelText: 'Estado'),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final user = UserEntity(
                              uid: '', // será preenchido pelo backend
                              nome: _nomeController.text.trim(),
                              email: _emailController.text.trim(),
                              tipoPerfil: _tipoPerfil,
                              telefone: _telefoneController.text.trim(),
                              cidade: _cidadeController.text.trim(),
                              estado: _estadoController.text.trim(),
                              fotoPerfilUrl: null,
                              criadoEm: DateTime.now(),
                            );
                            context.read<AuthBloc>().add(
                                  AuthSignUpRequested(
                                      user, _senhaController.text.trim()),
                                );
                          }
                        },
                        child: const Text('Cadastrar'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
