import 'package:flutter/material.dart';
import '../molecules/toggle_switch.dart';
import '../molecules/user_metric_cards.dart';
import '../molecules/wellness_score_card.dart';
import '../components/progress_chart.dart';

class PerformanceUserView extends StatelessWidget {
  const PerformanceUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ToggleSwitch(
          leftText: 'General',
          rightText: '',
          isLeftActive: true,
        ),
        const SizedBox(height: 24),

        Text(
          "Today's Habit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        const UserMetricCards(),
        const SizedBox(height: 24),

        const WellnessScoreCard(),
        const SizedBox(height: 24),

        const ProgressChart(),
      ],
    );
  }
}