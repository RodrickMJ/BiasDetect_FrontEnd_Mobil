import 'package:bias_detect/features/home/data/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/molecules/toggle_switch.dart';
import '../widgets/organisms/performance_general_view.dart';
import '../widgets/organisms/performance_detailed_view.dart';

class PerformanceGeneralPage extends StatefulWidget {
  const PerformanceGeneralPage({super.key});

  @override
  State<PerformanceGeneralPage> createState() => _PerformanceGeneralPageState();
}

class _PerformanceGeneralPageState extends State<PerformanceGeneralPage> {
  bool _isGeneralView = true;

  @override
  Widget build(BuildContext context) {
    final localStorage = context.watch<LocalStorageService>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: cs.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isGeneralView ? 'Performance General' : 'Performance Detallado',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isGeneralView = !_isGeneralView),
                      child: ToggleSwitch(
                        leftText: 'General',
                        rightText: 'Detallado',
                        isLeftActive: _isGeneralView,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isGeneralView)
                      PerformanceGeneralView(localStorage: localStorage)
                    else
                      PerformanceDetailedView(localStorage: localStorage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}