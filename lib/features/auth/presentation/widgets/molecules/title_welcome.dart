import 'package:bias_detect/features/auth/presentation/widgets/atoms/text_primary.dart';
import 'package:flutter/material.dart';

class TitleWelcome extends StatelessWidget {
  final String title;
  final String subtitle;

  final double? spacing;
  final double? titleSize;
  final double? subtitleSize;
  final FontWeight? titleWeight;
  final FontWeight? subtitleWeight;

  const TitleWelcome({
    super.key,
    required this.title,
    required this.subtitle,
    this.spacing,
    this.titleSize,
    this.subtitleSize,
    this.titleWeight,
    this.subtitleWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextPrimary(
          title,
          fontSize: titleSize ?? 46,
          fontWeight: titleWeight ?? FontWeight.bold,
          color: Colors.white,
        ),
        SizedBox(height: spacing ?? 6),
        TextPrimary(
          subtitle,
          fontSize: subtitleSize ?? 32,
          fontWeight: subtitleWeight ?? FontWeight.w400,
          color: Colors.white,
        ),
      ],
    );
  }
}
