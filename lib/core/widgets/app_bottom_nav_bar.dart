import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/language/language_cubit.dart';
import '../theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex; // 0 Home, 1 Library, 2 Profile
  final ValueChanged<int> onTabSelected;
  final VoidCallback onScanTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.accent : AppColors.primary;
    final inactiveColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    Widget item(IconData icon, String label, int index, {VoidCallback? onTap}) {
      final selected = index == currentIndex;
      return Expanded(
        child: InkWell(
          onTap: onTap ?? () => onTabSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 22, color: selected ? activeColor : inactiveColor),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                item(Icons.home_rounded, isAr ? 'الرئيسية' : 'Home', 0),
                item(Icons.camera_alt_rounded, isAr ? 'فحص' : 'Scan', -1, onTap: onScanTap),
                item(Icons.menu_book_rounded, isAr ? 'المكتبة' : 'Library', 1),
                item(Icons.person_rounded, isAr ? 'الملف الشخصي' : 'Profile', 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
