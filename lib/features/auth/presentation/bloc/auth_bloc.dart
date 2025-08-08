import 'package:conecta_facil/app/di/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = sl<AuthRepository>();

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    print('AuthBloc: Iniciando verificação de usuário');
    emit(AuthLoading());
    try {
      // Adiciona timeout de 10 segundos para evitar loading infinito
      final user = await _authRepository.getCurrentUser().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('AuthBloc: Timeout ao verificar usuário atual');
          return null;
        },
      );

      if (user != null) {
        print('AuthBloc: Usuário encontrado - ${user.nome}');
        emit(AuthAuthenticated(user));
      } else {
        print('AuthBloc: Nenhum usuário encontrado');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('AuthBloc: Erro ao verificar usuário atual: $e');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    print('AuthBloc: Iniciando login para ${event.email}');
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(event.email, event.senha);
      if (user != null) {
        print('AuthBloc: Login bem-sucedido para ${user.nome}');
        emit(AuthAuthenticated(user));
      } else {
        print('AuthBloc: Login falhou - usuário ou senha inválidos');
        emit(const AuthError('Usuário ou senha inválidos'));
      }
    } catch (e) {
      print('AuthBloc: Erro no login: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    print('AuthBloc: Iniciando logout');
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      print('AuthBloc: Logout bem-sucedido');
      emit(AuthUnauthenticated());
    } catch (e) {
      print('AuthBloc: Erro no logout: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    print('AuthBloc: Iniciando cadastro para ${event.user.email}');
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(event.user, event.senha);
      if (user != null) {
        print('AuthBloc: Cadastro bem-sucedido para ${user.nome}');
        emit(AuthAuthenticated(user));
      } else {
        print('AuthBloc: Cadastro falhou');
        emit(const AuthError('Erro ao cadastrar usuário.'));
      }
    } catch (e) {
      print('AuthBloc: Erro no cadastro: $e');
      emit(AuthError(e.toString()));
    }
  }
}
