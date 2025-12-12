import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bias_detect/core/router/app_routes.dart';
import 'package:bias_detect/core/theme/theme_provider.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = context.read<LoginProvider>().user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 16),
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: colorScheme.primary.withOpacity(0.15),
                  child: Icon(Icons.person, size: 50, color: colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'Usuario',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'email@ejemplo.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                        const SizedBox(width: 12),
                        Text(isDark ? 'Modo Oscuro' : 'Modo Claro'),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            child: ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () => _handleLogout(context),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pop();
    context.read<LoginProvider>().logout().then((_) {
      if (context.mounted) {
        context.go(AppRoutes.loginPath);
      }
    }).catchError((_) {
      if (context.mounted) {
        context.go(AppRoutes.loginPath);
      }
    });
  }
}