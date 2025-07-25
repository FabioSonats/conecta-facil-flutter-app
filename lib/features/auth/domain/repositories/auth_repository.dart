import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signIn(String email, String senha);
  Future<UserEntity?> signUp(UserEntity user, String senha);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
} 