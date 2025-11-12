import 'package:flutter/material.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressHeader(),
          SizedBox(height: 16),
          _ProgressChartPainterWidget(),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(Icons.show_chart, color: cs.onSurfaceVariant, size: 20),
        const SizedBox(width: 8),
        Text(
          'Progress',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: cs.onSurface),
        ),
        const Spacer(),
        Text(
          'Comparison by week',
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
      ],
    );
  }
}

class _ProgressChartPainterWidget extends StatelessWidget {
  const _ProgressChartPainterWidget();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 140,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: LineChartPainter(color: cs.primary),
              size: const Size(double.infinity, 120),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Color color;

  LineChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final fillPath = Path();

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.45, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.45),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width, size.height * 0.35),
    ];

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
