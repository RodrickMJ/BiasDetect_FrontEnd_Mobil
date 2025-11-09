import 'package:flutter/material.dart';

class TextPrimary extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextPrimary(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? scheme.onSurface,
      ),
    );
  }
}
