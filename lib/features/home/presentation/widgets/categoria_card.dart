import 'package:flutter/material.dart';

class AnimatedCategoriaCard extends StatefulWidget {
  final String nome;
  final IconData icone;
  const AnimatedCategoriaCard(this.nome, this.icone);

  @override
  State<AnimatedCategoriaCard> createState() => _AnimatedCategoriaCardState();
}

class _AnimatedCategoriaCardState extends State<AnimatedCategoriaCard> {
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