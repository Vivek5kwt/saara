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
import 'features/onboarding/view/onboarding_page.dart';
import 'features/splash/view/splash_page.dart';
import 'features/forgot_password/view/forgot_password_page.dart';

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
  App({super.key});

  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

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
              initialLocation: '/splash',
              routes: [
                GoRoute(
                  path: '/splash',
                  builder: (context, state) => const SplashPage(),
                ),
                GoRoute(
                  path: '/onboarding',
                  builder: (context, state) => const OnboardingPage(),
                ),
                GoRoute(
                  path: '/login',
                  builder: (context, state) => const LoginPage(),
                ),
                GoRoute(
                  path: '/forgot-password',
                  builder: (context, state) => const ForgotPasswordPage(),
                ),
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomePage(),
                ),
                GoRoute(
                  path: '/video',
                  builder: (context, state) => const VideoPage(),
                ),
              ],
              redirect: (context, state) {
                final loggedIn =
                    authBloc.state.status == AuthStatus.authenticated;
                final loc = state.matchedLocation;
                final loggingIn = loc == '/login';
                final splash = loc == '/splash';
                final onboarding = loc == '/onboarding';
                final forgotPassword = loc == '/forgot-password';

                if (!loggedIn) {
                  if (loggingIn || splash || onboarding || forgotPassword) {
                    return null;
                  }
                  return '/login';
                }
                if (loggingIn || splash || onboarding || forgotPassword) {
                  return '/';
                }
                return null;
              },
            );

            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  final name = state.user?.name ?? state.user?.email ?? 'User';
                  _messengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Welcome $name')),
                  );
                  router.go('/');
                }
              },
              child: MaterialApp.router(
                title: 'Saara',
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                scaffoldMessengerKey: _messengerKey,
              ),
            );
          },
        ),
      ),
    );
  }
}
