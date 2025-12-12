import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/chat_provider.dart';

class ChatInputArea extends StatefulWidget {
  final String userId;

  const ChatInputArea({super.key, required this.userId});

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final _textController = TextEditingController();
  final _urlController = TextEditingController();
  bool _showUrlField = false;

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    final sendButtonColor = brightness == Brightness.light
        ? const Color(0xFF2563EB)
        : cs.primary;

    final sendIconColor = brightness == Brightness.light
        ? Colors.white
        : cs.onPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showUrlField)
            TextField(
              controller: _urlController,
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: "https://ejemplo.com/noticia (opcional)",
                hintStyle: TextStyle(color: cs.onSurfaceVariant),
                prefixIcon: Icon(Icons.link, size: 20, color: cs.primary),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, size: 20, color: cs.onSurfaceVariant),
                  onPressed: () => _urlController.clear(),
                ),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.primary, width: 2),
                ),
              ),
              onChanged: chatProvider.updateUrl,
            ),
          if (_showUrlField) const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => setState(() => _showUrlField = !_showUrlField),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _showUrlField ? sendButtonColor : cs.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _showUrlField ? Icons.check : Icons.link,
                    color: _showUrlField ? sendIconColor : cs.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: cs.onSurface),
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Escribe tu comentario...",
                      hintStyle: TextStyle(color: cs.onSurfaceVariant),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: cs.primary, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: chatProvider.isLoading ? cs.surfaceVariant : sendButtonColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send_rounded, color: sendIconColor, size: 20),
                  onPressed: chatProvider.isLoading ? null : () => _sendMessage(chatProvider),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatProvider chatProvider) {
    final text = _textController.text.trim();
    final url = _urlController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor escribe un comentario"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    _textController.clear();
    chatProvider.send(widget.userId, text, url);
  }
}