import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../atoms/card_container.dart';

class RecentAnalysesCard extends StatelessWidget {
  const RecentAnalysesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageService>();
    final recentAnalyses = localStorage.getRecentAnalyses();
    final cs = Theme.of(context).colorScheme;

    return CardContainer(
      title: 'Análisis Recientes',
      child: recentAnalyses.isEmpty
          ? Text('No hay análisis recientes', style: TextStyle(color: cs.onSurfaceVariant))
          : Column(
              children: recentAnalyses.take(5).map((analysis) {
                final cantidadSesgos = analysis['cantidadSesgos'] as int;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        cantidadSesgos > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                        color: cantidadSesgos > 0 ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cantidadSesgos > 0
                              ? '$cantidadSesgos ${cantidadSesgos == 1 ? 'sesgo' : 'sesgos'}'
                              : 'Sin sesgos',
                          style: TextStyle(fontSize: 14, color: cs.onSurface),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}