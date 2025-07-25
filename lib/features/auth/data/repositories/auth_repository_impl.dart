import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> signIn(String email, String senha) {
    return remoteDataSource.signIn(email, senha);
  }

  @override
  Future<UserEntity?> signUp(UserEntity user, String senha) {
    return remoteDataSource.signUp(UserModel.fromEntity(user), senha);
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}
