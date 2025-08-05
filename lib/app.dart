import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/home/view/home_page.dart';
import 'features/login/view/login_page.dart';
import 'features/video/view/video_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AuthBloc(authRepository),
        child: Builder(
          builder: (context) {
            final authBloc = context.read<AuthBloc>();
            final router = GoRouter(
              refreshListenable: GoRouterRefreshStream(authBloc.stream),
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomePage(),
                ),
                GoRoute(
                  path: '/login',
                  builder: (context, state) => const LoginPage(),
                ),
                GoRoute(
                  path: '/video',
                  builder: (context, state) => const VideoPage(),
                ),
              ],
              redirect: (context, state) {
                final loggedIn =
                    authBloc.state.status == AuthStatus.authenticated;
                final loggingIn = state.subloc == '/login';

                if (!loggedIn) return loggingIn ? null : '/login';
                if (loggingIn) return '/';
                return null;
              },
            );

            return MaterialApp.router(
              title: 'Yoga App',
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}

