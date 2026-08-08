import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bottom navigation bar shown across the main shell (Home / Library /
/// Profile tabs). Tapping "Scan" doesn't switch a tab — [onScanTap]
/// pushes the full-screen camera flow instead, matching the recorded GUI.
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            item(Icons.home_rounded, 'Home', 0),
            item(Icons.camera_alt_rounded, 'Scan', -1, onTap: onScanTap),
            item(Icons.menu_book_rounded, 'Library', 1),
            item(Icons.person_rounded, 'Profile', 2),
          ],
        ),
      ),
    );
  }
}
