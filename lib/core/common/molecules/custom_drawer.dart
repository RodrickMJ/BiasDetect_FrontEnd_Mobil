import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bias_detect/core/router/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(

      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 16.0),
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                label: const Text('Back'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                  child: Icon(Icons.person, size: 30, color: colorScheme.onSurface.withOpacity(0.5)),
                ),
                const SizedBox(height: 8),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Email: Roi',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Botones de navegación
          _DrawerItem(
            title: 'Input button',
            icon: Icons.input,
            onTap: () {},
          ),
          _DrawerItem(
            title: 'Input button',
            icon: Icons.input,
            onTap: () {},
          ),
          _DrawerItem(
            title: 'Input button',
            icon: Icons.input,
            onTap: () {},
          ),
          const Divider(),
          _DrawerItem(
            title: 'About us',
            icon: Icons.info_outline,
            onTap: () {},
          ),
          _DrawerItem(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () {

              Navigator.pop(context);
            },
          ),
          _DrawerItem(
            title: 'Help and Support',
            icon: Icons.help_outline,
            onTap: () {},
          ),
          const Divider(),

          _DrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            color: colorScheme.error,
            onTap: () {

              context.go(AppRoutes.loginPath);
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? Theme.of(context).colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(
        title,
        style: TextStyle(color: itemColor),
      ),
      onTap: onTap,
    );
  }
}
