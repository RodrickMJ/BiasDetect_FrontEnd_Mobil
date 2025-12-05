import 'package:flutter/material.dart';
import '../../../../chatbot/data/datasource/local_storage_service.dart';

class ProgressChartReal extends StatelessWidget {
  final LocalStorageService localStorage;

  const ProgressChartReal({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final weeklyData = localStorage.getWeeklyProgress();

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
              Icon(Icons.show_chart, color: cs.onSurfaceVariant, size: 20),
              const SizedBox(width: 8),
              Text(
                'Análisis Semanal',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                'Últimos 7 días',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: weeklyData.isEmpty
                ? Center(
                    child: Text(
                      'Sin datos aún',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  )
                : CustomPaint(
                    painter: RealLineChartPainter(
                      data: weeklyData,
                      color: cs.primary,
                    ),
                    size: const Size(double.infinity, 120),
                  ),
          ),
        ],
      ),
    );
  }
}

class RealLineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color color;

  RealLineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final maxCount = data.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b).toDouble();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final count = (data[i]['count'] as int).toDouble();
      final y = size.height - (count / (maxCount > 0 ? maxCount : 1)) * size.height * 0.8;
      points.add(Offset(x, y));
    }

    final path = Path();
    final fillPath = Path();

    fillPath.moveTo(0, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final midX = (points[i - 1].dx + points[i].dx) / 2;
      final midY = (points[i - 1].dy + points[i].dy) / 2;
      path.quadraticBezierTo(points[i - 1].dx, points[i - 1].dy, midX, midY);
      fillPath.lineTo(midX, midY);
    }

    fillPath.lineTo(points.last.dx, points.last.dy);
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}