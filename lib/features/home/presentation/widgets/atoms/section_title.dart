import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.show_chart, color: Colors.black54, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        if (subtitle != null) ...[
          const Spacer(),
          Text(subtitle!, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ],
    );
  }
}