import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../service/data/models/service_model.dart';
import 'service_card.dart';
import 'categoria_card.dart';
import 'feedback_card.dart';

class ContratanteHome extends StatelessWidget {
  final String? cidade;
  const ContratanteHome({this.cidade});

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
                  AnimatedCategoriaCard('Jardinagem', Icons.grass),
                  AnimatedCategoriaCard('Limpeza', Icons.cleaning_services),
                  AnimatedCategoriaCard('Elétrica', Icons.electrical_services),
                  AnimatedCategoriaCard('Pintura', Icons.format_paint),
                  AnimatedCategoriaCard('Reformas', Icons.construction),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Text('Serviços em destaque',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 24),
              ServicosDestaque(),
              const SizedBox(height: 40),
              if (cidade != null)
                Center(
                  child: Text('Sugestões em $cidade',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              if (cidade != null) const SizedBox(height: 24),
              if (cidade != null) ServicosCidade(cidade: cidade!),
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
              const FeedbackCard('Ótimo serviço!', 'Maria'),
              const FeedbackCard('Profissional muito atencioso.', 'João'),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class ServicosDestaque extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('services')
          .limit(6)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              AnimatedServiceCard('Jardinagem', 'Jardinagem'),
              AnimatedServiceCard('Limpeza', 'Limpeza'),
              AnimatedServiceCard('Elétrica', 'Elétrica'),
            ],
          );
        }

        final services = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel.fromMap({...data, 'id': doc.id});
        }).toList();

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: services
              .map((service) => ServiceCardReal(service: service))
              .toList(),
        );
      },
    );
  }
}

class ServicosCidade extends StatelessWidget {
  final String cidade;
  const ServicosCidade({required this.cidade});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('services')
          .where('cidade', isEqualTo: cidade)
          .limit(4)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              AnimatedServiceCard('Limpeza', 'São Paulo'),
              AnimatedServiceCard('Pintura', 'São Paulo'),
            ],
          );
        }

        final services = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel.fromMap({...data, 'id': doc.id});
        }).toList();

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: services
              .map((service) => ServiceCardReal(service: service))
              .toList(),
        );
      },
    );
  }
} 