import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Spacing system
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // Border Radius
  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusFull = 100;

  // Sizes
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;

  static const double progressBarHeight = 10;

  // Bottom nav
  static const double bottomNavHeight = 78;
  static const double bottomNavMarginH = 20;
  static const double bottomNavRadius = 36;
  static const double bottomContentPadding = 120;

  static const double characterSizeLg = 120;
  static const double characterSizeMd = 80;
  static const double characterSizeSm = 64;
  static const double characterSizeXs = 48;

  // App shell
  static const double appMaxWidth = 520;
  static const double appOuterPadding = 16;

  // Durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Shadows
  static List<BoxShadow> cardShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.12),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> elevatedShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
