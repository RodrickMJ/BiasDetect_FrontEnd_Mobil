import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bias_detect/features/auth/domain/entities/User.dart';
import 'package:bias_detect/features/auth/domain/usecase/login_usecase.dart';

class LoginProvider with ChangeNotifier {
  final LoginUsecase loginUseCase;

  LoginProvider({required this.loginUseCase});

  String email = "";
  String password = "";

  String? emailError;
  String? passwordError;

  bool isLoading = false;

  User? _user;
  String? _authError;

  User? get user => _user;
  String? get authError => _authError;


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

  Future<void> submit() async {
    if (!_validate()) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      _user = await loginUseCase(email, password);
      _authError = null;
    } catch (e) {
      _authError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
      debugPrint("wazaaaaaa");
    }
  }



  void logout() {
    _user = null;
    notifyListeners();
  }
}
