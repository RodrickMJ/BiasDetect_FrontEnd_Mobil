import 'package:bias_detect/features/auth/presentation/widgets/atoms/button_primary.dart';
import 'package:flutter/material.dart';

class AuthNav extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const AuthNav({
    super.key,
    required this.isLogin,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: ButtonPrimary(
              text: "Login",
              onPressed: onLogin,
              color: isLogin ? scheme.onPrimary : Colors.white,
              textColor: isLogin ? scheme.primary : const Color(0xFF6B7280),
            ),
          ),

          Expanded(
            child: ButtonPrimary(
              text: "Register",
              onPressed: onRegister,
              color: !isLogin ? scheme.onPrimary : Colors.white,
              textColor: !isLogin ? scheme.primary : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
