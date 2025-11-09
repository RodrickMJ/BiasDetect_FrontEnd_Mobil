import 'package:flutter/material.dart';
import '../atoms/nav_icon_button.dart';

class GlobalNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlobalNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, -2),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavIconButton(
            icon: Icons.home,
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          NavIconButton(
            icon: Icons.auto_graph,
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          NavIconButton(
            icon: Icons.chat_bubble,
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          NavIconButton(
            icon: Icons.article,
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          NavIconButton(
            icon: Icons.person,
            isActive: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}
