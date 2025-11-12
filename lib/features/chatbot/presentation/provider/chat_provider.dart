import 'dart:convert'; // ✅ Agregar este import
import 'package:flutter/material.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecase/chat_usecase.dart';

class ChatProvider with ChangeNotifier {
  final ChatUsecase usecase;

  List<ChatMessage> messages = [];
  bool isLoading = false;
  String _currentUrl = "https://www.gob.mx/presidencia";

  ChatProvider({required this.usecase});

  String get currentUrl => _currentUrl;

  void updateUrl(String url) {
    _currentUrl = url.trim().isEmpty ? "https://www.gob.mx/presidencia" : url.trim();
    notifyListeners();
  }

  Future<void> send(String userId, String text, String url) async {
    if (text.trim().isEmpty) return;

    // Agregar mensaje del usuario inmediatamente
    final userMessage = ChatMessage(
      sender: "user",
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    isLoading = true;
    notifyListeners();

    try {
      // Llamar a la API y obtener respuesta
      final analysis = await usecase.sendMessage(userId, text.trim(), url);

      if (analysis != null) {
        //Convertir Map a JSON string correctamente
        final assistantMessage = ChatMessage(
          sender: "assistant",
          text: jsonEncode(analysis), 
          timestamp: DateTime.now(),
        );

        messages.add(assistantMessage);
      } else {
        // Mensaje de error
        final errorMessage = ChatMessage(
          sender: "assistant",
          text: "❌ Error al analizar el texto. Intenta nuevamente.",
          timestamp: DateTime.now(),
        );

        messages.add(errorMessage);
      }
    } catch (e) {
      print("Error enviando mensaje: $e");
      
      final errorMessage = ChatMessage(
        sender: "assistant",
        text: "❌ Error de conexión: $e",
        timestamp: DateTime.now(),
      );

      messages.add(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }

  void clearMessages() {
    messages.clear();
    notifyListeners();
  }
}