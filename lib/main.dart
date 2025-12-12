import 'package:bias_detect/core/theme/theme_provider.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'package:bias_detect/core/di/injections.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/auth/presentation/provider/register_provider.dart';
import 'package:bias_detect/features/chatbot/presentation/provider/chat_provider.dart';

import 'package:bias_detect/features/chatbot/data/datasource/fcm_token_service.dart';
import 'package:bias_detect/features/chatbot/data/datasource/fcm_notification_handler.dart';
import 'package:bias_detect/myapp.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

late FcmTokenService fcmTokenService;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseMessagingBackgroundHandler(message);
}

Future<void> initFcm() async {
  final messaging = FirebaseMessaging.instance;
  
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  
  final token = await messaging.getToken();
  if (token != null) {
    await fcmTokenService.updateToken(token);
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    fcmTokenService.updateToken(newToken);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  fcmTokenService = FcmTokenService();

  await initFcm();

  await configureDependecies();

  runApp(
    provider.MultiProvider(
      providers: [
        provider.Provider<FcmTokenService>.value(
          value: fcmTokenService,
        ),
        provider.Provider<LocalStorageService>.value(
          value: getIt<LocalStorageService>(),
        ),
        provider.ChangeNotifierProvider(
          create: (_) => getIt<LoginProvider>(),
        ),
        provider.ChangeNotifierProvider(
          create: (_) => getIt<RegisterProvider>(),
        ),
        provider.ChangeNotifierProvider(
          create: (_) => getIt<ChatProvider>(),
        ),
        provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const ProviderScope(child: Myapp()),
    ),
  );
}