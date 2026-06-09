import 'package:flutter/material.dart';

/// KataPlay Color Palette - Premium Kids Design v2
/// Matches reference design: Purple primary, pastel backgrounds, vibrant accents
/// Inspired by Duolingo/Lingokids premium kids app aesthetic
class AppColors {
  AppColors._();

  // === PRIMARY COLORS (Purple - main brand) ===
  static const Color primary = Color(0xFF8A4FFF);        // Vibrant Purple
  static const Color primaryLight = Color(0xFFA875FF);   // Light Purple
  static const Color primaryDark = Color(0xFF6B3FD4);    // Deep Purple
  static const Color primaryBg = Color(0xFFF3EDFF);      // Very light purple bg

  // === TEAL (Mascot/Home accent) ===
  static const Color teal = Color(0xFF0B7A5C);           // Teal Green (Zelby color)
  static const Color tealLight = Color(0xFF14A87C);      // Light Teal
  static const Color tealDark = Color(0xFF065C45);       // Dark Teal
  static const Color tealBg = Color(0xFFE8F8F2);         // Very light teal bg

  // === SECONDARY COLORS ===
  static const Color secondary = Color(0xFFFF9E3D);      // Warm Orange
  static const Color secondaryLight = Color(0xFFFFB66B); // Light Orange

  // === ACCENT COLORS ===
  static const Color accent = Color(0xFFFFD93D);         // Sunny Yellow
  static const Color accentLight = Color(0xFFFFE66D);    // Light Yellow

  // === PINK (Game screens, fun accents) ===
  static const Color pink = Color(0xFFFF69B4);           // Hot Pink
  static const Color pinkLight = Color(0xFFFFB6D9);      // Light Pink
  static const Color pinkBg = Color(0xFFFFEFF6);         // Very light pink bg

  // === BACKGROUND & SURFACE ===
  static const Color background = Color(0xFFFFF8EC);     // Warm Cream
  static const Color cream = Color(0xFFFFF8E7);          // Cream (settings bg)
  static const Color surface = Color(0xFFFFFFFF);        // White
  static const Color surfaceVariant = Color(0xFFF5EDE3); // Light variant

  // === TEXT COLORS ===
  static const Color textPrimary = Color(0xFF1A1A2E);    // Dark navy
  static const Color textSecondary = Color(0xFF5C5C5C);  // Medium gray
  static const Color textOnPrimary = Color(0xFFFFFFFF);  // White on primary
  static const Color textOnSecondary = Color(0xFF2D2D2D);// Dark on secondary

  // === SEMANTIC COLORS ===
  static const Color success = Color(0xFF4CAF50);        // Green
  static const Color successLight = Color(0xFFE8F5E9);   // Light green bg
  static const Color error = Color(0xFFE53935);          // Red
  static const Color errorLight = Color(0xFFFFEBEE);     // Light red bg
  static const Color warning = Color(0xFFFFA000);        // Amber

  // === GAME SPECIFIC ===
  static const Color coinGold = Color(0xFFFFD700);       // Gold
  static const Color streakOrange = Color(0xFFFF6B35);   // Orange fire
  static const Color islandLocked = Color(0xFFBDBDBD);   // Gray
  static const Color islandUnlocked = Color(0xFF8A4FFF); // Purple

  // === BUTTON COLORS (vibrant, from reference) ===
  static const Color buttonOrange = Color(0xFFFF8C42);   // Orange button
  static const Color buttonPurple = Color(0xFF9B59B6);   // Purple button
  static const Color buttonGreen = Color(0xFF4CAF50);    // Green button
  static const Color buttonBlue = Color(0xFF5B9BD5);     // Blue button
  static const Color buttonTeal = Color(0xFF0B7A5C);     // Teal button

  // === CARD COLORS (pastel backgrounds for game cards) ===
  static const Color cardTeal = Color(0xFF26C6DA);       // Teal card
  static const Color cardBlue = Color(0xFF5C6BC0);       // Blue card
  static const Color cardOrange = Color(0xFFFF7043);     // Orange card
  static const Color cardGreen = Color(0xFF66BB6A);      // Green card
  static const Color cardPurple = Color(0xFFAB47BC);     // Purple card

  // === BRIGHT iOS MODERN LEARNING THEME (Kids-friendly) ===
  static const Color learningBg = Color(0xFFF5F3FF);        // Soft lavender-white bg
  static const Color learningSurface = Color(0xFFFFFFFF);    // Pure white cards
  static const Color learningSurfaceLight = Color(0xFFF8F7FF); // Very light lavender surface
  static const Color learningBorder = Color(0xFFE5E3F5);    // Soft lavender border
  static const Color learningTextPrimary = Color(0xFF1C1E2D); // Deep navy text
  static const Color learningTextSecondary = Color(0xFF8B8FA3); // Medium gray text
  static const Color learningCorrect = Color(0xFF34C759);    // iOS green for correct
  static const Color learningWrong = Color(0xFFFF3B30);      // iOS red for wrong
  static const Color learningCombo = Color(0xFFFF9500);      // iOS orange for combo
  static const Color learningComboBg = Color(0xFFE8EAF6);    // Light bar bg
  static const Color learningCheckBtn = Color(0xFF8A4FFF);   // Brand purple PERIKSA btn
  static const Color learningCheckBtnDisabled = Color(0xFFD1D3DE); // Soft disabled
  static const Color learningTileSelected = Color(0xFF8A4FFF); // Purple border for selected
  static const Color learningTileBg = Color(0xFFFFFFFF);     // White tile background
  static const Color learningBubbleBg = Color(0xFFFFFFFF);   // White speech bubble
  static const Color learningFeedbackBg = Color(0xFFEAFBF0); // Light green feedback bg
  static const Color learningFeedbackWrongBg = Color(0xFFFFF0F0); // Light red feedback bg

  // === SOFT SHADOWS (child-friendly) ===
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x26000000);

  // === GRADIENT COLORS ===
  static const List<Color> rewardGradient = [
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF4CAF50), // Green
  ];
  static const List<Color> celebrationGradient = [
    Color(0xFFFFF176), // Light yellow
    Color(0xFFFFEE58), // Yellow
    Color(0xFFFFD93D), // Sunny yellow
  ];

  // === CONGRATS / CELEBRATION ===
  static const Color confettiPurple = Color(0xFF8A4FFF);
  static const Color confettiPink = Color(0xFFFF69B4);
  static const Color confettiBlue = Color(0xFF5C6BC0);
  static const Color confettiGreen = Color(0xFF66BB6A);
  static const Color confettiOrange = Color(0xFFFF9E3D);
  static const Color confettiYellow = Color(0xFFFFD93D);
}
