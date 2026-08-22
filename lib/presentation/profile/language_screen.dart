import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/language/language_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: BlocBuilder<LanguageCubit, String>(
        builder: (context, selected) {
          return RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) {
              if (v == null) return;
              // Updates the app-level LanguageCubit — MaterialApp picks
              // this up immediately and re-skins locale + direction.
              context.read<LanguageCubit>().select(v);
              Navigator.of(context).pop();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: LanguageCubit.available.map((lang) {
                return RadioListTile<String>(
                  value: lang,
                  activeColor: AppColors.primary,
                  title: Text(lang),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
