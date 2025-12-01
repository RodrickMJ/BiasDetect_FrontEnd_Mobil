import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definición de un modelo simple para el historial de chat
class ChatHistoryItem {
  final String title;
  final String content;

  ChatHistoryItem({required this.title, required this.content});
}

// Datos de ejemplo para simular el historial
final List<Map<String, dynamic>> dummyHistoryData = [
  {
    'group': 'Today',
    'items': [
      ChatHistoryItem(
          title: 'Titulo Del Chat',
          content:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.'),
      ChatHistoryItem(
          title: 'Titulo Del Chat',
          content:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.'),
    ]
  },
  {
    'group': 'This Week',
    'items': [
      ChatHistoryItem(
          title: 'Titulo Del Chat',
          content:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.'),
      ChatHistoryItem(
          title: 'Titulo Del Chat',
          content:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.'),
      ChatHistoryItem(
          title: 'Titulo Del Chat',
          content:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.'),
    ]
  },
];

class HistoryScreen extends ConsumerWidget {
  static const String routeName = '/history';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Chatbot Screen'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyHistoryData.length,
        itemBuilder: (context, index) {
          final groupData = dummyHistoryData[index];
          final groupTitle = groupData['group'] as String;
          final items = groupData['items'] as List<ChatHistoryItem>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del grupo (Today, This Week)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  groupTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              // Lista de elementos del historial
              ...items.map((item) => _ChatHistoryCard(
                item: item,
                colorScheme: colorScheme,
              )),
            ],
          );
        },
      ),
      // El diseño de la imagen sugiere una barra de navegación inferior,
      // pero para mantener el enfoque en la vista, solo implemento el cuerpo.
      // Si el proyecto usa un widget de navegación inferior global, se mantendrá.
    );
  }
}

class _ChatHistoryCard extends StatelessWidget {
  final ChatHistoryItem item;
  final ColorScheme colorScheme;

  const _ChatHistoryCard({required this.item, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: colorScheme.primaryContainer.withOpacity(0.5), // Color similar al de la imagen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              item.content,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
