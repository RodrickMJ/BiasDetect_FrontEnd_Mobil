//provider con datos simulados para performance page

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  PerformanceData(this.title, this.value, this.icon, this.color);

  
}

final performanceProvider = Provider<PerformanceData>((ref) {
  return PerformanceData(
    'lorem ipsum',
    '75% tracebility this week',
    Icons.bar_chart,
    Colors.redAccent,
  );
});

final metricsProvider = Provider<List<PerformanceData>>((ref) {
  return [
    PerformanceData(
      'lorem ipsum',
      '38 min per production',
      Icons.check_circle,
      Colors.teal,
    ),
    PerformanceData(
      'lorem ipsum',
      '75% tracebility this week',
      Icons.bar_chart,
      Colors.redAccent,
    ),
    PerformanceData(
      'lorem ipsum',
      'Important health alerts',
      Icons.star,
      Colors.orange,
    ),
    PerformanceData(
      'lorem ipsum',
      'Modules',
      Icons.auto_awesome,
      Colors.blue,
    ),
  ];
});

final summaryProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'progress': 75,
    'successRate': '75%',
    'completed': '28',
    'skipped': '01',
    'failed': '3',
  };
});
