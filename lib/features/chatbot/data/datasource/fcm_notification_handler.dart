import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotificationHandler {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Function(String analysisId)? onAnalysisId;

  FcmNotificationHandler({this.onAnalysisId});

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _processAnalysisNotification(message);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _processAnalysisNotification(message);
  }

  void _processAnalysisNotification(RemoteMessage message) {
    try {
      final data = message.data;
      final type = data['type'] ?? '';

      if (type == 'success' || type == 'analysis_result') {
        onAnalysisId?.call('');
      } else if (type == 'error') {
        onAnalysisId?.call('ERROR');
      }
    } catch (e) {
      // Error silenciado intencionalmente (no hay canal de logging en producción)
    }
  }
}

/// Handler global para mensajes en background cuando la app está completamente cerrada
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}