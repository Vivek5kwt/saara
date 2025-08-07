import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

/// Controls the application's [ThemeMode].
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  /// Switch between light and dark themes.
  void toggle(bool isDark) => emit(isDark ? ThemeMode.dark : ThemeMode.light);
}
