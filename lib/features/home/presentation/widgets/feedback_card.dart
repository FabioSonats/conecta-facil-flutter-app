import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  final String comentario;
  final String usuario;
  const FeedbackCard(this.comentario, this.usuario);

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