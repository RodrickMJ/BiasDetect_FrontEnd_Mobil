import 'package:bias_detect/core/di/injections.dart';
import 'package:bias_detect/core/router/app_router.dart';
import 'package:bias_detect/core/theme/app_theme.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:flutter/material.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  static final _loginProvider = getIt<LoginProvider>();
  static final _appRouter = AppRouter(_loginProvider);
  static final _router = _appRouter.router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Detector de Sesgos",

      theme: AppTheme.light(null),
      darkTheme: AppTheme.dark(null),
      themeMode: ThemeMode.system,

      routerConfig: _router,
    );
  }
}
