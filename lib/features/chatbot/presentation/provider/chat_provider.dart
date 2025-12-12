import 'dart:convert';
import 'package:bias_detect/features/chatbot/data/models/analytics_model.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecase/chat_usecase.dart';
import '../../data/datasource/local_storage_service.dart';
import '../../data/datasource/fcm_token_service.dart';
import '../../data/datasource/fcm_notification_handler.dart';

class ChatProvider with ChangeNotifier {
  final ChatUsecase usecase;
  final LocalStorageService localStorage;
  final FcmTokenService fcmTokenService;
  late FcmNotificationHandler _notificationHandler;

  List<ChatMessage> messages = [];
  bool isLoading = false;
  String _currentUrl = "";
  String _loadingMessage = "Procesando...";
  String? _pendingAnalysisId;
  bool _waitingForPushResult = false;
  String? _pendingFirstMessage;
  String? _pendingUrl;

  ChatProvider({
    required this.usecase,
    required this.localStorage,
    required this.fcmTokenService,
  }) {
    _initializeNotificationHandler();
  }

  String get currentUrl => _currentUrl;
  String get loadingMessage => _loadingMessage;
  bool get waitingForPushResult => _waitingForPushResult;

  void _initializeNotificationHandler() {
    _notificationHandler = FcmNotificationHandler(
      onAnalysisId: _handleAnalysisIdFromPush,
    );
    _notificationHandler.initialize();
  }

  void _handleAnalysisIdFromPush(String analysisId) async {
    if (analysisId == 'ERROR') {
      if (_waitingForPushResult) {
        if (messages.isNotEmpty &&
            messages.last.sender == 'assistant' &&
            messages.last.text.contains('PROCESANDO')) {
          messages.removeLast();
        }
        _showErrorMessage("El análisis falló en el servidor. Por favor intenta nuevamente.");
        _resetPendingState();
        notifyListeners();
      }
      return;
    }

    final idToUse = analysisId.isNotEmpty ? analysisId : _pendingAnalysisId;
    if (idToUse == null || idToUse.isEmpty) {
      _showErrorMessage("No se pudo identificar el análisis");
      return;
    }

    if (_waitingForPushResult) {
      try {
        final result = await usecase.getAnalysisById(idToUse);
        if (result != null && result['resultado'] != 'ERROR') {
          if (messages.isNotEmpty &&
              messages.last.sender == 'assistant' &&
              messages.last.text.contains('PROCESANDO')) {
            messages.removeLast();
          }

          final llmData = result['llm'] as Map<String, dynamic>? ?? result;
          messages.add(ChatMessage(
            sender: "assistant",
            text: jsonEncode(llmData),
            timestamp: DateTime.now(),
          ));

          await _saveAnalytics(result);
          _resetPendingState();
          notifyListeners();
        } else {
          _showErrorMessage("No se pudo obtener el resultado del análisis");
          _resetPendingState();
          notifyListeners();
        }
      } catch (e) {
        _showErrorMessage("Error al obtener el resultado");
        _resetPendingState();
        notifyListeners();
      }
    }
  }

  void updateUrl(String url) {
    _currentUrl = url.trim();
    notifyListeners();
  }

  void _updateLoadingMessage(String message) {
    _loadingMessage = message;
    notifyListeners();
  }

  void _resetPendingState() {
    _waitingForPushResult = false;
    _pendingAnalysisId = null;
    _pendingFirstMessage = null;
    _pendingUrl = null;
  }

  Future<void> send(String userId, String text, String url) async {
    if (text.trim().isEmpty) {
      _showErrorMessage("Por favor escribe un comentario");
      return;
    }

    final fcmToken = await fcmTokenService.getToken();
    if (fcmToken == null || fcmToken.isEmpty) {
      _showErrorMessage("Error: No se pudo obtener el token de notificaciones");
      return;
    }

    _pendingFirstMessage = text.trim();
    _pendingUrl = url.trim().isNotEmpty ? url.trim() : null;

    messages.add(ChatMessage(
      sender: "user",
      text: text.trim(),
      timestamp: DateTime.now(),
    ));
    isLoading = true;
    notifyListeners();

    try {
      final isNoticeAnalysis = url.trim().isNotEmpty;
      if (isNoticeAnalysis) {
        _updateLoadingMessage("Analizando noticia completa...");
        final result = await usecase.sendNoticeAnalysis(
          url: url.trim(),
          fcmToken: fcmToken,
          textUser: text.trim(),
        );
        await _processAnalysisResult(result, text.trim(), url.trim());
      } else {
        _updateLoadingMessage("Analizando comentario...");
        final result = await usecase.sendCommentAnalysis(
          fcmToken: fcmToken,
          textUser: text.trim(),
        );
        await _processAnalysisResult(result, text.trim(), null);
      }
    } catch (e) {
      messages.add(ChatMessage(
        sender: "assistant",
        text: "Error de conexión. Verifica tu internet e intenta nuevamente.",
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    }

    isLoading = false;
    _loadingMessage = "Procesando...";
    notifyListeners();
  }

  Future<void> _processAnalysisResult(
    Map<String, dynamic>? result,
    String text,
    String? url,
  ) async {
    if (result != null && result['resultado'] != 'ERROR') {
      if (result['resultado'] == 'PROCESANDO') {
        _waitingForPushResult = true;
        _pendingAnalysisId = result['id'];
      }

      messages.add(ChatMessage(
        sender: "assistant",
        text: jsonEncode(result),
        timestamp: DateTime.now(),
      ));

      if (result['resultado'] != 'PROCESANDO') {
        await _saveAnalytics(result);
      }
    } else {
      messages.add(ChatMessage(
        sender: "assistant",
        text: result?['explicacion'] ?? "Error al procesar tu solicitud",
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _saveAnalytics(Map<String, dynamic> result) async {
    try {
      final analytics = AnalyticsModel.fromMLResponse(result);
      await localStorage.saveAnalytics(analytics);
    } catch (e) {
      // Silenciado
    }
  }

  void _showErrorMessage(String message) {
    messages.add(ChatMessage(
      sender: "assistant",
      text: "$message",
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void clearCurrentChat() {
    messages.clear();
    _currentUrl = "";
    _resetPendingState();
    notifyListeners();
  }
}