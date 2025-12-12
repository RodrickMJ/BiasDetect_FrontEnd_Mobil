import 'package:bias_detect/core/router/app_router.dart';
import 'package:bias_detect/core/theme/app_theme.dart';
import 'package:bias_detect/core/theme/theme_provider.dart'; // ← AÑADE ESTO
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final appRouter = AppRouter(loginProvider);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "Detector de Sesgos",
          theme: AppTheme.light(null),
          darkTheme: AppTheme.dark(null),
          themeMode: themeProvider.themeMode, 
          routerConfig: appRouter.router,
        );
      },
    );
  }
}