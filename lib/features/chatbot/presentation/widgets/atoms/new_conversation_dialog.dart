import 'package:flutter/material.dart';

class NewConversationDialog extends StatelessWidget {
  final bool hasMessages;
  final VoidCallback onConfirm;

  const NewConversationDialog({
    super.key,
    required this.hasMessages,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMessages) {
      onConfirm();
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Nueva conversación'),
      content: const Text('¿Iniciar una nueva conversación? La actual se guardará en el historial.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Iniciar'),
        ),
      ],
    );
  }
}