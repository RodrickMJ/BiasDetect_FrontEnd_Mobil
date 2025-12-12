import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';

class TopBiasesCard extends StatelessWidget {
  final LocalStorageService localStorage;

  const TopBiasesCard({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topBiases = localStorage.getTopBiases();

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
              Icon(Icons.emoji_events, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Top 5 Sesgos Más Comunes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (topBiases.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Sin sesgos detectados aún',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ),
            )
          else
            ...topBiases.asMap().entries.map((entry) {
              final index = entry.key;
              final bias = entry.value;
              return _buildBiasRankItem(
                context,
                index + 1,
                bias['nombre'],
                bias['cantidad'],
                bias['porcentaje'],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBiasRankItem(
    BuildContext context,
    int rank,
    String name,
    int count,
    String percentage,
  ) {
    final cs = Theme.of(context).colorScheme;
    final rankColors = [
      Colors.amber,
      Colors.grey[400]!,
      Colors.brown[300]!,
      cs.primary,
      cs.secondary,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rankColors[rank - 1].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rankColors[rank - 1].withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColors[rank - 1],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  '$count ${count == 1 ? 'vez' : 'veces'} detectado',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: rankColors[rank - 1],
            ),
          ),
        ],
      ),
    );
  }
}



