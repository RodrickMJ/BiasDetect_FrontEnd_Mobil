import 'dart:convert';
import 'package:bias_detect/features/chatbot/data/models/analytics_model.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecase/chat_usecase.dart';
import '../../data/datasource/local_storage_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatUsecase usecase;
  final LocalStorageService localStorage; // 👈 AGREGAR

  List<ChatMessage> messages = [];
  bool isLoading = false;
  String _currentUrl = "";
  String _loadingMessage = "Procesando...";
  String? _currentConversationId;

  ChatProvider({
    required this.usecase,
    required this.localStorage, // 👈 AGREGAR
  });

  String get currentUrl => _currentUrl;
  String get loadingMessage => _loadingMessage;
  String? get currentConversationId => _currentConversationId;

  void updateUrl(String url) {
    _currentUrl = url.trim();
    notifyListeners();
  }

  void _updateLoadingMessage(String message) {
    _loadingMessage = message;
    notifyListeners();
  }

  // Cargar conversación desde el historial
  Future<void> loadConversation(String conversationId) async {
    final conversation = localStorage.getConversation(conversationId);
    if (conversation == null) return;

    _currentConversationId = conversationId;
    messages = conversation.messages.map((m) => m.toEntity()).toList();
    _currentUrl = conversation.url ?? "";
    notifyListeners();
  }

  // Iniciar nueva conversación
  void startNewConversation() {
    _currentConversationId = null;
    messages.clear();
    _currentUrl = "";
    notifyListeners();
  }

  Future<void> send(String userId, String text, String url) async {
    if (text.trim().isEmpty) {
      _showErrorMessage("Por favor escribe un comentario");
      return;
    }

    if (url.trim().isEmpty) {
      _showErrorMessage("Por favor ingresa una URL válida");
      return;
    }

    final userMessage = ChatMessage(
      sender: "user",
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    isLoading = true;
    notifyListeners();

    try {
      _updateLoadingMessage("🔍 Obteniendo contenido...");
      await Future.delayed(const Duration(milliseconds: 500));

      _updateLoadingMessage("🧠 Analizando sesgos...");
      await Future.delayed(const Duration(milliseconds: 500));

      _updateLoadingMessage("✨ Generando resultado...");

      final result = await usecase.sendMessage(userId, text.trim(), url.trim());

      if (result != null && result['resultado'] != 'ERROR') {
        final assistantMessage = ChatMessage(
          sender: "assistant",
          text: jsonEncode(result),
          timestamp: DateTime.now(),
        );
        messages.add(assistantMessage);

        // 👇 GUARDAR ANALYTICS
        await _saveAnalytics(result);

        await _saveConversation(text, url);
      } else {
        final errorMessage = ChatMessage(
          sender: "assistant",
          text: result?['explicacion'] ?? "❌ Error al procesar tu solicitud",
          timestamp: DateTime.now(),
        );
        messages.add(errorMessage);
      }
    } catch (e) {
      print("Error enviando mensaje: $e");

      final errorMessage = ChatMessage(
        sender: "assistant",
        text: "❌ Error de conexión. Verifica tu internet e intenta nuevamente.",
        timestamp: DateTime.now(),
      );
      messages.add(errorMessage);
    }

    isLoading = false;
    _loadingMessage = "Procesando...";
    notifyListeners();
  }

  Future<void> _saveAnalytics(Map<String, dynamic> result) async {
  try {
    final analytics = AnalyticsModel.fromMLResponse(result);
    await localStorage.saveAnalytics(analytics);
    notifyListeners(); // 👈 Esto actualizará la UI
  } catch (e) {
    print("Error guardando analytics: $e");
  }
}

  Future<void> _saveConversation(String firstMessage, String url) async {
    try {
      if (_currentConversationId == null) {
        // Nueva conversación
        final title = firstMessage.length <= 50
            ? firstMessage
            : '${firstMessage.substring(0, 50)}...';

        _currentConversationId = await localStorage.saveConversation(
          title: title,
          messages: messages,
          url: url,
        );
      } else {
        // Actualizar conversación existente
        await localStorage.updateConversation(
          id: _currentConversationId!,
          messages: messages,
          url: url,
        );
      }
    } catch (e) {
      print("Error guardando conversación: $e");
    }
  }

  void _showErrorMessage(String message) {
    final errorMessage = ChatMessage(
      sender: "assistant",
      text: "⚠️ $message",
      timestamp: DateTime.now(),
    );
    messages.add(errorMessage);
    notifyListeners();
  }

  void clearMessages() {
    messages.clear();
    _currentConversationId = null;
    notifyListeners();
  }
}
