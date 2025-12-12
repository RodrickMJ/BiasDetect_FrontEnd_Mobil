import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenService {
  static const String _tokenKey = 'fcm_token';
  String? _currentToken;

  Future<String?> getToken() async {
    if (_currentToken != null && _currentToken!.isNotEmpty) {
      return _currentToken;
    }

    final prefs = await SharedPreferences.getInstance();
    _currentToken = prefs.getString(_tokenKey);

    if (_currentToken != null && _currentToken!.isNotEmpty) {
      return _currentToken;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        _currentToken = token;
        await _saveToken(token);
      }
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      // Silenciado intencionalmente
    }
  }

  Future<void> updateToken(String newToken) async {
    _currentToken = newToken;
    await _saveToken(newToken);
  }

  Future<void> clearToken() async {
    _currentToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}