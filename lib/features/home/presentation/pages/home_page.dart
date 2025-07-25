import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conecta_facil/features/service/domain/entities/service_entity.dart';
import 'package:conecta_facil/features/service/data/models/service_model.dart';
import 'package:conecta_facil/features/service/presentation/pages/service_form_page.dart';

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
              final isMobile = constraints.maxWidth < 600;
              return ValueListenableBuilder<int>(
                valueListenable: _selectedIndex,
                builder: (context, selectedIndex, _) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.background,
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
                        : null, // Drawer removido, usaremos BottomNavigationBar no mobile
                    body: Row(
                      children: [
                        if (isDesktop)
                          MouseRegion(
                            onEnter: (_) => setState(() {}),
                            onExit: (_) => setState(() {}),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 72,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.85),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(2, 0),
                                  ),
                                ],
                              ),
                              child: NavigationRail(
                                backgroundColor: Colors.transparent,
                                selectedIndex: selectedIndex,
                                onDestinationSelected: (int index) {
                                  _selectedIndex.value = index;
                                },
                                labelType: NavigationRailLabelType.selected,
                                leading: const SizedBox(height: 16),
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
                            ),
                          ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 4.0 : 16.0),
                            child: _getPage(selectedIndex, tipoPerfil, cidade),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: isMobile
                        ? BottomNavigationBar(
                            currentIndex: selectedIndex,
                            onTap: (index) => _selectedIndex.value = index,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.95),
                            selectedItemColor:
                                Theme.of(context).colorScheme.primary,
                            unselectedItemColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            items: const [
                              BottomNavigationBarItem(
                                icon: Icon(Icons.home),
                                label: 'Início',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(Icons.build),
                                label: 'Serviços',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(Icons.person),
                                label: 'Perfil',
                              ),
                            ],
                          )
                        : null,
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
        if (tipoPerfil == 'prestador') {
          return const _PrestadorHome();
        } else if (tipoPerfil == 'contratante') {
          return _ContratanteHome(cidade: cidade);
        } else {
          return const Center(child: Text('Perfil de usuário desconhecido.'));
        }
      case 1:
        return const Center(child: Text('Página de Serviços (em breve)'));
      case 2:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ContratanteHome extends StatefulWidget {
  final String? cidade;
  const _ContratanteHome({this.cidade});

  @override
  State<_ContratanteHome> createState() => _ContratanteHomeState();
}

class _ContratanteHomeState extends State<_ContratanteHome> {
  String? _tipoSelecionado;
  final List<String> _tipos = [
    'Diarista',
    'Jardinagem',
    'Eletricista',
    'Pintor(a)',
    'Pedreiro',
    'Cozinheiro(a)',
    'Babá',
    'Personal Trainer',
    'Fotógrafo(a)',
    'Manicure',
    'Professor',
  ];

