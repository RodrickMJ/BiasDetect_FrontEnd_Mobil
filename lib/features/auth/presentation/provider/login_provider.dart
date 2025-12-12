import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bias_detect/features/auth/domain/entities/User.dart';
import 'package:bias_detect/features/auth/domain/usecase/login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final LoginUsecase loginUseCase;

  LoginProvider({required this.loginUseCase}) {
    _loadSession();
  }

  User? _user;
  bool isLoading = false;
  String? _authError;
  bool _isInitialized = false; // NUEVO: Para saber si ya cargó la sesión

  User? get user => _user;
  String? get authError => _authError;
  bool get isLogged => _user != null;
  bool get isInitialized => _isInitialized; // NUEVO

  String email = "";
  String password = "";
  String? emailError;
  String? passwordError;

  // Cargar sesión guardada al iniciar la app
  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final id = prefs.getString("userId");
    final email = prefs.getString("email");
    final name = prefs.getString("name");

    if (token != null && id != null) {
      _user = User(
        id: id,
        name: name ?? "",
        email: email ?? "",
        token: token,
      );
    }
    
    _isInitialized = true; // NUEVO: Marcamos como inicializado
    notifyListeners();
  }

  // Guardar sesión
  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", user.token);
    await prefs.setString("userId", user.id);
    await prefs.setString("email", user.email);
    await prefs.setString("name", user.name);
  }

  Future<void> submit() async {
    if (!_validate()) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final u = await loginUseCase(email, password);
      _user = u;
      _authError = null;

      await _saveSession(u);
    } catch (e) {
      _authError = "Credenciales incorrectas";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Logout CORREGIDO - Limpia TODO
  Future<void> logout() async {
    try {
      // Limpiar el usuario primero
      _user = null;
      
      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // O usa remove para claves específicas
      
      // También puedes limpiar los campos de email y password si quieres
      email = "";
      password = "";
      emailError = null;
      passwordError = null;
      _authError = null;
      
      // Notificar a los listeners
      notifyListeners();
      
      debugPrint("✅ Logout exitoso - Usuario: null, SharedPreferences limpiado");
    } catch (e) {
      debugPrint("❌ Error en logout: $e");
      // Aún así, intenta limpiar el usuario
      _user = null;
      notifyListeners();
    }
  }

  // Validaciones
  bool _validate() {
    bool ok = true;

    if (!email.contains("@")) {
      emailError = "Correo inválido.";
      ok = false;
    }

    if (password.length < 6) {
      passwordError = "La contraseña es muy corta.";
      ok = false;
    }

    return ok;
  }

  void setEmail(String value) {
    email = value;
    emailError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    passwordError = null;
    notifyListeners();
  }
}