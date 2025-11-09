import 'package:flutter/material.dart';
import '../molecules/global_nav_bar.dart';
//import '../pages/home_view.dart';
//import '../pages/stats_view.dart';
//import '../pages/chat_view.dart';
//import '../pages/docs_view.dart';
//import '../pages/profile_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final pages = const [
    // HomeView(),
    // StatsView(),
    // ChatView(),
    //DocsView(),
    //ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: GlobalNavBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}
