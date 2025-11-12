import '../repository/chat_respository.dart';

class ChatUsecase {
  final ChatRepository repository;

  ChatUsecase(this.repository);

  Future<Map<String, dynamic>?> sendMessage(String userId, String text, String url) {
    return repository.sendMessage(userId, text, url);
  }
}