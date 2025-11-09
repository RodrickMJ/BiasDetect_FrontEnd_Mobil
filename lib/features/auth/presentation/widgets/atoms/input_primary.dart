import 'package:flutter/material.dart';

class InputPrimary extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;
  final String? errorText;
  final ValueChanged<String> onChanged;

  //estilos
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? labelColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const InputPrimary({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.isPassword = false,
    this.width,
    this.height,
    this.borderColor,
    this.labelColor,
    this.fontSize,
    this.padding,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    final effectiveBorderColor = hasError
        ? Colors.red
        : borderColor ?? Colors.grey;

    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        height: height,
        child: TextField(
          obscureText: isPassword,
          onChanged: onChanged,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: labelColor),
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: effectiveBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: hasError ? Colors.red : (borderColor ?? Colors.blue),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
