import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/chat.dart';
import '../../data/models/conversation_model.dart'; // ← Asegúrate de importar tu modelo real
import '../../data/datasource/local_storage_service.dart';

class ChatHistoryProvider with ChangeNotifier {
  final LocalStorageService localStorage;

  List<ConversationModel> _conversations = [];
  String? _currentConversationId;

  ChatHistoryProvider(this.localStorage) {
    loadConversations();
  }

  List<ConversationModel> get conversations => List.unmodifiable(_conversations);
  String? get currentConversationId => _currentConversationId;

  Future<void> loadConversations() async {
    _conversations = await localStorage.getAllConversations();
    notifyListeners();
  }

  /// Carga una conversación en el buffer de mensajes del ChatProvider
  Future<void> loadConversationIntoChat(
    String conversationId,
    List<ChatMessage> messagesBuffer,
  ) async {
    final conversation = localStorage.getConversation(conversationId);
    if (conversation != null) {
      _currentConversationId = conversationId;

      messagesBuffer
        ..clear()
        ..addAll(conversation.messages.map((m) => m.toEntity()));

      notifyListeners();
    }
  }

Future<void> clearAllConversations() async {
  await localStorage.clearAll(); // o el método que tengas para borrar todo
  _conversations.clear();
  _currentConversationId = null;
  notifyListeners();
}

  /// Crea o actualiza la conversación actual y recarga el historial
  Future<String> saveCurrentConversation({
    required String title,
    required List<ChatMessage> messages,
    required String url,
  }) async {
    if (_currentConversationId == null) {
      _currentConversationId = await localStorage.saveConversation(
        title: title,
        messages: messages,
        url: url,
      );
    } else {
      await localStorage.updateConversation(
        id: _currentConversationId!,
        messages: messages,
        url: url,
      );
    }

    await loadConversations();
    return _currentConversationId!;
  }

  Future<void> deleteConversation(String conversationId) async {
    await localStorage.deleteConversation(conversationId);
    if (_currentConversationId == conversationId) {
      _currentConversationId = null;
    }
    await loadConversations();
  }

  void startNewConversation() {
    _currentConversationId = null;
    notifyListeners();
  }
}