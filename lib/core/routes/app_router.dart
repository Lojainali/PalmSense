/// Central registry of route names used with Navigator's named routes,
/// so every screen-to-screen redirect is explicit and easy to trace.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  static const String mainShell = '/main'; // hosts Home / Library / Profile tabs

  static const String camera = '/camera';
  static const String results = '/results';

  static const String diseaseDetail = '/library/disease-detail';

  static const String editProfile = '/profile/edit';
  static const String farmDetails = '/profile/farm-details';
  static const String notificationPreferences = '/profile/notifications';
  static const String scanHistory = '/profile/scan-history';
  static const String exportReports = '/profile/export-reports';
  static const String aiModelVersion = '/profile/ai-model-version';
  static const String language = '/profile/language';
  static const String darkMode = '/profile/dark-mode';
  static const String helpSupport = '/profile/help-support';
}
