import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../atoms/card_container.dart';

class TopBiasesCard extends StatelessWidget {
  const TopBiasesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageService>();
    final topBiases = localStorage.getTopBiases();
    final cs = Theme.of(context).colorScheme;

    return CardContainer(
      title: 'Top Sesgos Más Comunes',
      child: topBiases.isEmpty
          ? Text('Sin sesgos detectados aún', style: TextStyle(color: cs.onSurfaceVariant))
          : Column(
              children: topBiases.map((bias) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            bias['nombre'],
                            style: TextStyle(fontSize: 14, color: cs.onSurface),
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
                  )).toList(),
            ),
    );
  }
}