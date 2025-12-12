import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import '../molecules/metric_card.dart';
import '../components/progress_chart_real.dart';
import '../components/summary_card.dart';
import '../components/recommendations_section.dart';
import '../components/bias_examples_section.dart';

class PerformanceGeneralView extends StatelessWidget {
  final LocalStorageService localStorage;

  const PerformanceGeneralView({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final metricsData = localStorage.getMetrics();
    final cs = Theme.of(context).colorScheme;

    final metrics = [
      _MetricData('Total de Análisis', '${metricsData['totalAnalisis']} realizados', Icons.analytics_outlined, Colors.blue),
      _MetricData('Con Sesgos', '${metricsData['porcentajeSesgos']}% detectados', Icons.warning_amber_rounded, Colors.orange),
      _MetricData('Sin Sesgos', '${metricsData['sinSesgos']} análisis', Icons.check_circle_outline, Colors.green),
      _MetricData('Promedio Sesgos', '${metricsData['promedioSesgos']} por análisis', Icons.trending_up, Colors.purple),
    ];

    final conSesgos = metricsData['conSesgos'] as int;
    final total = metricsData['totalAnalisis'] as int;
    final progress = total > 0 ? ((conSesgos / total) * 100).toInt() : 0;

    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: metrics.map((m) => MetricCard(
            title: m.title,
            value: m.value,
            icon: m.icon,
            color: m.color,
          )).toList(),
        ),
        const SizedBox(height: 24),
        ProgressChartReal(localStorage: localStorage),
        const SizedBox(height: 24),
        SummaryCard(
          progress: progress,
          successRate: '${metricsData['porcentajeSesgos']}%',
          completed: '${metricsData['sinSesgos']}',
          skipped: '0',
          failed: '${metricsData['conSesgos']}',
        ),
        const SizedBox(height: 24),
        RecommendationsSection(recommendations: localStorage.getPersonalizedRecommendations()),
        const SizedBox(height: 24),
        BiasExamplesSection(examples: localStorage.getBiasExamples()),
      ],
    );
  }
}

class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  _MetricData(this.title, this.value, this.icon, this.color);
}