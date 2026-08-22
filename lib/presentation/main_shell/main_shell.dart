import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../logic/main_nav/main_nav_cubit.dart';
import '../dashboard/dashboard_screen.dart';
import '../library/library_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavCubit, int>(
      builder: (context, index) {
        return Scaffold(
          body: IndexedStack(
            index: index,
            children: const [
              DashboardScreen(),
              LibraryScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: index,
            onTabSelected: (i) => context.read<MainNavCubit>().setIndex(i),
            onScanTap: () => Navigator.of(context).pushNamed(AppRoutes.camera),
          ),
        );
      },
    );
  }
}
