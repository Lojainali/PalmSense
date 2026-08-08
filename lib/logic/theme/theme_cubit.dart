import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

/// Drives the app-wide light / dark / system theme, wired to the
/// "Dark Mode" row on the Profile screen.
class ThemeCubit extends Cubit<AppThemeState> {
  ThemeCubit() : super(const AppThemeState());

  void setThemeMode(ThemeMode mode) => emit(AppThemeState(themeMode: mode));

  void toggle() {
    final next = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(AppThemeState(themeMode: next));
  }
}
