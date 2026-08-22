import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/language/language_cubit.dart';
import 'logic/library/library_cubit.dart';
import 'logic/main_nav/main_nav_cubit.dart';
import 'logic/theme/theme_cubit.dart';
import 'logic/theme/theme_state.dart';

/// Root widget: wires up every app-wide Cubit and the named-route
/// navigator. Screen-scoped Cubits (ScanCubit, NotificationPrefsCubit)
/// are provided closer to where they're used instead of here.
class PalmSenseApp extends StatelessWidget {
  const PalmSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => MainNavCubit()),
        BlocProvider(create: (_) => LibraryCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, String>(
            builder: (context, language) {
              return MaterialApp(
                title: 'PalmSense',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.themeMode,
                initialRoute: AppRoutes.login,
                onGenerateRoute: AppRouter.onGenerateRoute,
                locale: LanguageCubit.localeFor(language),
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: (context, child) {
                  // Flips the whole app RTL/LTR immediately on selection.
                  // Screen text itself stays English until full Arabic
                  // translations are added (separate task) — this fixes
                  // the "Arabic just redirects, nothing happens" bug.
                  return Directionality(
                    textDirection: LanguageCubit.directionFor(language),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}