import 'dart:async';

import 'package:dio/dio.dart';

import '../models/user.dart';

class AuthRepository {
  AuthRepository({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  final _controller = StreamController<User?>.broadcast();
  User? _currentUser;

  Stream<User?> get stream => _controller.stream;
  User? get currentUser => _currentUser;

  Future<void> logIn({required String email, required String password}) async {
    // Placeholder for API call using Dio
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _currentUser = User(email: email, isMember: true);
    _controller.add(_currentUser);
  }

  Future<void> logOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() => _controller.close();
}

