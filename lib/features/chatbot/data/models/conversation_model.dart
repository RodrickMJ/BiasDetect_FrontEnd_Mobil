import 'package:hive/hive.dart';
import '../../domain/entities/chat.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: 0)
class ConversationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  @HiveField(4)
  final List<ChatMessageModel> messages;

  @HiveField(5)
  final String? url;

  ConversationModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    this.url,
  });

  // Generar título automático desde el primer mensaje del usuario
  static String generateTitle(String firstMessage) {
    if (firstMessage.length <= 50) return firstMessage;
    return '${firstMessage.substring(0, 50)}...';
  }
}

@HiveType(typeId: 1)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String sender;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime? timestamp;

  ChatMessageModel({
    required this.sender,
    required this.text,
    this.timestamp,
  });

  // Convertir desde ChatMessage
  factory ChatMessageModel.fromEntity(ChatMessage message) {
    return ChatMessageModel(
      sender: message.sender,
      text: message.text,
      timestamp: message.timestamp,
    );
  }

  // Convertir a ChatMessage
  ChatMessage toEntity() {
    return ChatMessage(
      sender: sender,
      text: text,
      timestamp: timestamp,
    );
  }
}