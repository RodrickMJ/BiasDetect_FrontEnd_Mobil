import 'package:flutter/material.dart';
import '../molecules/metric_card.dart';

class UserMetricCards extends StatelessWidget {
  const UserMetricCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        MetricCard(
          title: 'Textos Analizados',
          value: '1,458',
          icon: Icons.text_fields,
          color: Colors.green,
        ),
        MetricCard(
          title: 'Sesgos Detectados',
          value: '3,892',
          icon: Icons.warning,
          color: Colors.red,
        ),
        MetricCard(
          title: 'Tasa Polarización',
          value: '68%',
          icon: Icons.bar_chart,
          color: Colors.orange,
        ),
        MetricCard(
          title: 'Confianza Media',
          value: '91%',
          icon: Icons.thumb_up,
          color: Colors.blue,
        ),
      ],
    );
  }
}