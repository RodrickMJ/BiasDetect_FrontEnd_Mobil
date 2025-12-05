import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chatbot/data/datasource/local_storage_service.dart';
import '../widgets/molecules/metric_card.dart';
import '../widgets/molecules/toggle_switch.dart';
import '../widgets/components/progress_chart_real.dart';
import '../widgets/components/summary_card.dart';
import '../widgets/components/recommendations_section.dart';
import '../widgets/components/bias_examples_section.dart';

class PerformanceGeneralPage extends StatefulWidget {
  const PerformanceGeneralPage({super.key});

  @override
  State<PerformanceGeneralPage> createState() => _PerformanceGeneralPageState();
}

class _PerformanceGeneralPageState extends State<PerformanceGeneralPage> {
  bool _isGeneralView = true;

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageService>();
    final metricsData = localStorage.getMetrics();
    final cs = Theme.of(context).colorScheme;

    final metrics = [
      _MetricData(
        'Total de Análisis',
        '${metricsData['totalAnalisis']} realizados',
        Icons.analytics_outlined,
        Colors.blue,
      ),
      _MetricData(
        'Con Sesgos',
        '${metricsData['porcentajeSesgos']}% detectados',
        Icons.warning_amber_rounded,
        Colors.orange,
      ),
      _MetricData(
        'Sin Sesgos',
        '${metricsData['sinSesgos']} análisis',
        Icons.check_circle_outline,
        Colors.green,
      ),
      _MetricData(
        'Promedio Sesgos',
        '${metricsData['promedioSesgos']} por análisis',
        Icons.trending_up,
        Colors.purple,
      ),
    ];

    final conSesgos = metricsData['conSesgos'] as int;
    final total = metricsData['totalAnalisis'] as int;
    final progress = total > 0 ? ((conSesgos / total) * 100).toInt() : 0;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP BAR
            Container(
              color: cs.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isGeneralView ? 'Performance General' : 'Performance Detallado',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // CONTENIDO
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Toggle con tap funcional
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isGeneralView = !_isGeneralView;
                        });
                      },
                      child: ToggleSwitch(
                        leftText: 'General',
                        rightText: 'Detallado',
                        isLeftActive: _isGeneralView,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contenido según vista
                    if (_isGeneralView) ...[
                      // VISTA GENERAL
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
                      RecommendationsSection(
                        recommendations: localStorage.getPersonalizedRecommendations(),
                      ),
                      const SizedBox(height: 24),
                      BiasExamplesSection(
                        examples: localStorage.getBiasExamples(),
                      ),
                    ] else ...[
                      // VISTA DETALLADA - POR AHORA SIMPLE
                      _buildDetailedViewSimple(localStorage, cs),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedViewSimple(LocalStorageService localStorage, ColorScheme cs) {
    final topBiases = localStorage.getTopBiases();
    final distribution = localStorage.getBiasDistribution();
    final recentAnalyses = localStorage.getRecentAnalyses();

    return Column(
      children: [
        // Top Sesgos
        Container(
          width: double.infinity,
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
              Text(
                '🏆 Top Sesgos Más Comunes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              if (topBiases.isEmpty)
                Text(
                  'Sin sesgos detectados aún',
                  style: TextStyle(color: cs.onSurfaceVariant),
                )
              else
                ...topBiases.map((bias) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              bias['nombre'],
                              style: TextStyle(
                                fontSize: 14,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            '${bias['cantidad']} (${bias['porcentaje']}%)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Distribución
        Container(
          width: double.infinity,
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
              Text(
                '📊 Distribución de Sesgos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              if (distribution.isEmpty)
                Text(
                  'Sin datos de distribución',
                  style: TextStyle(color: cs.onSurfaceVariant),
                )
              else
                ...distribution.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entry.key} ${entry.key == 1 ? 'sesgo' : 'sesgos'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          '${entry.value} análisis',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Análisis recientes
        Container(
          width: double.infinity,
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
              Text(
                '📝 Análisis Recientes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              if (recentAnalyses.isEmpty)
                Text(
                  'No hay análisis recientes',
                  style: TextStyle(color: cs.onSurfaceVariant),
                )
              else
                ...recentAnalyses.take(5).map((analysis) {
                  final cantidadSesgos = analysis['cantidadSesgos'] as int;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          cantidadSesgos > 0
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          color: cantidadSesgos > 0 ? Colors.orange : Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cantidadSesgos > 0
                                ? '$cantidadSesgos ${cantidadSesgos == 1 ? 'sesgo' : 'sesgos'}'
                                : 'Sin sesgos',
                            style: TextStyle(
                              fontSize: 14,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
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