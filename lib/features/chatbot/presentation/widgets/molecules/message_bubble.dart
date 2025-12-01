import 'dart:convert';
import 'package:bias_detect/features/chatbot/domain/entities/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;

    // Color azul específico SOLO en Light Mode
    final userBubbleColor = brightness == Brightness.light
        ? const Color(0xFF2563EB)
        : cs.primary;

    final userTextColor = brightness == Brightness.light
        ? Colors.white
        : cs.onPrimary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? userBubbleColor : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && _looksLikeMap(message.text))
              _buildAnalysisWidget(context, message.text)
            else
              Text(
                message.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: isUser ? userTextColor : cs.onSurface,
                ),
              ),
            if (message.timestamp != null) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.timestamp!),
                style: textTheme.labelSmall?.copyWith(
                  color: isUser
                      ? userTextColor.withOpacity(0.7)
                      : cs.onSurfaceVariant,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  bool _looksLikeMap(String text) {
    return text.trim().startsWith('{') && text.trim().endsWith('}');
  }

  Widget _buildAnalysisWidget(BuildContext context, String mapText) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    try {
      final data = jsonDecode(mapText);
      final sesgos = data['sesgos_detectados'] as List? ?? [];

      if (sesgos.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "✅ Análisis completado",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "No se detectaron sesgos cognitivos en tu comentario.",
              style: textTheme.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "⚠️ Sesgos detectados:",
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.error,
            ),
          ),
          const SizedBox(height: 8),
          ...sesgos.map((sesgo) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ${sesgo['tipo']}",
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "\"${sesgo['fragmento']}\"",
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: cs.onErrorContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sesgo['explicacion'],
                    style: textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    } catch (_) {
      return Text(mapText,
          style: textTheme.bodyMedium?.copyWith(color: cs.onSurface));
    }
  }
}
