import 'package:bias_detect/core/common/molecules/global_nav_bar.dart';
import 'package:bias_detect/core/common/molecules/custom_drawer.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.toString();

    if (location == AppRoutes.homePath && currentIndex != 0) {
      currentIndex = 0;
    }
    if (location == AppRoutes.chatPath && currentIndex != 1) {
      currentIndex = 1;
    }
    if (location == AppRoutes.historyPath && currentIndex != 2) {
      currentIndex = 2;
    }
    if (location == AppRoutes.performanceUserPath && currentIndex != 3) {
      currentIndex = 3;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      drawer: const CustomDrawer(),
      bottomNavigationBar: GlobalNavBar(currentIndex: currentIndex),
    );
  }
}
