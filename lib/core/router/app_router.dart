import 'package:bias_detect/core/common/organisms/main_layout.dart';
import 'package:bias_detect/core/router/app_routes.dart';
import 'package:bias_detect/features/auth/presentation/pages/login_screen.dart';
import 'package:bias_detect/features/auth/presentation/pages/register_screen.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/chatbot/presentation/page/chat_screen.dart';
import 'package:bias_detect/features/home/presentation/pages/performance_general_page.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  final LoginProvider loginProvider;
  AppRouter(this.loginProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.loginPath,
    refreshListenable: loginProvider,

    redirect: (context, state) {
      final logged = loginProvider.isLogged;
      final goingTo = state.uri.toString();

      final protectedRoutes = [AppRoutes.homePath, AppRoutes.chatPath];

      if (!logged && protectedRoutes.contains(goingTo)) {
        return AppRoutes.loginPath;
      }

      if (logged &&
          (goingTo == AppRoutes.loginPath ||
              goingTo == AppRoutes.registerPath)) {
        return AppRoutes.homePath;
      }

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
        ],
      ),
    ],
  );
}
