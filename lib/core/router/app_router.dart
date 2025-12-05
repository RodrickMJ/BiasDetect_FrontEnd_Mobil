import 'package:bias_detect/core/common/molecules/custom_drawer.dart';
import 'package:bias_detect/core/common/organisms/main_layout.dart';
import 'package:bias_detect/core/router/app_routes.dart';
import 'package:bias_detect/features/auth/presentation/pages/login_screen.dart';
import 'package:bias_detect/features/auth/presentation/pages/register_screen.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/chatbot/presentation/page/chat_screen.dart';
import 'package:bias_detect/features/chatbot/presentation/page/history_screen.dart';

import 'package:bias_detect/features/home/presentation/pages/performance_general_page.dart';
import 'package:bias_detect/features/home/presentation/pages/performance_user_page.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  final LoginProvider loginProvider;
  AppRouter(this.loginProvider);

  late final GoRouter router = GoRouter(
    // 🔥 Arranca directamente en Home
    initialLocation: AppRoutes.homePath,

    // 🔥 Ya no se usa para redirecciones de login
    refreshListenable: loginProvider,

    // 🔥 No hay redirecciones: el usuario puede entrar a cualquier ruta
    redirect: (context, state) {
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.loginPath,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        builder: (_, __) => const RegisterScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.homePath,
            builder: (_, __) => const PerformanceGeneralPage(),
          ),
          GoRoute(
            path: AppRoutes.chatPath,
            builder: (_, __) => const ChatPage(),
          ),
          GoRoute(
            path: AppRoutes.historyPath,
            builder: (_, __) => const HistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.performanceUserPath,
            builder: (_, __) => const PerformanceUserPage(),
          ),
          GoRoute(
            path: AppRoutes.userDetailsPath,
            builder: (_, __) => const CustomDrawer(),
          )
        ],
      ),
    ],
  );
}
