import 'dart:convert';
import 'package:bias_detect/features/chatbot/domain/entities/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const MessageBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;

    final userBubbleColor = brightness == Brightness.light
        ? const Color(0xFF2563EB)
        : cs.primary;

    final userTextColor = brightness == Brightness.light
        ? Colors.white
        : cs.onPrimary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? userBubbleColor : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && _looksLikeJson(message.text))
              _buildAnalysisResult(context, message.text)
            else
              Text(
                message.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: isUser ? userTextColor : cs.onSurface,
                ),
              ),
            if (message.timestamp != null) ...[
              const SizedBox(height: 6),
              Text(
                DateFormat('HH:mm').format(message.timestamp!),
                style: textTheme.labelSmall?.copyWith(
                  color: isUser
                      ? userTextColor.withOpacity(0.7)
                      : cs.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _looksLikeJson(String text) {
    final trimmed = text.trim();
    return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'));
  }

  Widget _buildAnalysisResult(BuildContext context, String jsonText) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    try {
      final data = jsonDecode(jsonText);
      final resultado = data['resultado'] ?? '';
      final explicacion = data['explicacion'] ?? '';
      final sesgosEncontrados = data['sesgos_encontrados'] as List? ?? [];
      final coincidencias = data['coincidencias'] as List? ?? [];
      final contexto = data['contexto'] ?? '';

      // Determinar si tiene sesgos
      final tieneSesgo =
          resultado.toUpperCase().contains('CON SESGOS') ||
          resultado.toUpperCase().contains('DETECTADOS');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con resultado
          _buildResultHeader(context, resultado, tieneSesgo),

          const SizedBox(height: 16),

          // Explicación principal
          if (explicacion.isNotEmpty) ...[
            Text(
              explicacion,
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Sesgos encontrados
          if (sesgosEncontrados.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.error.withOpacity(0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: cs.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sesgos detectados',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...sesgosEncontrados.map((sesgo) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: TextStyle(
                              color: cs.error,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _formatSesgo(sesgo),
                              style: textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Coincidencias
          if (coincidencias.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cs.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: cs.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Coincidencias encontradas',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...coincidencias.map((coincidencia) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: TextStyle(color: cs.primary, fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              coincidencia.toString(),
                              style: textTheme.bodySmall?.copyWith(
                                color: cs.onSurface,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Contexto adicional
          if (contexto.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: cs.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Contexto del análisis',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contexto,
                    style: textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } catch (e) {
      print("Error parseando JSON en MessageBubble: $e");
      // Si falla el parseo, mostrar el texto crudo
      return Text(
        jsonText,
        style: textTheme.bodyMedium?.copyWith(color: cs.onSurface),
      );
    }
  }

  Widget _buildResultHeader(
    BuildContext context,
    String resultado,
    bool tieneSesgo,
  ) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color bgColor;
    Color textColor;
    Color iconColor;
    IconData icon;

    if (tieneSesgo) {
      bgColor = cs.errorContainer;
      textColor = cs.onErrorContainer;
      iconColor = cs.error;
      icon = Icons.error_outline;
    } else if (resultado.toUpperCase().contains('SIN SESGOS')) {
      bgColor = cs.primaryContainer;
      textColor = cs.onPrimaryContainer;
      iconColor = cs.primary;
      icon = Icons.check_circle_outline;
    } else if (resultado.toUpperCase().contains('ERROR')) {
      bgColor = cs.errorContainer;
      textColor = cs.onErrorContainer;
      iconColor = cs.error;
      icon = Icons.warning_amber_rounded;
    } else {
      bgColor = cs.secondaryContainer;
      textColor = cs.onSecondaryContainer;
      iconColor = cs.secondary;
      icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              resultado,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSesgo(dynamic sesgo) {
    if (sesgo is String) {
      return sesgo;
    } else if (sesgo is Map) {
      final tipo = sesgo['tipo'] ?? sesgo['label'] ?? '';
      final explicacion = sesgo['explicacion'] ?? sesgo['contexto'] ?? '';

      if (explicacion.isNotEmpty) {
        return '$tipo: $explicacion';
      }
      return tipo;
    }
    return sesgo.toString();
  }
}
