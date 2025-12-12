import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../provider/chat_history_provider.dart';
import '../../provider/chat_provider.dart';
import '../atoms/empty_history_state.dart';
import '../molecules/chat_history_card.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<ChatHistoryProvider>();
    final chatProvider = context.read<ChatProvider>();
    final localStorage = context.read<LocalStorageService>();
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar con botón de limpiar historial
        Container(
          color: cs.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Historial',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: cs.error),
                onPressed: historyProvider.conversations.isEmpty
                    ? null
                    : () => _showClearHistoryDialog(context, localStorage, historyProvider),
              ),
            ],
          ),
        ),

        // Contenido
        Expanded(
          child: historyProvider.conversations.isEmpty
              ? const EmptyHistoryState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: historyProvider.conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = historyProvider.conversations[index];

                    return ChatHistoryCard(
                      conversation: conversation,
                      onTap: () async {
                        await historyProvider.loadConversationIntoChat(
                          conversation.id,
                          chatProvider.messages,
                        );
                        chatProvider.updateUrl(conversation.url ?? "");
                        if (context.mounted) {
                          context.go('/chat');
                        }
                      },
                      onDelete: () => _showDeleteDialog(context, conversation.id, historyProvider),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String conversationId, ChatHistoryProvider historyProvider) {
    final cs = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar conversación'),
        content: const Text('¿Estás seguro de eliminar esta conversación?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await historyProvider.deleteConversation(conversationId);
            },
            child: Text('Eliminar', style: TextStyle(color: cs.error)),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, LocalStorageService localStorage, ChatHistoryProvider historyProvider) {
    final cs = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar historial'),
        content: const Text('¿Eliminar todas las conversaciones?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await localStorage.clearAll();
              await historyProvider.loadConversations();
            },
            child: Text('Eliminar todo', style: TextStyle(color: cs.error)),
          ),
        ],
      ),
    );
  }
}