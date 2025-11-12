import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/auth/presentation/widgets/components/form_login.dart';
import 'package:bias_detect/features/auth/presentation/widgets/molecules/auth_nav.dart';
import 'package:bias_detect/features/auth/presentation/widgets/molecules/title_welcome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (_, auth, __) {
        if (auth.user != null) {
          // Guardar token e ID
          // Aquí puedes usar SharedPreferences
          // Pero por ahora solo navega
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
        }

        if (auth.authError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(auth.authError!),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return buildUI(context, auth);
      },
    );
  }

  Widget buildUI(BuildContext context, LoginProvider auth) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F1A3C)
          : const Color(0xFF2563EB),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TitleWelcome(title: "Hey!", subtitle: "Bienvenido de nuevo"),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1A3C) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border.all(
                  color: isDark ? Colors.white : Colors.black,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  AuthNav(
                    isLogin: true,
                    onLogin: () {},
                    onRegister: () => context.go('/register'),
                  ),
                  const SizedBox(height: 60),
                  Expanded(
                    child: SingleChildScrollView(
                      child: FormLogin(auth: auth),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
