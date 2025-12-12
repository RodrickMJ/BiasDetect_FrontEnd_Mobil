import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';

class SentimentAnalysisCard extends StatelessWidget {
  final LocalStorageService localStorage;

  const SentimentAnalysisCard({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sentiment = localStorage.getSentimentAnalysis();

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
              Icon(Icons.sentiment_satisfied_alt, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Análisis de Sentimiento',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSentimentItem(
                cs,
                '😊',
                'Positivo',
                sentiment['positivos'],
                Colors.green,
              ),
              _buildSentimentItem(
                cs,
                '😐',
                'Neutral',
                sentiment['neutrales'],
                Colors.grey,
              ),
              _buildSentimentItem(
                cs,
                '😟',
                'Negativo',
                sentiment['negativos'],
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentItem(
    ColorScheme cs,
    String emoji,
    String label,
    int count,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}


