import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  // Brand greens
  static const Color primaryDark = Color(0xFF1E5E38); // header gradient start
  static const Color primary = Color(0xFF2E7D4F); // buttons / active states
  static const Color primaryLight = Color(0xFF4CAF7D);
  static const Color accent = Color(0xFF3FBE71);

  // Severity colors
  static const Color critical = Color(0xFFE0453C);
  static const Color criticalBg = Color(0xFFFCE7E6);
  static const Color high = Color(0xFFE0453C);
  static const Color highBg = Color(0xFFFCE0E0);
  static const Color medium = Color(0xFFE0912B);
  static const Color mediumBg = Color(0xFFFCEEDA);
  static const Color low = Color(0xFF2E9E5B);
  static const Color lowBg = Color(0xFFE1F3E8);

  // Light theme neutrals
  static const Color lightBackground = Color(0xFFF3F6F4);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE1E7E3);
  static const Color textPrimaryLight = Color(0xFF16211B);
  static const Color textSecondaryLight = Color(0xFF6B7772);

  // Dark theme neutrals ("Midnight Green")
  static const Color darkBackground = Color(0xFF121A16);
  static const Color darkSurface = Color(0xFF1B241E);
  static const Color darkSurfaceAlt = Color(0xFF212B24);
  static const Color darkBorder = Color(0xFF2B362F);
  static const Color textPrimaryDark = Color(0xFFEAF2ED);
  static const Color textSecondaryDark = Color(0xFF9FB0A7);

  static Color severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return critical;
      case 'high':
        return high;
      case 'medium':
        return medium;
      case 'low':
        return low;
      default:
        return medium;
    }
  }

  static Color severityBg(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return criticalBg;
      case 'high':
        return highBg;
      case 'medium':
        return mediumBg;
      case 'low':
        return lowBg;
      default:
        return mediumBg;
    }
  }
}
