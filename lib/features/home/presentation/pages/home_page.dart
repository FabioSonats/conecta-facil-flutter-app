import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Conecta Fácil'),
            actions: isDesktop
                ? [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Serviços',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Perfil',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ]
                : null,
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
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.build),
                        title: const Text('Serviços'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Perfil'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                NavigationRail(
                  selectedIndex: 0,
                  onDestinationSelected: (int index) {},
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
                child: Center(
                  child: Text(
                    'Bem-vindo à Home! (Responsivo)',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
