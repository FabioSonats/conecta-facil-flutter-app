import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/contratante_home.dart';
import '../widgets/prestador_home.dart';
import 'prestador_servicos_page.dart';
import 'contratante_busca_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          UserEntity? user;
          if (state is AuthAuthenticated) {
            user = state.user;
          }
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final tipoPerfil = user.tipoPerfil;
          final cidade = user.cidade;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 800;
              return ValueListenableBuilder<int>(
                valueListenable: _selectedIndex,
                builder: (context, selectedIndex, _) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Conecta Fácil'),
                      actions: [
                        if (isDesktop && tipoPerfil == 'contratante') ...[
                          TextButton(
                            onPressed: () => _selectedIndex.value = 1,
                            child: const Text('Serviços',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () => _selectedIndex.value = 2,
                            child: const Text('Perfil',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Sair',
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                          },
                        ),
                      ],
                    ),
                    drawer: isDesktop
                        ? null
                        : Drawer(
                            child: ListView(
                              children: [
                                const DrawerHeader(child: Text('Menu')),
                                ListTile(
                                  leading: const Icon(Icons.home),
                                  title: const Text('Início'),
                                  onTap: () {
                                    _selectedIndex.value = 0;
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.build),
                                  title: const Text('Serviços'),
                                  onTap: () {
                                    _selectedIndex.value = 1;
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Perfil'),
                                  onTap: () {
                                    _selectedIndex.value = 2;
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                    body: Row(
                      children: [
                        if (isDesktop)
                          NavigationRail(
                            selectedIndex: selectedIndex,
                            onDestinationSelected: (int index) {
                              _selectedIndex.value = index;
                            },
                            labelType: NavigationRailLabelType.all,
                            destinations: const [
                              NavigationRailDestination(
                                icon: Icon(Icons.home),
                                label: Text('Início'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.build),
                                label: Text('Serviços'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.person),
                                label: Text('Perfil'),
                              ),
                            ],
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _getPage(selectedIndex, tipoPerfil, cidade),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _getPage(int index, String tipoPerfil, String? cidade) {
    // Early return para perfis inválidos
    if (tipoPerfil != 'prestador' && tipoPerfil != 'contratante') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.orange),
            Text('Perfil "$tipoPerfil" não reconhecido'),
          ],
        ),
      );
    }

    // Listas de páginas organizadas
    final prestadorPages = [
      PrestadorHome(),
      const PrestadorServicosPage(),
      const ProfilePage(),
    ];

    final contratantePages = [
      ContratanteHome(cidade: cidade ?? ''),
      const ContratanteBuscaPage(),
      const ProfilePage(),
    ];

    // Seleciona a lista correta e pega a página pelo índice
    final pages = tipoPerfil == 'prestador' ? prestadorPages : contratantePages;
    return pages[index.clamp(0, pages.length - 1)];
  }
}
