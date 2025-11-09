import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  //estilos 
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final bool isLoading;
  final FontWeight fontWeight;
  final double fontSize;

  const ButtonPrimary({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 48,
    this.color,
    this.textColor,
    this.borderRadius = 12,
    this.isLoading = false,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).primaryColor ;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, style: ElevatedButton.styleFrom(
        backgroundColor: isLoading ? Colors.grey : buttonColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )
      ),
      child: isLoading
          ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Text( 
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: fontWeight,
            fontSize: fontSize
          ),
          )
      ),
    );
  }
}