import 'package:bias_detect/features/auth/domain/usecase/register_usecase.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  final RegisterUsecase registerUsecase;

  RegisterProvider({required this.registerUsecase});

  // Campos
  String _name = "";
  String _email = "";
  String _password = "";

  // Errores
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  // Loading
  bool _loading = false;

  // Getters
  String get name => _name;
  String get email => _email;
  String get password => _password;

  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  bool get isLoading => _loading;

  // setters
  void setName(String value) {
    _name = value;
    _nameError = null;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _emailError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = null;
    notifyListeners();
  }

  // Registrar
  Future<void> submit() async {
    if (_name.isEmpty) _nameError = "El nombre es requerido";
    if (_email.isEmpty) _emailError = "El correo es requerido";
    if (_password.isEmpty) _passwordError = "La contraseña es requerida";

    if (_nameError != null || _emailError != null || _passwordError != null) {
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      await registerUsecase(_name, _email, _password);
    } catch (e) {
      _emailError = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

