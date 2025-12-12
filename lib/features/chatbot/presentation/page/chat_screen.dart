import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/organisms/chat_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select<LoginProvider, String?>((p) => p.user?.id) ?? "";

    return Scaffold(
      body: SafeArea(
        child: ChatView(userId: userId),
      ),
    );
  }
}