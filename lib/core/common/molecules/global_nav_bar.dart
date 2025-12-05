// lib/core/common/molecules/global_nav_bar.dart
import 'dart:ui';
import 'package:bias_detect/core/common/atoms/nav_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bias_detect/core/router/app_routes.dart';

class GlobalNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isUserDrawerOpen;

  const GlobalNavBar({
    super.key,
    required this.currentIndex,
    this.isUserDrawerOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surface.withOpacity(0.12)
                    : cs.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavButton(
                    index: 0,
                    isActive: currentIndex == 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    onTap: () => context.go(AppRoutes.homePath),
                  ),
                  NavButton(
                    index: 1,
                    isActive: currentIndex == 1,
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    onTap: () => context.go(AppRoutes.chatPath),
                  ),
                  NavButton(
                    index: 2,
                    isActive: currentIndex == 2,
                    icon: Icons.history_outlined,
                    activeIcon: Icons.history,
                    onTap: () => context.go(AppRoutes.historyPath),
                  ),
                  NavButton(
                    index: 3,
                    isActive: currentIndex == 3,
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    onTap: () => context.go(AppRoutes.performanceUserPath),
                  ),
                  // Botón de usuario → abre drawer (no navega)
                  NavButton(
                    index: 4,
                    isActive: isUserDrawerOpen, // Se activa solo cuando el drawer está abierto
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}