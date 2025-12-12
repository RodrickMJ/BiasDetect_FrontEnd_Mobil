import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  PerformanceData(this.title, this.value, this.icon, this.color);
}

// Provider para métricas reales
final metricsProvider = Provider<List<PerformanceData>>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  final metrics = localStorage.getMetrics();

  return [
    PerformanceData(
      'Total de Análisis',
      '${metrics['totalAnalisis']} realizados',
      Icons.analytics_outlined,
      Colors.blue,
    ),
    PerformanceData(
      'Con Sesgos',
      '${metrics['porcentajeSesgos']}% detectados',
      Icons.warning_amber_rounded,
      Colors.orange,
    ),
    PerformanceData(
      'Sin Sesgos',
      '${metrics['sinSesgos']} análisis',
      Icons.check_circle_outline,
      Colors.green,
    ),
    PerformanceData(
      'Promedio Sesgos',
      '${metrics['promedioSesgos']} por análisis',
      Icons.trending_up,
      Colors.purple,
    ),
  ];
});

// Provider para resumen
final summaryProvider = Provider<Map<String, dynamic>>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  final metrics = localStorage.getMetrics();

  final conSesgos = metrics['conSesgos'] as int;
  final total = metrics['totalAnalisis'] as int;
  final progress = total > 0 ? ((conSesgos / total) * 100).toInt() : 0;

  return {
    'progress': progress,
    'successRate': '${metrics['porcentajeSesgos']}%',
    'completed': '${metrics['sinSesgos']}',
    'skipped': '0',
    'failed': '${metrics['conSesgos']}',
  };
});

// Provider para datos semanales
final weeklyDataProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return localStorage.getWeeklyProgress();
});

// Provider para LocalStorage
final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('LocalStorageProvider must be overridden');
});