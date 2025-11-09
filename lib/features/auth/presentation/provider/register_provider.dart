import 'package:bias_detect/features/auth/domain/usecase/register_usecase.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  final RegisterUsecase registerUsecase;

  RegisterProvider({required this.registerUsecase});


  String _name = "";
  String _email = "";
  String _password = "";
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  bool _loading = false;
  bool _success = false;

  String get name => _name;
  String get email => _email;
  String get password => _password;

  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;


  bool get isLoading => _loading;
  bool get success => _success;

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
    debugPrint("Intentando registrar...");


    try {
      await registerUsecase(_name, _email, _password);

      _success = true;
      debugPrint("Registro exitoso");
    } catch (e) {
      _emailError = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
      debugPrint("wazaaaaaa");
    }
  }
}

