import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/chat_provider.dart';
import '../molecules/message_bubble.dart';
import '../molecules/chat_input_area.dart';
import '../atoms/chat_empty_state.dart';
import '../atoms/chat_loading_indicator.dart';
import '../atoms/new_conversation_dialog.dart';

class ChatView extends StatelessWidget {
  final String userId;

  const ChatView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(bottom: BorderSide(color: cs.outlineVariant)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Detector de Sesgos",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_comment_outlined, color: cs.onSurface),
                tooltip: 'Nueva conversación',
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => NewConversationDialog(
                    hasMessages: chatProvider.messages.isNotEmpty,
                    onConfirm: () {
                      chatProvider.clearCurrentChat();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Mensajes
        Expanded(
          child: chatProvider.messages.isEmpty
              ? const ChatEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length + (chatProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chatProvider.messages.length) {
                      return const ChatLoadingIndicator();
                    }
                    final message = chatProvider.messages[index];
                    final isUser = message.sender == "user";
                    return MessageBubble(message: message, isUser: isUser);
                  },
                ),
        ),

        // Área de entrada
        ChatInputArea(userId: userId),
      ],
    );
  }
}