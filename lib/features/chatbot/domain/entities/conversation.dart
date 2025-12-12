import 'package:bias_detect/features/chatbot/domain/entities/chat.dart';

class Conversation {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final String? url;
  final DateTime timestamp;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    this.url,
    required this.timestamp,
  });
}