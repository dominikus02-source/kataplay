import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Duolingo-inspired Universal Palette ──

  // Primary — vibrant green (progress, action, confidence)
  static const Color primary = Color(0xFF58CC02);
  static const Color primaryLight = Color(0xFF89E219);
  static const Color primaryDark = Color(0xFF46A302);
  static const Color primaryBg = Color(0xFFE8F9D0);

  // Secondary — sky blue (navigation, trust, learning)
  static const Color secondary = Color(0xFF1CB0F6);
  static const Color secondaryLight = Color(0xFF5EC8F9);
  static const Color secondaryBg = Color(0xFFD6F0FD);

  // Tertiary — warm coral (energy, fun)
  static const Color tertiary = Color(0xFFFF6B6B);
  static const Color tertiaryLight = Color(0xFFFF9494);
  static const Color tertiaryBg = Color(0xFFFFE8E8);

  // Answer option colors — each option gets a distinct hue (like Duolingo)
  static const Color optionA = Color(0xFF1CB0F6);  // Blue
  static const Color optionB = Color(0xFFFF6B6B);  // Coral/Red
  static const Color optionC = Color(0xFFCE82FF);  // Purple
  static const Color optionD = Color(0xFFFF9600);  // Orange

  static const List<Color> optionColors = [optionA, optionB, optionC, optionD];

  // Feedback
  static const Color correct = Color(0xFF58CC02);
  static const Color correctLight = Color(0xFFA8E86A);
  static const Color correctBg = Color(0xFFE8F9D0);
  static const Color wrong = Color(0xFFFF4B4B);
  static const Color wrongLight = Color(0xFFFF8A8A);
  static const Color wrongBg = Color(0xFFFFE8E8);

  // Reward — gold (streaks, XP, achievements)
  static const Color gold = Color(0xFFFFC800);
  static const Color goldLight = Color(0xFFFFD94D);
  static const Color goldDark = Color(0xFFDBA500);
  static const Color goldBg = Color(0xFFFFF5CC);

  // Background & Surface — clean white with warm accents
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldOuter = Color(0xFFF0F0F0);

  // Cards
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimary = Color(0xFF3A3A3A);
  static const Color textSecondary = Color(0xFF777777);
  static const Color textLight = Color(0xFFAFAFAF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Character colors (personalities preserved, palette updated)
  static const Color zelbyColor = Color(0xFFFF9600);
  static const Color zelbyBg = Color(0xFFFFF0D6);
  static const Color hazelColor = Color(0xFFFF6B9D);
  static const Color hazelBg = Color(0xFFFFE6F0);
  static const Color albyColor = Color(0xFFFFC800);
  static const Color albyBg = Color(0xFFFFF5CC);

  // Navigation icons
  static const Color iconHome = Color(0xFF1CB0F6);
  static const Color iconLearn = Color(0xFF58CC02);
  static const Color iconCollect = Color(0xFFFFC800);
  static const Color iconProfile = Color(0xFFCE82FF);
  static const Color iconXp = Color(0xFFFFC800);
  static const Color iconStreak = Color(0xFFFF9600);
  static const Color iconStar = Color(0xFFFFC800);
  static const Color iconCheck = Color(0xFF58CC02);
  static const Color iconLock = Color(0xFFB0B0B0);
  static const Color iconPlay = Color(0xFF58CC02);
  static const Color iconBadge = Color(0xFFCE82FF);
  static const Color iconReward = Color(0xFFFF9600);
  static const Color iconLevel = Color(0xFF1CB0F6);
  static const Color iconMission = Color(0xFF58CC02);

  // Level path colors
  static const List<Color> levelColors = [
    Color(0xFF58CC02),  // L1 — Green
    Color(0xFF1CB0F6),  // L2 — Blue
    Color(0xFFCE82FF),  // L3 — Purple
    Color(0xFFFF9600),  // L4 — Orange
    Color(0xFFFF6B6B),  // L5 — Coral
    Color(0xFF00C9A7),  // L6 — Teal
    Color(0xFF5C6BC0),  // L7 — Indigo
    Color(0xFFFF8A5C),  // L8 — Peach
  ];

  static const List<Color> levelBgColors = [
    Color(0xFFE8F9D0),  // L1
    Color(0xFFD6F0FD),  // L2
    Color(0xFFF0E6FF),  // L3
    Color(0xFFFFF0D6),  // L4
    Color(0xFFFFE8E8),  // L5
    Color(0xFFD6F9F0),  // L6
    Color(0xFFE8E8F6),  // L7
    Color(0xFFFFF0E6),  // L8
  ];

  static Color characterBg(String character) {
    switch (character.toLowerCase()) {
      case 'zelby': return zelbyBg;
      case 'hazel': return hazelBg;
      case 'alby': return albyBg;
      default: return zelbyBg;
    }
  }

  static Color characterColor(String character) {
    switch (character.toLowerCase()) {
      case 'zelby': return zelbyColor;
      case 'hazel': return hazelColor;
      case 'alby': return albyColor;
      default: return zelbyColor;
    }
  }
}
