import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/chat_provider.dart';

class ChatLoadingIndicator extends StatelessWidget {
  const ChatLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              chatProvider.loadingMessage,
              style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}