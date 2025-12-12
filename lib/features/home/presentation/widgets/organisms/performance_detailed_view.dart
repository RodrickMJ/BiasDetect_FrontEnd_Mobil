import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import '../molecules/top_biases_card.dart';
import '../molecules/bias_distribution_card.dart';
import '../molecules/recent_analyses_card.dart';

class PerformanceDetailedView extends StatelessWidget {
  final LocalStorageService localStorage;

  const PerformanceDetailedView({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TopBiasesCard(),
        SizedBox(height: 16),
        BiasDistributionCard(),
        SizedBox(height: 16),
        RecentAnalysesCard(),
      ],
    );
  }
}