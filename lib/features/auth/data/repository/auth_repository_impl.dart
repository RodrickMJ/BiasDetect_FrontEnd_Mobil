import 'package:bias_detect/features/auth/data/datasource/service_auth.dart';
import 'package:bias_detect/features/auth/domain/entities/User.dart';
import 'package:bias_detect/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final ServiceAuth service;

  AuthRepositoryImpl(this.service);

  @override
  Future<User> login(String email, String password) {
    return service.login(email, password);
  }

  @override
  Future<User> register(String name, String email, String password) {
    return service.register(name, email, password);
  }

}