  Future<List<ServiceEntity>> fetchServices() async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('services');
    if (_tipoSelecionado != null) {
      query = query.where('titulo', isEqualTo: _tipoSelecionado);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ServiceModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Card de filtros mais compacto e escuro
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Encontre profissionais próximos a você',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Selecione o tipo de serviço ou busque diretamente',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: _tipoSelecionado,
                              decoration: InputDecoration(
                                labelText: null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Todos os tipos'),
                                ),
                                ..._tipos.map((tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo),
                                    ))
                              ],
                              onChanged: (v) =>
                                  setState(() => _tipoSelecionado = v),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar serviço ou profissional...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Título categorias alinhado à esquerda
              Text('Categorias Populares',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.1,
                    children: _categorias
                        .map((cat) => Tooltip(
                              message: cat['nome'],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: Icon(cat['icone'] as IconData,
                                        size: 30),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(cat['nome'],
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Título serviços em destaque alinhado à esquerda
              Text('Serviços em Destaque',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              FutureBuilder<List<ServiceEntity>>(
                key: ValueKey(_tipoSelecionado),
                future: fetchServices(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  final services = snapshot.data!;
                  if (services.isEmpty) {
                    // Modal para prestador sem serviços
                    final user = context.read<AuthBloc>().state
                            is AuthAuthenticated
                        ? (context.read<AuthBloc>().state as AuthAuthenticated)
                            .user
                        : null;
                    if (user != null && user.tipoPerfil == 'prestador') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Cadastre seu primeiro serviço!'),
                            content: const Text(
                                'Você ainda não cadastrou nenhum serviço. Clique em "Adicionar novo serviço" para começar.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Fechar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ServiceFormPage()),
                                      )
                                      .then((_) => setState(() {}));
                                },
                                child: const Text('Adicionar serviço'),
                              ),
                            ],
                          ),
                        );
                      });
                    }
                    return const Center(
                        child: Text('Nenhum serviço encontrado.'));
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 700 ? 3 : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 1.9,
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, idx) {
                          final service = services[idx];
                          return FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(service.uidPrestador)
                                .get(),
                            builder: (context, userSnap) {
                              if (userSnap.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final userData = userSnap.data?.data();
                              final nome = userData?['nome'] ?? 'Profissional';
                              final foto =
                                  userData?['fotoPerfilUrl'] as String?;
                              final cidade = service.cidade;
                              final avaliacao = userData?['avaliacao'] ??
                                  4.8; // mock se não houver
                              final avaliacoes =
                                  userData?['avaliacoes'] ?? 120; // mock
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Theme.of(context).colorScheme.surface,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 36,
                                        backgroundImage:
                                            foto != null && foto.isNotEmpty
                                                ? NetworkImage(foto)
                                                : null,
                                        child: foto == null || foto.isEmpty
                                            ? const Icon(Icons.person, size: 36)
                                            : null,
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(nome,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            Text('${service.titulo} - $cidade',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.amber,
                                                    size: 20),
                                                const SizedBox(width: 4),
                                                Text('$avaliacao',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    ' ($avaliacoes avaliações)',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 12),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ProfilePage(
                                                  userId: service.uidPrestador),
                                            ),
                                          );
                                        },
                                        child: const Text('Ver Perfil'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
              if (widget.cidade != null)
                Center(
                  child: Text('Sugestões em ${widget.cidade}',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              if (widget.cidade != null)
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: const [
                    _AnimatedServiceCard('Limpeza', 'São Paulo'),
                    _AnimatedServiceCard('Pintura', 'São Paulo'),
                  ],
                ),
              if (widget.cidade != null) const SizedBox(height: 40),
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
                color: Theme.of(context).colorScheme.surface,
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

// Lista de categorias reais
const List<Map<String, dynamic>> _categorias = [
  {'nome': 'Diarista', 'icone': Icons.cleaning_services},
  {'nome': 'Jardinagem', 'icone': Icons.grass},
  {'nome': 'Eletricista', 'icone': Icons.electrical_services},
  {'nome': 'Pintor(a)', 'icone': Icons.format_paint},
  {'nome': 'Pedreiro', 'icone': Icons.construction},
  {'nome': 'Cozinheiro(a)', 'icone': Icons.restaurant},
  {'nome': 'Babá', 'icone': Icons.child_friendly},
  {'nome': 'Personal Trainer', 'icone': Icons.fitness_center},
  {'nome': 'Fotógrafo(a)', 'icone': Icons.camera_alt},
  {'nome': 'Manicure', 'icone': Icons.spa},
  {'nome': 'Professor', 'icone': Icons.school},
  // ...adicione mais conforme sua lista
];

class _PrestadorHome extends StatefulWidget {
  const _PrestadorHome();
  @override
  State<_PrestadorHome> createState() => _PrestadorHomeState();
}

class _PrestadorHomeState extends State<_PrestadorHome> {
  Future<List<ServiceEntity>> fetchMyServices(String uid) async {
    print('Buscando serviços para UID: $uid');
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('uidPrestador', isEqualTo: uid)
        .get();
    print('Encontrados: ${snapshot.docs.length} serviços');
    return snapshot.docs.map((doc) {
      print('Doc: ${doc.data()}');
      return ServiceModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state is AuthAuthenticated
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user
        : null;
    if (user == null) return const SizedBox.shrink();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              FutureBuilder<List<ServiceEntity>>(
                key: ValueKey(user.uid),
                future: fetchMyServices(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('Erro no FutureBuilder: ${snapshot.error}');
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  final services = snapshot.data!;
                  if (services.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Cadastre seu primeiro serviço!'),
                          content: const Text(
                              'Você ainda não cadastrou nenhum serviço. Clique em "Adicionar novo serviço" para começar.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fechar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ServiceFormPage()),
                                    )
                                    .then((_) => setState(() {}));
                              },
                              child: const Text('Adicionar serviço'),
                            ),
                          ],
                        ),
                      );
                    });
                    return const Center(
                        child: Text('Nenhum serviço cadastrado.'));
                  }
                  // Exibir serviços em lista horizontal customizada
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    separatorBuilder: (context, idx) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final service = services[idx];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.08)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            service.imagemUrl != null &&
                                    service.imagemUrl!.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(service.imagemUrl!),
                                    radius: 28)
                                : const CircleAvatar(
                                    child: Icon(Icons.person), radius: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.titulo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user?.cidade ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text('4,8',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      Text(' / 120 aev.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSurface,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProfilePage(
                                        userId: service.uidPrestador),
                                  ),
                                );
                              },
                              child: const Text('Ver perfil'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                            builder: (_) => const ServiceFormPage()),
                      )
                      .then((_) => setState(() {}));
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar novo serviço'),
              ),
              // ... outros widgets do painel do prestador
            ],
          ),
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
              : Theme.of(context).colorScheme.surface,
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
              : Theme.of(context).colorScheme.surface,
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
