import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/home/view/home_page.dart';
import 'features/login/view/login_page.dart';
import 'features/video/view/video_page.dart';

/// A ChangeNotifier that listens to a Stream and notifies listeners on each event.
/// Replacement for the removed GoRouterRefreshStream helper.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    // immediately notify so GoRouter reads initial auth state
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

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
                // use matchedLocation instead of the removed subloc
                final loggingIn = state.matchedLocation == '/login';

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
