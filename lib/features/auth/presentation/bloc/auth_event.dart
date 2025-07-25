part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String senha;
  const AuthLoginRequested(this.email, this.senha);

  @override
  List<Object?> get props => [email, senha];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final UserEntity user;
  final String senha;
  const AuthSignUpRequested(this.user, this.senha);

  @override
  List<Object?> get props => [user, senha];
}

class AuthCheckRequested extends AuthEvent {}
