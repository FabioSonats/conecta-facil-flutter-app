import 'package:flutter/material.dart';
import '../../../service/presentation/pages/service_form_page.dart';

class PrestadorHome extends StatelessWidget {
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ServiceFormPage(),
                  ),
                );
              },
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
