import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ChatService {
  Future<Map<String, dynamic>?> sendNoticeAnalysis({
    required String url,
    required String fcmToken,
    required String textUser,
  });

  Future<Map<String, dynamic>?> sendCommentAnalysis({
    required String fcmToken,
    required String textUser,
  });

  Future<Map<String, dynamic>?> getAnalysisById(String analysisId);
}

class ChatServiceImpl implements ChatService {
  final http.Client client;

  final String noticeAnalysisUrl = "https://brmhjkhq-4000.use.devtunnels.ms/analysis/notice";
  final String commentAnalysisUrl = "https://brmhjkhq-4000.use.devtunnels.ms/analysis/comments";
  final String baseUrl = "https://brmhjkhq-4000.use.devtunnels.ms";

  ChatServiceImpl(this.client);

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  @override
  Future<Map<String, dynamic>?> sendNoticeAnalysis({
    required String url,
    required String fcmToken,
    required String textUser,
  }) async {
    try {
      final requestBody = {
        "url": url,
        "fcm_token": fcmToken,
        "text_user": textUser,
      };

      final response = await client.post(
        Uri.parse(noticeAnalysisUrl),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 202) {
        try {
          final jsonData = jsonDecode(response.body);
          return {
            "resultado": "PROCESANDO",
            "id": jsonData['id'],
            "explicacion": "Tu noticia está siendo analizada. La respuesta llegará por notificación push.",
            "sesgos_encontrados": [],
            "coincidencias": [],
            "contexto": "El análisis se está realizando en segundo plano.",
          };
        } catch (e) {
          return _createErrorResponse("Error procesando respuesta del servidor");
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }

      return _createErrorResponse("Error ${response.statusCode}: No se pudo analizar la noticia");
    } catch (e) {
      return _createErrorResponse("Error de conexión");
    }
  }

  @override
  Future<Map<String, dynamic>?> sendCommentAnalysis({
    required String fcmToken,
    required String textUser,
  }) async {
    try {
      final requestBody = {
        "fcm_token": fcmToken,
        "text_user": textUser,
      };

      final response = await client.post(
        Uri.parse(commentAnalysisUrl),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 202) {
        try {
          final jsonData = jsonDecode(response.body);
          return {
            "resultado": "PROCESANDO",
            "id": jsonData['id'],
            "explicacion": "Tu comentario está siendo analizado. La respuesta llegará por notificación push.",
            "sesgos_encontrados": [],
            "coincidencias": [],
            "contexto": "El análisis se está realizando en segundo plano.",
          };
        } catch (e) {
          return _createErrorResponse("Error procesando respuesta del servidor");
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }

      return _createErrorResponse("Error ${response.statusCode}: No se pudo analizar el comentario");
    } catch (e) {
      return _createErrorResponse("Error de conexión");
    }
  }

  @override
  Future<Map<String, dynamic>?> getAnalysisById(String analysisId) async {
    try {
      final response = await client.get(
        Uri.parse("$baseUrl/analysis/$analysisId"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData.containsKey('llm')) {
          final llmData = jsonData['llm'] as Map<String, dynamic>;
          return llmData.containsKey('resultado') ? llmData : jsonData;
        }

        return jsonData;
      }

      if (response.statusCode == 404) {
        return _createErrorResponse("Análisis no encontrado");
      }

      return _createErrorResponse("Error al obtener el análisis");
    } catch (e) {
      return _createErrorResponse("Error de conexión");
    }
  }

  Map<String, dynamic> _createErrorResponse(String message) {
    return {
      "resultado": "ERROR",
      "explicacion": message,
      "sesgos_encontrados": [],
      "coincidencias": [],
      "contexto": "",
    };
  }
}