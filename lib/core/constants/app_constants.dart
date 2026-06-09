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

  // === WORLD MAP (Pulau Kata) - Matches reference design ===
  static const int totalIslands = 6;
  static const List<String> islandNames = [
    'Desa Huruf',       // Letter Village (TK A)
    'Kebun Kata',       // Word Garden (TK B)
    'Hutan Kalimat',    // Sentence Forest (SD 1)
    'Lembah Cerita',    // Story Valley (SD 2)
    'Gunung Bahasa',    // Language Mountain (SD 3)
    'Kota Pengetahuan', // Knowledge City (SD 4)
  ];
  static const List<String> islandLabels = [
    'TK A',
    'TK B',
    'SD 1',
    'SD 2',
    'SD 3',
    'SD 4',
  ];
}
