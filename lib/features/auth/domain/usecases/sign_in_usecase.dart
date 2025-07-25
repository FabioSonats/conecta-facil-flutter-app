import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  Future<UserEntity?> call(String email, String senha) {
    return repository.signIn(email, senha);
  }
} 