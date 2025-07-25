import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity?> call(UserEntity user, String senha) {
    return repository.signUp(user, senha);
  }
} 