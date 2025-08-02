import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../service/data/models/service_model.dart';
import '../widgets/service_card.dart';

class ContratanteBuscaPage extends StatelessWidget {
  const ContratanteBuscaPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por categoria, cidade ou palavra-chave...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('services').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: [
                    AnimatedServiceCard('Jardinagem', 'São Paulo'),
                    AnimatedServiceCard('Limpeza', 'Campinas'),
                    AnimatedServiceCard('Elétrica', 'Santos'),
                  ],
                );
              }

              final services = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ServiceModel.fromMap({...data, 'id': doc.id});
              }).toList();

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCardReal(service: service);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
