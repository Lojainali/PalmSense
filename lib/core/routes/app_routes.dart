import 'package:flutter/material.dart';
import '../../data/models/disease_model.dart';
import '../../data/models/scan_model.dart';
import '../../presentation/auth/forgot_password_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/signup_screen.dart';
import '../../presentation/library/disease_detail_screen.dart';
import '../../presentation/main_shell/main_shell.dart';
import '../../presentation/profile/dark_mode_screen.dart';
import '../../presentation/profile/edit_profile_screen.dart';
import '../../presentation/profile/export_reports_screen.dart';
import '../../presentation/profile/farm_details_screen.dart';
import '../../presentation/profile/language_screen.dart';
import '../../presentation/profile/notification_preferences_screen.dart';
import '../../presentation/profile/scan_history_screen.dart';
import '../../presentation/scan/camera_screen.dart';
import '../../presentation/scan/results_screen.dart';
import 'app_router.dart';
import 'app_routes.dart';

/// Single source of truth for screen-to-screen navigation. Every route name
/// in [AppRoutes] is mapped here, and this is the only place that decides
/// which widget a name resolves to — see each screen's file header comment
/// for a plain-English description of *why* it navigates where it does.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen(), settings: settings);

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
            builder: (_) => const ForgotPasswordScreen(), settings: settings);

      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const MainShell(), settings: settings);

      case AppRoutes.camera:
        return MaterialPageRoute(builder: (_) => const CameraScreen(), settings: settings);

      case AppRoutes.results:
        final scan = settings.arguments as ScanModel;
        return MaterialPageRoute(builder: (_) => ResultsScreen(scan: scan), settings: settings);

      case AppRoutes.diseaseDetail:
        final disease = settings.arguments as DiseaseModel;
        return MaterialPageRoute(
            builder: (_) => DiseaseDetailScreen(disease: disease), settings: settings);

      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen(), settings: settings);

      case AppRoutes.farmDetails:
        return MaterialPageRoute(builder: (_) => const FarmDetailsScreen(), settings: settings);

      case AppRoutes.notificationPreferences:
        return MaterialPageRoute(
            builder: (_) => const NotificationPreferencesScreen(), settings: settings);

      case AppRoutes.scanHistory:
        return MaterialPageRoute(builder: (_) => const ScanHistoryScreen(), settings: settings);

      case AppRoutes.exportReports:
        return MaterialPageRoute(
            builder: (_) => const ExportReportsScreen(), settings: settings);


      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen(), settings: settings);

      case AppRoutes.darkMode:
        return MaterialPageRoute(builder: (_) => const DarkModeScreen(), settings: settings);


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
