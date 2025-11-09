import 'package:bias_detect/features/auth/domain/entities/User.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
}