import 'package:flutter/material.dart';

class ClearHistoryDialog extends StatelessWidget {
  final VoidCallback onClear;

  const ClearHistoryDialog({
    super.key,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Limpiar historial'),
      content: const Text('¿Eliminar todas las conversaciones?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onClear();
          },
          child: Text(
            'Eliminar todo',
            style: TextStyle(color: cs.error),
          ),
        ),
      ],
    );
  }
}