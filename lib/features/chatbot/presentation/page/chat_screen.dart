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

    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;

    // Botón de enviar: azul fijo en Light Mode
    final sendButtonColor = brightness == Brightness.light
        ? const Color(0xFF2563EB)
        : cs.primary;

    final sendIconColor = brightness == Brightness.light
        ? Colors.white
        : cs.onPrimary;

    return SafeArea(
      child: Column(
        children: [
          // HEADER --------------------------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(bottom: BorderSide(color: cs.outlineVariant)),
            ),
            child: Row(
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu, color: cs.onSurface),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Chat Bot",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // BODY ---------------------------------------------------------------------------
          Expanded(
            child: chatProv.messages.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        chatProv.messages.length + (chatProv.isLoading ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == chatProv.messages.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Analizando...",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final msg = chatProv.messages[i];
                      final isUser = msg.sender == "user";

                      return MessageBubble(message: msg, isUser: isUser);
                    },
                  ),
          ),

          // INPUT --------------------------------------------------------------------------
          _buildInputArea(
            context,
            chatProv,
            userId,
            sendButtonColor,
            sendIconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hello User",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Where do we start?",
            style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    ChatProvider chatProv,
    String userId,
    Color sendButtonColor,
    Color sendIconColor,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        children: [
          if (_showUrlField)
            TextField(
              controller: TextEditingController(text: chatProv.currentUrl),
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: "https://example.com/noticia",
                hintStyle: TextStyle(color: cs.onSurfaceVariant),
                prefixIcon: Icon(Icons.link, size: 20, color: cs.primary),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                  backgroundColor: cs.brightness == Brightness.light
                            ? const Color(0xFF2563EB) // Fondo azul en light
                            : cs.primary,
                  child: Icon(
                    _showUrlField ? Icons.check : Icons.link,
                    color: sendIconColor,            
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: TextField(
                  controller: _textController,
                  style: TextStyle(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: "Message Chat",
                    hintStyle: TextStyle(color: cs.onSurfaceVariant),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(chatProv, userId),
                ),
              ),

              const SizedBox(width: 8),

              CircleAvatar(
                radius: 22,
                backgroundColor: chatProv.isLoading
                    ? cs.surfaceVariant
                    : sendButtonColor,
                child: IconButton(
                  icon: Icon(Icons.send, color: sendIconColor),
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

    _scrollToBottom();
  }
}
