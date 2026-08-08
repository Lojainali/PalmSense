import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/language/language_cubit.dart';

/// Screen: Language (Profile -> App -> Language)
/// No further redirects — selecting a language updates LanguageCubit and pops back.
/// Provides its own LanguageCubit since it's the only screen that needs it.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Language')),
        body: BlocBuilder<LanguageCubit, String>(
          builder: (context, selected) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: LanguageCubit.available.map((lang) {
                return RadioListTile<String>(
                  value: lang,
                  groupValue: selected,
                  activeColor: AppColors.primary,
                  title: Text(lang),
                  onChanged: (v) {
                    if (v == null) return;
                    context.read<LanguageCubit>().select(v);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
