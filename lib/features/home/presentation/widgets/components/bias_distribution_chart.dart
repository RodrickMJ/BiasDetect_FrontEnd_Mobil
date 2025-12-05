import 'package:flutter/material.dart';
import '../../../../chatbot/data/datasource/local_storage_service.dart';

class BiasDistributionChart extends StatelessWidget {
  final LocalStorageService localStorage;

  const BiasDistributionChart({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final distribution = localStorage.getBiasDistribution();

    if (distribution.isEmpty) {
      return _buildEmptyState(cs);
    }

    final maxCount = distribution.values.reduce((a, b) => a > b ? a : b);

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
              Icon(Icons.bar_chart, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Distribución de Sesgos',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...distribution.entries.map((entry) {
            final biasCount = entry.key;
            final occurrences = entry.value;
            final percentage = (occurrences / maxCount);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$biasCount ${biasCount == 1 ? 'sesgo' : 'sesgos'}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        '$occurrences ${occurrences == 1 ? 'análisis' : 'análisis'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: cs.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        _getColorForBiasCount(biasCount),
                      ),
                      minHeight: 8,
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

  Widget _buildEmptyState(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Sin datos de distribución',
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
      ),
    );
  }

  Color _getColorForBiasCount(int count) {
    if (count == 0) return Colors.green;
    if (count <= 2) return Colors.blue;
    if (count <= 4) return Colors.orange;
    return Colors.red;
  }
}