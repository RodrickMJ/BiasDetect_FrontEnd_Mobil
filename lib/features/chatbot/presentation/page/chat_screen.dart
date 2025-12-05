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
  final TextEditingController _urlController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showUrlField = false;

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
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

    final sendButtonColor = brightness == Brightness.light
        ? const Color(0xFF2563EB)
        : cs.primary;

    final sendIconColor = brightness == Brightness.light
        ? Colors.white
        : cs.onPrimary;

    return SafeArea(
      child: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(bottom: BorderSide(color: cs.outlineVariant)),
            ),
            child: Row(
              children: [
                // 
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
                // 👇 BOTÓN PARA NUEVA CONVERSACIÓN
                IconButton(
                  icon: Icon(Icons.add_comment_outlined, color: cs.onSurface),
                  tooltip: 'Nueva conversación',
                  onPressed: () {
                    // Mostrar confirmación si hay mensajes
                    if (chatProv.messages.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Nueva conversación'),
                          content: const Text(
                            '¿Iniciar una nueva conversación? La actual se guardará en el historial.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                chatProv.startNewConversation();
                              },
                              child: const Text('Iniciar'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      chatProv.startNewConversation();
                    }
                  },
                ),
              ],
            ),
          ),

          // BODY
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
                        return _buildLoadingIndicator(context, chatProv);
                      }

                      final msg = chatProv.messages[i];
                      final isUser = msg.sender == "user";

                      return MessageBubble(message: msg, isUser: isUser);
                    },
                  ),
          ),

          // INPUT
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

  Widget _buildLoadingIndicator(BuildContext context, ChatProvider chatProv) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              chatProv.loadingMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: cs.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "Detector de Sesgos Cognitivos",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Ingresa una URL y tu comentario para analizar posibles sesgos",
              style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 IMPORTANTE
        children: [
          // Campo URL (solo visible cuando se activa)
          if (_showUrlField) ...[
            TextField(
              controller: _urlController,
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: "https://ejemplo.com/noticia",
                hintStyle: TextStyle(color: cs.onSurfaceVariant),
                prefixIcon: Icon(Icons.link, size: 20, color: cs.primary),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: chatProv.updateUrl,
            ),
            const SizedBox(height: 12),
          ],

          // Fila con botón link, campo de texto y botón enviar
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Botón para mostrar/ocultar campo URL
              GestureDetector(
                onTap: () => setState(() => _showUrlField = !_showUrlField),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _showUrlField
                        ? (brightness == Brightness.light
                              ? const Color(0xFF2563EB)
                              : cs.primary)
                        : cs.surfaceContainerHighest,
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

              // Campo de texto (expandible)
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 120, // 👈 Altura máxima para scroll
                  ),
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: cs.onSurface),
                    maxLines: null, // 👈 Permite múltiples líneas
                    minLines: 1, // 👈 Mínimo 1 línea
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Escribe tu comentario...",
                      hintStyle: TextStyle(color: cs.onSurfaceVariant),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: cs.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: cs.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: cs.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Botón enviar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: chatProv.isLoading
                      ? cs.surfaceVariant
                      : sendButtonColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: sendIconColor,
                    size: 20,
                  ),
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
    final url = _urlController.text.trim();

    // Validar que ambos campos estén llenos
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor escribe un comentario"),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor ingresa una URL válida"),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Agregar',
            textColor: Colors.white,
            onPressed: () {
              setState(() => _showUrlField = true);
            },
          ),
        ),
      );
      return;
    }

    _textController.clear();
    await chatProv.send(userId, text, url);

    _scrollToBottom();
  }
}
