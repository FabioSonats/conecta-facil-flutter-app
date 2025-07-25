import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> signIn(String email, String senha);
  Future<UserModel?> signUp(UserModel user, String senha);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
} 