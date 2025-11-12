class ChatMessage {
  final String sender; 
  final String text;  
  final DateTime? timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'] ?? 'assistant',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}