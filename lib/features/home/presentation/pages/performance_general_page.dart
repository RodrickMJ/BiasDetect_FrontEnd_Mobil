import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bias_detect/core/router/app_routes.dart';
import 'package:provider/provider.dart';

import '../provider/performance_provider.dart';
import '../widgets/molecules/metric_card.dart';
import '../widgets/molecules/toggle_switch.dart';
import '../widgets/components/progress_chart.dart';
import '../widgets/components/summary_card.dart';

class PerformanceGeneralPage extends ConsumerWidget {
  const PerformanceGeneralPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(metricsProvider);
    final summary = ref.watch(summaryProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ TOP BAR (Simula un AppBar)
            Container(
              color: cs.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: cs.onSurface),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),

                  const Expanded(
                    child: Text(
                      'Performance General',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            /// ✅ CONTENIDO SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ✅ Switch General/Detallado
                    const ToggleSwitch(
                      leftText: 'General',
                      rightText: 'Detallado',
                      isLeftActive: true,
                    ),
                    const SizedBox(height: 24),

                    /// ✅ Tarjetas de métricas
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: metrics.map((m) {
                        return MetricCard(
                          title: m.title,
                          value: m.value,
                          icon: m.icon,
                          color: m.color,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    const ProgressChart(),
                    const SizedBox(height: 24),

                    /// ✅ Resumen
                    SummaryCard(
                      progress: summary['progress'],
                      successRate: summary['successRate'],
                      completed: summary['completed'],
                      skipped: summary['skipped'],
                      failed: summary['failed'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
