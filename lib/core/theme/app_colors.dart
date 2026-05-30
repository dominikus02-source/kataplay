import 'package:flutter/material.dart';

/// KataPlay Color Palette - Premium Kids Design
/// Primary: Emerald Green (trust, growth, nature)
/// Secondary: Warm Orange (energy, fun)
/// Accent: Sunny Yellow (joy, achievement)
/// Background: Warm Cream (soft, inviting)
class AppColors {
  AppColors._();

  // === PRIMARY COLORS ===
  static const Color primary = Color(0xFF0B7A5C);        // Emerald Green
  static const Color primaryLight = Color(0xFF149F7A);
  static const Color primaryDark = Color(0xFF065C45);

  // === SECONDARY COLORS ===
  static const Color secondary = Color(0xFFFF9E3D);      // Warm Orange
  static const Color secondaryLight = Color(0xFFFFB66B);

  // === ACCENT COLORS ===
  static const Color accent = Color(0xFFFFD93D);         // Sunny Yellow
  static const Color accentLight = Color(0xFFFFE66D);

  // === BACKGROUND & SURFACE ===
  static const Color background = Color(0xFFFFF8EC);     // Warm Cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5EDE3);

  // === TEXT COLORS ===
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF2D2D2D);

  // === SEMANTIC COLORS ===
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);

  // === GAME SPECIFIC ===
  static const Color coinGold = Color(0xFFFFD700);
  static const Color streakOrange = Color(0xFFFF6B35);
  static const Color islandLocked = Color(0xFFBDBDBD);
  static const Color islandUnlocked = Color(0xFF0B7A5C);

  // === SOFT SHADOWS (for child-friendly cards) ===
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x26000000);
}
