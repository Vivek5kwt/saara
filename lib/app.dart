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
import 'features/notifications/view/notification_page.dart';
import 'features/home/view/classes_page.dart';
import 'features/home/view/programs_page.dart';
import 'features/home/view/class_detail_page.dart';
import 'features/home/cubit/home_cubit.dart';
import 'package:video_player/video_player.dart';
import 'theme/cubit/theme_cubit.dart';

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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository)),
          BlocProvider(create: (_) => ThemeCubit()),
        ],
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
                  builder: (context, state) {
                    final data = state.extra as Map<String, String>?;
                    return VideoPage(
                      title: data?['title'],
                      url: data?['url'],
                    );
                  },
                ),
                GoRoute(
                  path: '/video/fullscreen',
                  builder: (context, state) {
                    final controller = state.extra as VideoPlayerController;
                    return FullScreenVideo(controller: controller);
                  },
                ),
                GoRoute(
                  path: '/notifications',
                  builder: (context, state) => const NotificationPage(),
                ),
                GoRoute(
                  path: '/classes',
                  builder: (context, state) {
                    final cubit = state.extra as HomeCubit?;
                    return cubit != null
                        ? BlocProvider.value(
                            value: cubit,
                            child: const ClassesPage(),
                          )
                        : BlocProvider(
                            create: (_) => HomeCubit(),
                            child: const ClassesPage(),
                          );
                  },
                ),
                GoRoute(
                  path: '/programs',
                  builder: (context, state) {
                    final cubit = state.extra as HomeCubit?;
                    return cubit != null
                        ? BlocProvider.value(
                            value: cubit,
                            child: const ProgramsPage(),
                          )
                        : BlocProvider(
                            create: (_) => HomeCubit(),
                            child: const ProgramsPage(),
                          );
                  },
                ),
                GoRoute(
                  path: '/class-detail',
                  builder: (context, state) {
                    final data = state.extra as Map<String, dynamic>;
                    return ClassDetailPage(
                      title: data['title'] as String,
                      image: data['image'] as String,
                      videoCount: data['videoCount'] as int,
                      description: data['description'] as String,
                    );
                  },
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

            final themeMode = context.watch<ThemeCubit>().state;

            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  router.go('/');
                } else if (state.error != null) {
                  _messengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text(state.error!)),
                  );
                }
              },
              child: MaterialApp.router(
                title: 'Saara',
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                scaffoldMessengerKey: _messengerKey,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFFA78BFA),
                  ),
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFFA78BFA),
                    brightness: Brightness.dark,
                  ),
                ),
                themeMode: themeMode,
              ),
            );
          },
        ),
      ),
    );
  }
}