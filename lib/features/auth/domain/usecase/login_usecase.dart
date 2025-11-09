import 'package:bias_detect/features/auth/domain/entities/User.dart';
import 'package:bias_detect/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}