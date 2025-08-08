import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authBloc = AuthBloc()..add(AuthCheckRequested());

        // Adiciona logger para debug
        authBloc.stream.listen((state) {
          debugPrint('AuthBloc State: ${state.runtimeType}');
          if (state is AuthAuthenticated) {
            debugPrint('Usuário autenticado: ${state.user.nome}');
          }
        });

        return authBloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Conecta Fácil',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Debug do estado atual
            debugPrint('Current Auth State: ${state.runtimeType}');

            // Se está carregando inicialmente, mostra loading
            if (state is AuthInitial) {
              debugPrint('Estado inicial - mostrando loading');
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Inicializando...'),
                    ],
                  ),
                ),
              );
            }

            // Se está carregando (verificando usuário), mostra loading
            if (state is AuthLoading) {
              debugPrint('Estado loading - verificando usuário');
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Verificando usuário...'),
                    ],
                  ),
                ),
              );
            }

            // Se está autenticado, vai para HomePage
            if (state is AuthAuthenticated) {
              debugPrint('Usuário autenticado - indo para HomePage');
              return const HomePage();
            }

            // Se não está autenticado, vai para LoginPage
            debugPrint('Usuário não autenticado - indo para LoginPage');
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
