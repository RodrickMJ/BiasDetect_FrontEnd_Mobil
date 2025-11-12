import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/chatbot/presentation/provider/chat_provider.dart';
import 'package:bias_detect/features/chatbot/presentation/widgets/molecules/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showUrlField = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = Provider.of<ChatProvider>(context);
    final loginProv = Provider.of<LoginProvider>(context);
    final userId = loginProv.user?.id ?? "";

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: const Center(
              child: Text(
                "Chat Bot",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Contenido principal
          Expanded(
            child: chatProv.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatProv.messages.length + (chatProv.isLoading ? 1 : 0),
                    itemBuilder: (_, i) {
                      // Indicador de carga al final
                      if (i == chatProv.messages.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Analizando...",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      }

                      final msg = chatProv.messages[i];
                      final isUser = msg.sender == "user";
                      
                      return MessageBubble(
                        message: msg,
                        isUser: isUser,
                      );
                    },
                  ),
          ),

          // Input
          _buildInputArea(chatProv, userId),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hello User",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Where do we start?",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatProvider chatProv, String userId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          if (_showUrlField)
            TextField(
              controller: TextEditingController(text: chatProv.currentUrl),
              decoration: InputDecoration(
                hintText: "https://example.com/noticia",
                prefixIcon: const Icon(Icons.link, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: chatProv.updateUrl,
            ),

          if (_showUrlField) const SizedBox(height: 8),

          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _showUrlField = !_showUrlField),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      _showUrlField ? Colors.blue : Colors.grey.shade300,
                  child: Icon(
                    _showUrlField ? Icons.check : Icons.link,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "Message Chat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(chatProv, userId),
                ),
              ),
              const SizedBox(width: 8),

              CircleAvatar(
                radius: 22,
                backgroundColor: chatProv.isLoading ? Colors.grey : Colors.blue,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: chatProv.isLoading 
                      ? null 
                      : () => _sendMessage(chatProv, userId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatProvider chatProv, String userId) async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    await chatProv.send(userId, text, chatProv.currentUrl);
    
    // Scroll al final después de enviar
    _scrollToBottom();
  }
}