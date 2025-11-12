import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  final String leftText;
  final String rightText;
  final bool isLeftActive;

  const ToggleSwitch({
    super.key,
    required this.leftText,
    required this.rightText,
    this.isLeftActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, leftText, isLeftActive),
          _buildButton(context, rightText, !isLeftActive),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, bool isActive) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? cs.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? cs.onSurface : cs.onSurfaceVariant,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
