import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../service/data/models/service_model.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class ServiceCardReal extends StatelessWidget {
  final ServiceModel service;
  const ServiceCardReal({required this.service});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(service.uidPrestador)
          .get(),
      builder: (context, userSnapshot) {
        Map<String, dynamic>? userData;
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          userData = userSnapshot.data!.data() as Map<String, dynamic>;
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: 220,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.titulo,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(service.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text('Cidade: ${service.cidade}'),
                  const SizedBox(height: 8),
                  Text('R\$ ${service.preco.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfilePage(userId: service.uidPrestador),
                              ),
                            );
                          },
                          child: const Text('Ver Perfil'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                            ),
                            onPressed: () async {
                              final telefone = userData?['telefone'] ?? '';
                              if (telefone.isNotEmpty) {
                                final numeroLimpo =
                                    telefone.replaceAll(RegExp(r'[^\d]'), '');
                                final url =
                                    'https://wa.me/55$numeroLimpo?text=Olá! Vi seu serviço de ${service.titulo} no Conecta Fácil e gostaria de mais informações.';

                                try {
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Não foi possível abrir o WhatsApp'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Erro ao abrir WhatsApp: $e'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Telefone não disponível para contato'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Contatar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedServiceCard extends StatefulWidget {
  final String titulo;
  final String cidade;
  const AnimatedServiceCard(this.titulo, this.cidade);

  @override
  State<AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<AnimatedServiceCard> {
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