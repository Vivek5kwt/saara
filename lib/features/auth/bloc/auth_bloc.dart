import 'dart:async';

import 'package:bloc/bloc.dart';

import '../models/user.dart';
import '../repository/auth_repository.dart';

sealed class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  AuthUserChanged(this.user);
  final User? user;
}

class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested(this.email, this.password);
  final String email;
  final String password;
}

class AuthGoogleLoginRequested extends AuthEvent {}

class AuthFacebookLoginRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

enum AuthStatus { authenticated, unauthenticated }

class AuthState {
  const AuthState._({required this.status, this.user, this.error});

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated({String? error})
      : this._(status: AuthStatus.unauthenticated, error: error);

  final AuthStatus status;
  final User? user;
  final String? error;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState.unauthenticated()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthFacebookLoginRequested>(_onFacebookLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    _subscription = _repository.stream.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<User?> _subscription;

  Future<void> _onUserChanged(
      AuthUserChanged event, Emitter<AuthState> emit) async {
    final user = event.user;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    // Temporary bypass: immediately authenticate without checking credentials
    emit(AuthState.authenticated(User(email: event.email)));
  }

  Future<void> _onGoogleLoginRequested(
      AuthGoogleLoginRequested event, Emitter<AuthState> emit) async {
    // Temporary bypass: treat Google sign-in as a success
    emit(AuthState.authenticated(
        const User(email: 'google@example.com', name: 'Google User')));
  }

  Future<void> _onFacebookLoginRequested(
      AuthFacebookLoginRequested event, Emitter<AuthState> emit) async {
    await _repository.logInWithFacebook();
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logOut();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _repository.dispose();
    return super.close();
  }
}