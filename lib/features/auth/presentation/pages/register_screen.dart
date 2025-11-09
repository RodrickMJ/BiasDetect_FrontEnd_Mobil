import 'package:bias_detect/features/auth/presentation/provider/register_provider.dart';
import 'package:bias_detect/features/auth/presentation/widgets/components/form_register.dart';
import 'package:bias_detect/features/auth/presentation/widgets/molecules/auth_nav.dart';
import 'package:bias_detect/features/auth/presentation/widgets/molecules/title_welcome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      
      builder: (context, auth, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (auth.success) {
            context.go('/login');
          }
        });

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F1A3C)
              : const Color(0xFF2563EB),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TitleWelcome(
                  title: "Bienvenido",
                  subtitle: "Ingrese sus datos para el registro",
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 32,
                  ),

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
                        isLogin: false,
                        onLogin: () => context.go('/login'),
                        onRegister: () {},
                      ),

                      const SizedBox(height: 40),

                      Expanded(
                        child: SingleChildScrollView(
                          child: FormRegister(auth: auth),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
