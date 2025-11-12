import 'package:bias_detect/features/chatbot/domain/repository/chat_respository.dart';
import '../datasource/service_chat.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatService service;

  ChatRepositoryImpl(this.service);

  @override
  Future<Map<String, dynamic>?> sendMessage(String userId, String text, String url) {
    return service.sendMessage(userId, text, url);
  }
}