import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/performance_provider.dart';
import '../widgets/molecules/metric_card.dart';
import '../widgets/components/progress_chart.dart';
import '../widgets/molecules/toggle_switch.dart';

class PerformanceUserPage extends ConsumerWidget {
  static const String routeName = '/performanceUser';

  const PerformanceUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final metrics = ref.watch(metricsProvider);
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

                  IconButton(
                    icon: Icon(Icons.menu, color: cs.onSurface),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),

                  const Expanded(
                    child: Text(
                      'Performance User',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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


                    Wrap(
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
                          icon: Icons.warning, // Icono simulado
                          color: Colors.red,
                        ),

                        MetricCard(
                          title: 'Tasa Polarización',
                          value: '68%',
                          icon: Icons.bar_chart,
                          color: Colors.orange,
                        ),
                        // Métrica 4: Confianza Media
                        MetricCard(
                          title: 'Confianza Media',
                          value: '91%',
                          icon: Icons.thumb_up,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),


                    Card(
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
                                Text('Wellness score', style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6))),
                                const SizedBox(height: 4),
                                Text('Distribución Sesgos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Good', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
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
                    ),
                    const SizedBox(height: 24),

                    // Sesgos por Día (simulado con ProgressChart)
                    const ProgressChart(),
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
