import 'package:bias_detect/core/router/app_routes.dart';
import 'package:bias_detect/features/auth/presentation/pages/login_screen.dart';
import 'package:bias_detect/features/auth/presentation/pages/register_screen.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final LoginProvider loginProvider;
  AppRouter(this.loginProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.loginPath, 
    refreshListenable: loginProvider,
    routes: [
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}