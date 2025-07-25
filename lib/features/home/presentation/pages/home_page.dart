import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

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
          if (state is AuthAuthenticated && state.user != null) {
            user = state.user;
          }
          user ??= UserEntity(
            uid: '',
            nome: 'Usuário',
            email: '',
            tipoPerfil: 'contratante',
            cidade: 'São Paulo',
            estado: 'SP',
          );
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
    switch (index) {
      case 0:
        return tipoPerfil == 'contratante'
            ? _ContratanteHome(cidade: cidade)
            : _PrestadorHome();
      case 1:
        return const Center(child: Text('Página de Serviços (em breve)'));
      case 2:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ContratanteHome extends StatelessWidget {
  final String? cidade;
  const _ContratanteHome({this.cidade});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Barra de pesquisa
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: 500,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar serviço ou profissional...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
              // Categorias populares
              Center(
                child: Text('Categorias populares',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: const [
                  _AnimatedCategoriaCard('Jardinagem', Icons.grass),
                  _AnimatedCategoriaCard('Limpeza', Icons.cleaning_services),
                  _AnimatedCategoriaCard('Elétrica', Icons.electrical_services),
                  _AnimatedCategoriaCard('Pintura', Icons.format_paint),
                  _AnimatedCategoriaCard('Reformas', Icons.construction),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Text('Serviços em destaque',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  _AnimatedServiceCard('Jardinagem', 'São Paulo'),
                  _AnimatedServiceCard('Limpeza', 'Campinas'),
                  _AnimatedServiceCard('Elétrica', 'Santos'),
                ],
              ),
              const SizedBox(height: 40),
              if (cidade != null)
                Center(
                  child: Text('Sugestões em $cidade',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              if (cidade != null)
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: const [
                    _AnimatedServiceCard('Limpeza', 'São Paulo'),
                    _AnimatedServiceCard('Pintura', 'São Paulo'),
                  ],
                ),
              if (cidade != null) const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text('Contratar agora'),
              ),
              const SizedBox(height: 40),
              Card(
                color: Colors.blue.shade50,
                child: const ListTile(
                  leading: Icon(Icons.campaign),
                  title: Text('Encontre o profissional certo!'),
                  subtitle: Text('Veja promoções e novidades aqui.'),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text('Feedbacks recentes',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const _FeedbackCard('Ótimo serviço!', 'Maria'),
              const _FeedbackCard('Profissional muito atencioso.', 'João'),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrestadorHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          shrinkWrap: true,
          children: [
            // Resumo dos serviços cadastrados
            Card(
              child: ListTile(
                leading: const Icon(Icons.build),
                title: const Text('Você tem X serviços cadastrados'),
                subtitle: const Text('Y ativos, Z pendentes'),
              ),
            ),
            const SizedBox(height: 16),
            // Botão adicionar serviço
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Adicionar novo serviço'),
            ),
            const SizedBox(height: 16),
            // Solicitações/agendamentos recentes
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Solicitações recentes'),
                subtitle: const Text('Nenhuma pendente'),
              ),
            ),
            const SizedBox(height: 16),
            // Painel de estatísticas (simulado)
            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Estatísticas'),
                subtitle: const Text('Visualizações: 0 | Contatos: 0'),
              ),
            ),
            const SizedBox(height: 16),
            // Dica do dia
            Card(
              color: Colors.blue.shade50,
              child: const ListTile(
                leading: Icon(Icons.lightbulb),
                title: Text('Dica do dia'),
                subtitle: Text(
                    'Adicione uma imagem ao seu perfil para atrair mais clientes!'),
              ),
            ),
            const SizedBox(height: 16),
            // Atalhos rápidos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                IconButton(icon: const Icon(Icons.list), onPressed: () {}),
                IconButton(icon: const Icon(Icons.message), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final String nome;
  final IconData icone;
  const _CategoriaCard(this.nome, this.icone);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 32),
            const SizedBox(height: 8),
            Text(nome),
          ],
        ),
      ),
    );
  }
}

class _ServicoCard extends StatelessWidget {
  final String titulo;
  final String cidade;
  const _ServicoCard(this.titulo, this.cidade);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 160,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titulo, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Cidade: $cidade'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver detalhes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String comentario;
  final String usuario;
  const _FeedbackCard(this.comentario, this.usuario);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.comment),
        title: Text(comentario),
        subtitle: Text(usuario),
      ),
    );
  }
}

class _AnimatedCategoriaCard extends StatefulWidget {
  final String nome;
  final IconData icone;
  const _AnimatedCategoriaCard(this.nome, this.icone);

  @override
  State<_AnimatedCategoriaCard> createState() => _AnimatedCategoriaCardState();
}

class _AnimatedCategoriaCardState extends State<_AnimatedCategoriaCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: _hovered
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]
              : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icone, size: 32),
              const SizedBox(height: 8),
              Text(widget.nome, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedServiceCard extends StatefulWidget {
  final String titulo;
  final String cidade;
  const _AnimatedServiceCard(this.titulo, this.cidade);

  @override
  State<_AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<_AnimatedServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 140,
        decoration: BoxDecoration(
          color: _hovered
              ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]
              : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.titulo,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Cidade: ${widget.cidade}'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Ver detalhes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
