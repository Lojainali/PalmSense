import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/library/library_cubit.dart';
import 'logic/main_nav/main_nav_cubit.dart';
import 'logic/theme/theme_cubit.dart';
import 'logic/theme/theme_state.dart';

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
      ],
      child: BlocBuilder<ThemeCubit, AppThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'PalmSense',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
            initialRoute: AppRoutes.login,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
