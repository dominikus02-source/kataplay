/// App-wide constants (durations, sizes, limits)
class AppConstants {
  AppConstants._();

  // === ANIMATION DURATIONS ===
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);

  // === UI SIZES (Child-friendly) ===
  static const double buttonRadius = 28.0;
  static const double cardRadius = 24.0;
  static const double largeRadius = 32.0;

  static const double minTouchTarget = 56.0; // WCAG + kids friendly
  static const double iconSize = 28.0;

  // === GAME LIMITS ===
  static const int maxDailyQuests = 3;
  static const int coinsPerCorrectAnswer = 10;
  static const int xpPerCorrectAnswer = 15;

  // === STREAK ===
  static const int streakMilestone1 = 3;
  static const int streakMilestone2 = 7;
  static const int streakMilestone3 = 14;

  // === WORLD MAP (Pulau Kata) ===
  static const int totalIslands = 6;
  static const List<String> islandNames = [
    'Pulau Awal',
    'Pulau Hewan',
    'Pulau Warna',
    'Pulau Makanan',
    'Pulau Keluarga',
    'Pulau Petualangan',
  ];
}
