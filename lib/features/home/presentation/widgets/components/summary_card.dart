import 'package:flutter/material.dart';
import '../molecules/summary_item.dart';

class SummaryCard extends StatelessWidget {
  final int progress;
  final String successRate;
  final String completed;
  final String skipped;
  final String failed;

  const SummaryCard({
    super.key,
    required this.progress,
    required this.successRate,
    required this.completed,
    required this.skipped,
    required this.failed,
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
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.summarize, color: cs.onSurfaceVariant, size: 20),
              const SizedBox(width: 8),

              /// ✅ Título y subtítulo organizados correctamente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "You're $progress% toward your daily goals",
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(Icons.keyboard_arrow_down, color: cs.onSurfaceVariant),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SummaryItem(
                value: successRate,
                label: 'Success Rate',
                color: Colors.teal,
              ),
              SummaryItem(
                value: completed,
                label: 'Completed',
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SummaryItem(value: skipped, label: 'Skipped', color: Colors.grey),
              SummaryItem(value: failed, label: 'Failed', color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}
