import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static TextStyle heading(BuildContext context, {double size = 22}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      height: 1.25,
    );
  }

  static TextStyle body(BuildContext context, {double size = 14}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      height: 1.4,
    );
  }

  static TextStyle caption(BuildContext context, {double size = 12}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      height: 1.3,
    );
  }

  static TextStyle label(BuildContext context, {double size = 12}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }
}
