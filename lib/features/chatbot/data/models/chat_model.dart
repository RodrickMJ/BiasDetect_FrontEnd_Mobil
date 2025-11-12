import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends ChatMessage {
  ChatModel({
    required super.sender,
    required super.text,
    super.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      sender: map['sender'] ?? "",
      text: map['text'] ?? "",
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "timestamp": timestamp,
    };
  }
}