import 'package:flutter/material.dart';

class RecommendationsSection extends StatelessWidget {
  final List<String> recommendations;

  const RecommendationsSection({
    super.key,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              Icon(Icons.lightbulb_outline, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recomendaciones',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getEmoji(rec),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _removeEmoji(rec),
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _getEmoji(String text) {
    final match = RegExp(r'^[\p{Emoji}]+', unicode: true).firstMatch(text);
    return match?.group(0) ?? '•';
  }

  String _removeEmoji(String text) {
    return text.replaceFirst(RegExp(r'^[\p{Emoji}\s]+', unicode: true), '');
  }
}