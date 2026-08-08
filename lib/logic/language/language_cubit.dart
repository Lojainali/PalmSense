import 'package:flutter_bloc/flutter_bloc.dart';

/// Backs the Language selection screen. Purely UI-level for now —
/// hook this up to a real localization delegate once the backend/i18n
/// setup is in place.
class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super('English');

  static const List<String> available = [
    'English',
    'العربية (Arabic)',
    'Français',
  ];

  void select(String language) => emit(language);
}
