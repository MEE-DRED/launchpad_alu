import 'package:flutter/material.dart';

/// Central colour palette for ALU Internship Connect.
///
/// Inspired by ALU's professional brand: a deep indigo primary with a warm
/// amber accent, tuned for a modern, minimal, accessible UI.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF1E3A8A); // deep indigo
  static const Color primaryLight = Color(0xFF3B5BDB);
  static const Color primaryDark = Color(0xFF152C6B);

  static const Color accent = Color(0xFFF59E0B); // amber
  static const Color accentDark = Color(0xFFD97706);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Dark theme neutrals
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
}
