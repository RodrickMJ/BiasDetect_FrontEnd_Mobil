import 'package:flutter/material.dart';
import '../../../../chatbot/data/datasource/local_storage_service.dart';

class MonthlyTrendsChart extends StatelessWidget {
  final LocalStorageService localStorage;

  const MonthlyTrendsChart({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final trends = localStorage.getMonthlyTrends();

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
              Icon(Icons.timeline, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tendencias Mensuales',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: trends.isEmpty || trends.every((t) => t['total'] == 0)
                ? Center(
                    child: Text(
                      'Sin datos mensuales',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: trends.map((trend) {
                      final total = trend['total'] as int;
                      final maxTotal = trends
                          .map((t) => t['total'] as int)
                          .reduce((a, b) => a > b ? a : b);
                      final height = maxTotal > 0 ? (total / maxTotal) * 150 : 10.0;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (total > 0)
                            Text(
                              '$total',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  cs.primary,
                                  cs.primary.withOpacity(0.6),
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            trend['mes'],
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}