import 'package:bias_detect/core/common/molecules/custom_drawer.dart';
import 'package:bias_detect/core/common/molecules/global_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bias_detect/core/router/app_routes.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  bool isUserDrawerOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.toString();

    int newIndex = 0;
    if (location.startsWith(AppRoutes.homePath)) {
      newIndex = 0;
    } else if (location.startsWith(AppRoutes.chatPath)) {
      newIndex = 1;
    } else if (location.startsWith(AppRoutes.historyPath)) {
      newIndex = 2;
    }

    if (currentIndex != newIndex) {
      setState(() => currentIndex = newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      endDrawer: const CustomDrawer(),
      onEndDrawerChanged: (isOpen) {
        setState(() => isUserDrawerOpen = isOpen);
      },
      bottomNavigationBar: GlobalNavBar(
        currentIndex: currentIndex,
        isUserDrawerOpen: isUserDrawerOpen,
      ),
    );
  }
}