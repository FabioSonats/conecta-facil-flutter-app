import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../service/data/models/service_model.dart';
import '../../../service/presentation/pages/service_form_page.dart';

class PrestadorServicosPage extends StatefulWidget {
  const PrestadorServicosPage({super.key});

  @override
  State<PrestadorServicosPage> createState() => _PrestadorServicosPageState();
}

class _PrestadorServicosPageState extends State<PrestadorServicosPage> {
  late final Stream<QuerySnapshot> _servicesStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    final user = context.read<AuthBloc>().state;
    if (user is! AuthAuthenticated) return;

    final uid = user.user.uid;
    print('Iniciando stream para UID: $uid');

    _servicesStream = FirebaseFirestore.instance
        .collection('services')
        .where('uidPrestador', isEqualTo: uid)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .handleError((error) {
      print('Erro no stream: $error');
      throw error;
    });
  }

  void _refreshData() {
    setState(() {
      _initializeStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Center(child: Text('Usuário não autenticado'));
        }

        final uid = state.user.uid;
        print('UID do prestador: $uid');

        return Scaffold(
          body: Column(
            children: [
              _buildDebugInfo(uid),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _servicesStream,
                  builder: (context, snapshot) {
                    _logSnapshotState(snapshot);

                    if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error!, _refreshData);
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState(context, uid);
                    }

                    return _buildServicesList(snapshot.data!.docs);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceFormPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // Métodos auxiliares organizados por responsabilidade

  Widget _buildDebugInfo(String uid) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UID: $uid',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Última atualização: ${DateTime.now().toIso8601String()}',
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _logSnapshotState(AsyncSnapshot<QuerySnapshot> snapshot) {
    print('''
=== Estado do Stream ===
Connection: ${snapshot.connectionState}
HasData: ${snapshot.hasData}
HasError: ${snapshot.hasError}
DocsCount: ${snapshot.data?.docs.length ?? 0}
=======================''');
  }

  Widget _buildErrorState(Object error, VoidCallback onRetry) {
    print('Erro detalhado: $error');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Falha ao carregar serviços'),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[700], fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando seus serviços...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String uid) {
    print('Nenhum serviço encontrado para UID: $uid');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.work_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Você ainda não tem serviços cadastrados',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Criar primeiro serviço'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServiceFormPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<QueryDocumentSnapshot> docs) {
    final services = docs.map((doc) {
      try {
        return ServiceModel.fromMap({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });
      } catch (e) {
        print('Erro ao converter documento ${doc.id}: $e');
        throw Exception('Formato inválido para o documento ${doc.id}');
      }
    }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(services[index]);
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(service.categoria),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (service.descricao.isNotEmpty)
              Text(
                service.descricao,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$ ${service.preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue.shade600),
                      onPressed: () => _editService(service),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade600),
                      onPressed: () => _deleteService(service),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editService(ServiceModel service) {
    // Implementar edição
    print('Editar serviço: ${service.id}');
  }

  void _deleteService(ServiceModel service) {
    // Implementar exclusão
    print('Excluir serviço: ${service.id}');
  }
}
