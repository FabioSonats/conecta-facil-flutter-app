import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ServiceFormPage extends StatefulWidget {
  const ServiceFormPage({super.key});

  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _tipoServico;
  String? _area;
  final _descricaoController = TextEditingController();
  double? _preco;

  final List<String> tiposServico = [
    'Diarista', 'Jardinagem', 'Eletricista', 'Pintor(a)', 'Pedreiro',
    'Cozinheiro(a)', 'Babá', 'Personal Trainer', 'Fotógrafo(a)', 'Manicure',
    'Professor',
    // ...adicione mais conforme sua lista
  ];

  final List<String> areas = [
    'Serviços Domésticos',
    'Serviços Técnicos e Reparos',
    'Serviços Externos e Ambientais',
    'Construção e Reforma',
    'Freelancers e Autônomos',
    'Beleza e Estética',
    'Saúde e Bem-estar',
    'Educação e Treinamentos',
  ];

  Future<void> _salvarServico() async {
    final user = context.read<AuthBloc>().state is AuthAuthenticated
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user
        : null;
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('services').doc();
    await docRef.set({
      'id': docRef.id,
      'uidPrestador': user.uid,
      'titulo': _tipoServico,
      'categoria': _area,
      'descricao': _descricaoController.text.trim(),
      'preco': _preco ?? 0.0,
      'cidade': user.cidade ?? '',
      'estado': user.estado ?? '',
      'criadoEm': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Serviço')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _tipoServico,
                    decoration:
                        const InputDecoration(labelText: 'Tipo de Serviço'),
                    items: tiposServico
                        .map((tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _tipoServico = v),
                    validator: (v) =>
                        v == null ? 'Selecione o tipo de serviço' : null,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _area,
                    decoration: const InputDecoration(labelText: 'Área'),
                    items: areas
                        .map((area) => DropdownMenuItem(
                              value: area,
                              child: Text(area),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _area = v),
                    validator: (v) => v == null ? 'Selecione a área' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição do serviço',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 6,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Descreva o serviço' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Preço do serviço (R\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe o preço';
                        final value = double.tryParse(v.replaceAll(',', '.'));
                        if (value == null) return 'Preço inválido';
                        if (value < 0) return 'Preço deve ser positivo';
                        return null;
                      },
                      onChanged: (v) =>
                          _preco = double.tryParse(v.replaceAll(',', '.'))),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _preco != null) {
                        await _salvarServico();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Serviço cadastrado!')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Serviço'),
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
