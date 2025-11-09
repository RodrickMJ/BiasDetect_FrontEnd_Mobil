import 'package:bias_detect/features/auth/presentation/widgets/atoms/input_primary.dart';
import 'package:bias_detect/features/auth/presentation/widgets/atoms/text_primary.dart';
import 'package:flutter/material.dart';

class LabelForm extends StatelessWidget {
  final String label;
  final String value;
  final String? errorText;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  // Estilos
  final double? spacing;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? labelColor;

  const LabelForm({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.isPassword = false,
    this.spacing = 6,
    this.fontSize,
    this.fontWeight,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextPrimary(
          label,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w600,
          
        ),

        SizedBox(height: spacing),

        InputPrimary(
          label: label,
          value: value,
          onChanged: onChanged,
          isPassword: isPassword,
          errorText: errorText,
        ),
      ],
    );
  }
}
