import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
class DetailedAnalysisView extends StatelessWidget {
  final LocalStorageService localStorage;

  const DetailedAnalysisView({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final distortionStats = localStorage.getDistortionStats();
    final topKeywords = localStorage.getTopKeywords(limit: 10);
    final contradictions = localStorage.getContradictions();

    return Column(
      children: [
        // Estadísticas de Distorsión
        _buildDistortionCard(cs, distortionStats),
        const SizedBox(height: 16),
        
        // Top Keywords
        _buildKeywordsCard(cs, topKeywords),
        const SizedBox(height: 16),
        
        // Contradicciones Recientes
        _buildContradictionsCard(cs, contradictions),
      ],
    );
  }

  Widget _buildDistortionCard(ColorScheme cs, Map<String, dynamic> stats) {
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
              Icon(Icons.report_problem, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Análisis de Distorsión',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                cs,
                '${stats['conDistorsion']}',
                'Con Distorsión',
                Colors.red,
              ),
              _buildStatItem(
                cs,
                '${stats['sinDistorsion']}',
                'Sin Distorsión',
                Colors.green,
              ),
              _buildStatItem(
                cs,
                '${stats['porcentajeDistorsion']}%',
                'Porcentaje',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordsCard(ColorScheme cs, Map<String, int> keywords) {
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
              Icon(Icons.label, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Keywords Más Frecuentes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (keywords.isEmpty)
            Center(
              child: Text(
                'Sin keywords detectados',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keywords.entries.map((entry) {
                return Chip(
                  label: Text(
                    '${entry.key} (${entry.value})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: cs.primaryContainer,
                  labelStyle: TextStyle(color: cs.onPrimaryContainer),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildContradictionsCard(
    ColorScheme cs,
    List<Map<String, dynamic>> contradictions,
  ) {
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
              Icon(Icons.compare_arrows, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Contradicciones Detectadas',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (contradictions.isEmpty)
            Center(
              child: Text(
                'Sin contradicciones detectadas',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            )
          else
            ...contradictions.take(5).map((item) {
              final contradiccion = item['contradiccion'] as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contradiccion['claim_extraido'] ?? 'Sin claim',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tipo: ${contradiccion['tipo_distorsion'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildStatItem(ColorScheme cs, String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}