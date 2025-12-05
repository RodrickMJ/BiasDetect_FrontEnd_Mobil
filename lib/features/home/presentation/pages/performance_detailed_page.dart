import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chatbot/data/datasource/local_storage_service.dart';
import '../widgets/components/bias_distribution_chart.dart';
import '../widgets/components/sentiment_analysis_card.dart';
import '../widgets/components/recent_analyses_list.dart';
import '../widgets/components/top_biases_card.dart';
import '../widgets/components/monthly_trends_chart.dart';

class PerformanceDetailedPage extends StatelessWidget {
  const PerformanceDetailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageService>();

    return Column(
      children: [
        BiasDistributionChart(localStorage: localStorage),
        const SizedBox(height: 16),
        TopBiasesCard(localStorage: localStorage),
        const SizedBox(height: 16),
        SentimentAnalysisCard(localStorage: localStorage),
        const SizedBox(height: 16),
        MonthlyTrendsChart(localStorage: localStorage),
        const SizedBox(height: 16),
        RecentAnalysesList(localStorage: localStorage),
      ],
    );
  }
}