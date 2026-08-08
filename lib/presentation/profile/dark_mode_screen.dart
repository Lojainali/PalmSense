import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../logic/theme/theme_state.dart';

/// Screen: Dark Mode (Profile -> App -> Dark Mode)
/// No further redirects — selecting an option updates ThemeCubit immediately,
/// re-skinning the entire app (including the "Midnight Green" dark palette).
class DarkModeScreen extends StatelessWidget {
  const DarkModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dark Mode')),
      body: BlocBuilder<ThemeCubit, AppThemeState>(
        builder: (context, state) {
          Widget option(String label, String subtitle, ThemeMode mode, IconData icon) {
            final selected = state.themeMode == mode;
            return RadioListTile<ThemeMode>(
              value: mode,
              groupValue: state.themeMode,
              activeColor: AppColors.primary,
              secondary: Icon(icon),
              title: Text(label),
              subtitle: Text(subtitle),
              selected: selected,
              onChanged: (v) {
                if (v == null) return;
                context.read<ThemeCubit>().setThemeMode(v);
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              option('Light', 'Fresh Palm Green theme', ThemeMode.light, Icons.light_mode_outlined),
              option('Dark', 'Midnight Green theme', ThemeMode.dark, Icons.dark_mode_outlined),
              option('System', 'Match your device setting', ThemeMode.system,
                  Icons.settings_suggest_outlined),
            ],
          );
        },
      ),
    );
  }
}
