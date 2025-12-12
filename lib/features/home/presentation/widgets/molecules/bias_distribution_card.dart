import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../atoms/card_container.dart';

class BiasDistributionCard extends StatelessWidget {
  const BiasDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageService>();
    final distribution = localStorage.getBiasDistribution();
    final cs = Theme.of(context).colorScheme;

    return CardContainer(
      title: 'Distribución de Sesgos',
      child: distribution.isEmpty
          ? Text('Sin datos de distribución', style: TextStyle(color: cs.onSurfaceVariant))
          : Column(
              children: distribution.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entry.key} ${entry.key == 1 ? 'sesgo' : 'sesgos'}',
                          style: TextStyle(fontSize: 14, color: cs.onSurface),
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
                  )).toList(),
            ),
    );
  }
}