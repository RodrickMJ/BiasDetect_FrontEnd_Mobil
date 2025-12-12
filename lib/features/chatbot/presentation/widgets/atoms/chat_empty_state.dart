import 'package:flutter/material.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: cs.primary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text("Detector de Sesgos Cognitivos", style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Analiza noticias completas o comentarios individuales", style: textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text("Agrega una URL para análisis completo o solo escribe tu comentario", style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}