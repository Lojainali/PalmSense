import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';


class ThemeCubit extends Cubit<AppThemeState> {
  ThemeCubit() : super(const AppThemeState());

  void setThemeMode(ThemeMode mode) => emit(AppThemeState(themeMode: mode));

  void toggle() {
    final next = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(AppThemeState(themeMode: next));
  }
}
