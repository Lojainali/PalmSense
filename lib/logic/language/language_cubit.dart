import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super('English');

  static const List<String> available = [
    'English',
    'العربية (Arabic)',
  ];

  void select(String language) => emit(language);

  static Locale localeFor(String language) =>
      language == 'العربية (Arabic)' ? const Locale('ar') : const Locale('en');

  static TextDirection directionFor(String language) =>
      language == 'العربية (Arabic)' ? TextDirection.rtl : TextDirection.ltr;
}
