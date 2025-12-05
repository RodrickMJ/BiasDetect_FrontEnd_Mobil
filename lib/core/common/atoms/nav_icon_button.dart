// lib/core/common/atoms/nav_icon_button.dart
import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final int index;
  final bool isActive;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.index,
    required this.isActive,
    required this.icon,
    required this.activeIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? cs.primary.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          size: 28,
          color: isActive ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}