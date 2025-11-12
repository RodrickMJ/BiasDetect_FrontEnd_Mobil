import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ChatService {
  Future<Map<String, dynamic>?> sendMessage(String userId, String text, String url);
}

class ChatServiceImpl implements ChatService {
  final http.Client client;
  final String baseUrl = "https://z1bn8fjr-3001.usw3.devtunnels.ms";
  

  ChatServiceImpl(this.client);

  @override
  Future<Map<String, dynamic>?> sendMessage(String userId, String text, String url) async {
    try {
      final endpoint = Uri.parse("$baseUrl/analyze/");

      final response = await client.post(
        endpoint,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "url": url,
          "text": text,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'];
      } else {
        print("Error en API: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error en sendMessage: $e");
      return null;
    }
  }
}