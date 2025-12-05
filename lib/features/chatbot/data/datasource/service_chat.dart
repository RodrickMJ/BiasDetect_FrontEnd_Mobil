import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ChatService {
  Future<Map<String, dynamic>?> sendMessage(
    String userId,
    String text,
    String url,
  );
}

class ChatServiceImpl implements ChatService {
  final http.Client client;

  // URLs de los microservicios
  final String scraperUrl = "https://microservices-qwzs.onrender.com/scraped";
  final String biasAnalyzerUrl = "https://Rodricklw-api-sesgos.hf.space/analyze";
  final String promptProcessorUrl = "https://promp-service.vercel.app/analysis/process";

  ChatServiceImpl(this.client);

  @override
  Future<Map<String, dynamic>?> sendMessage(
    String userId,
    String text,
    String url,
  ) async {
    try {
      // PASO 1: Scraper - Obtener contenido de la URL
      print("🔍 Paso 1/3: Scrapeando contenido...");
      final scrapedData = await _scrapeContent(url);
      if (scrapedData == null) {
        return _createErrorResponse("Error al obtener el contenido de la URL");
      }

      // PASO 2: Análisis de sesgos
      print("🧠 Paso 2/3: Analizando sesgos...");
      final biasAnalysis = await _analyzeBias(scrapedData, text);
      if (biasAnalysis == null) {
        return _createErrorResponse("Error al analizar sesgos");
      }

      // PASO 3: Procesar con prompt service
      print("✨ Paso 3/3: Generando respuesta final...");
      final finalResult = await _processPrompt(biasAnalysis);
      if (finalResult == null) {
        return _createErrorResponse("Error al procesar la respuesta final");
      }

      print("✅ Proceso completado exitosamente");
      return finalResult;

    } catch (e) {
      print("❌ Error general en sendMessage: $e");
      return _createErrorResponse("Error en el análisis: $e");
    }
  }

  // Headers comunes para todas las peticiones
  Map<String, String> get _commonHeaders => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // PASO 1: Scraper
  Future<Map<String, dynamic>?> _scrapeContent(String url) async {
    try {
      print("📡 Enviando petición a scraper: $scraperUrl");
      print("📝 URL a scrapear: $url");

      final response = await client.post(
        Uri.parse(scraperUrl),
        headers: _commonHeaders,
        body: jsonEncode({"url": url}),
      ).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          throw Exception("Timeout: El scraper tardó demasiado");
        },
      );

      print("📥 Respuesta scraper: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        print("✅ Scraping exitoso");
        return jsonData;
      } else {
        print("❌ Error en scraper: ${response.statusCode}");
        print("Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error en _scrapeContent: $e");
      return null;
    }
  }

  // PASO 2: Análisis de sesgos
  Future<Map<String, dynamic>?> _analyzeBias(
    Map<String, dynamic> scrapedData,
    String userText,
  ) async {
    try {
      final requestBody = {
        "title": scrapedData['title'] ?? "",
        "paragraphs": scrapedData['mainContent'] ?? [],
        "user_text": userText,
      };

      print("📡 Enviando petición a analizador de sesgos");
      print("📝 Title: ${requestBody['title']}");
      print("📝 Paragraphs count: ${(requestBody['paragraphs'] as List).length}");
      print("📝 User text: ${requestBody['user_text']}");

      final response = await client.post(
        Uri.parse(biasAnalyzerUrl),
        headers: _commonHeaders,
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          throw Exception("Timeout: El análisis tardó demasiado");
        },
      );

      print("📥 Respuesta analizador: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        print("✅ Análisis exitoso");
        print("🔍 Estructura del análisis (keys): ${jsonData.keys}");
        print("🔍 Body análisis (primeros 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...");
        return jsonData;
      } else {
        print("❌ Error en analizador: ${response.statusCode}");
        print("Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error en _analyzeBias: $e");
      return null;
    }
  }

  // PASO 3: Procesar con prompt service
  Future<Map<String, dynamic>?> _processPrompt(
    Map<String, dynamic> biasAnalysis,
  ) async {
    try {
      print("📡 Enviando petición a procesador de prompts");
      
      // Intentar envolver en "distortion" si no viene así
      final requestBody = biasAnalysis.containsKey('distortion')
          ? biasAnalysis
          : {"distortion": biasAnalysis};
      
      final bodyString = jsonEncode(requestBody);
      print("📤 Datos enviados (primeros 500 chars): ${bodyString.substring(0, bodyString.length > 500 ? 500 : bodyString.length)}...");

      final response = await client.post(
        Uri.parse(promptProcessorUrl),
        headers: _commonHeaders,
        body: bodyString,
      ).timeout(
        const Duration(seconds: 90),
        onTimeout: () {
          throw Exception("Timeout: El procesador tardó demasiado");
        },
      );

      print("📥 Respuesta procesador: ${response.statusCode}");
      print("📥 Body respuesta completo: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        print("✅ Procesamiento exitoso");
        print("🔍 Keys del resultado final: ${jsonData.keys}");
        return jsonData;
      } else {
        print("❌ Error en procesador: ${response.statusCode}");
        print("Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error en _processPrompt: $e");
      return null;
    }
  }

  Map<String, dynamic> _createErrorResponse(String message) {
    return {
      "resultado": "ERROR",
      "explicacion": message,
      "sesgos_encontrados": [],
      "coincidencias": [],
    };
  }
}