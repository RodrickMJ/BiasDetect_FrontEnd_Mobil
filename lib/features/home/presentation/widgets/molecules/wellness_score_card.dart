import 'package:flutter/material.dart';

class WellnessScoreCard extends StatelessWidget {
  const WellnessScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness score',
                  style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Distribución Sesgos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Good',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: 0.61,
                    strokeWidth: 5,
                    backgroundColor: cs.primary.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}