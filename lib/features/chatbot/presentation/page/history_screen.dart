import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/chatbot/presentation/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final localStorage = context.read<LocalStorageService>();

    return Container(
      color: cs.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP BAR
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
                    onPressed: () =>
                        _showClearHistoryDialog(context, localStorage),
                  ),
                ],
              ),
            ),

            // CONTENIDO
            Expanded(child: _buildHistoryList(context, localStorage)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    LocalStorageService localStorage,
  ) {
    final grouped = localStorage.getGroupedConversations();

    if (grouped.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final groupTitle = grouped.keys.elementAt(index);
        final conversations = grouped[groupTitle]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                groupTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ...conversations.map(
              (conv) => _ChatHistoryCard(
                conversationId: conv.id,
                title: conv.title,
                lastMessage: _getLastUserMessage(conv.messages),
                updatedAt: conv.updatedAt,
                onTap: () => _loadConversation(context, conv.id),
                onDelete: () =>
                    _deleteConversation(context, localStorage, conv.id),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getLastUserMessage(List messages) {
    final userMessages = messages.where((m) => m.sender == 'user').toList();
    if (userMessages.isEmpty) return 'Sin mensajes';

    final lastMsg = userMessages.last.text as String;
    return lastMsg.length <= 100 ? lastMsg : '${lastMsg.substring(0, 100)}...';
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: cs.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay conversaciones guardadas',
            style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _loadConversation(BuildContext context, String conversationId) async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadConversation(conversationId);

    // Navegar usando go_router
    if (context.mounted) {
      context.go('/chat'); // 👈 USAR context.go en lugar de Navigator.pop
    }
  }

  void _deleteConversation(
    BuildContext context,
    LocalStorageService localStorage,
    String conversationId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar conversación'),
        content: const Text('¿Estás seguro de eliminar esta conversación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await localStorage.deleteConversation(conversationId);
              Navigator.pop(context);
              if (mounted) setState(() {});
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    LocalStorageService localStorage,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar historial'),
        content: const Text('¿Eliminar todas las conversaciones?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await localStorage.clearAll();
              Navigator.pop(context);
              if (mounted) setState(() {});
            },
            child: Text(
              'Eliminar todo',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatHistoryCard extends StatelessWidget {
  final String conversationId;
  final String title;
  final String lastMessage;
  final DateTime updatedAt;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatHistoryCard({
    required this.conversationId,
    required this.title,
    required this.lastMessage,
    required this.updatedAt,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: cs.primaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cs.onPrimaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lastMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: cs.onPrimaryContainer.withOpacity(0.85),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onPrimaryContainer.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: cs.error),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
