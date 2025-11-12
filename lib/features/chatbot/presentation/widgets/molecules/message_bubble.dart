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
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Si es del asistente y parece JSON, parsearlo
            if (!isUser && _looksLikeMap(message.text))
              _buildAnalysisWidget(message.text)
            else
              Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            
            if (message.timestamp != null) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.timestamp!),
                style: TextStyle(
                  color: isUser ? Colors.white70 : Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _looksLikeMap(String text) {
    return text.startsWith('{') && text.endsWith('}');
  }

  Widget _buildAnalysisWidget(String mapText) {
    try {
      // Parsear el Map<String, dynamic> desde String
      final data = _parseMapString(mapText);
      
      if (data == null) {
        return Text(mapText);
      }

      final sesgos = data['sesgos_detectados'] as List? ?? [];

      if (sesgos.isEmpty) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "✅ Análisis completado",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 4),
            Text("No se detectaron sesgos cognitivos en tu comentario."),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "⚠️ Sesgos detectados:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          ...sesgos.map((sesgo) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ${sesgo['tipo'] ?? 'Desconocido'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "\"${sesgo['fragmento'] ?? ''}\"",
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sesgo['explicacion'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      );
    } catch (e) {
      print("Error parseando análisis: $e");
      return Text(mapText);
    }
  }

  Map<String, dynamic>? _parseMapString(String mapString) {
    try {
      // Intenta parsear como JSON
      return jsonDecode(mapString);
    } catch (e) {
      print("No es JSON válido: $e");
      return null;
    }
  }
}