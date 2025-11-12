abstract class ChatRepository {
  Future<Map<String, dynamic>?> sendMessage(String userId, String text, String url);
}