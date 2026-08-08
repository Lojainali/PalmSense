import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class AppThemeState extends Equatable {
  final ThemeMode themeMode;

  const AppThemeState({this.themeMode = ThemeMode.light});

  @override
  List<Object?> get props => [themeMode];
}
