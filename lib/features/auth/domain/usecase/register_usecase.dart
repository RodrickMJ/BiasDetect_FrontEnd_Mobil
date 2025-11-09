import 'package:bias_detect/features/auth/domain/entities/User.dart';
import 'package:bias_detect/features/auth/domain/repository/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;
  RegisterUsecase(this.repository);

  Future<User> call(String name, String email, String password) {
    return repository.register(name, email, password);
  } 
  
}