import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentAnalysesList extends StatelessWidget {
  final LocalStorageService localStorage;

  const RecentAnalysesList({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final recent = localStorage.getRecentAnalyses();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Análisis Recientes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recent.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No hay análisis recientes',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ),
            )
          else
            ...recent.map((analysis) {
              final timestamp = analysis['timestamp'] as DateTime;
              final cantidadSesgos = analysis['cantidadSesgos'] as int;
              final resultado = analysis['resultado'] as String;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cantidadSesgos > 0
                      ? cs.errorContainer.withOpacity(0.3)
                      : cs.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      cantidadSesgos > 0
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: cantidadSesgos > 0 ? cs.error : cs.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cantidadSesgos > 0
                                ? '$cantidadSesgos ${cantidadSesgos == 1 ? 'sesgo detectado' : 'sesgos detectados'}'
                                : 'Sin sesgos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: cs.onSurface,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}