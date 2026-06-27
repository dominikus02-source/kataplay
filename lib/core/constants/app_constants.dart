class AppConstants {
  AppConstants._();

  static const String appName = 'KataPlay';
  static const String appVersion = '2.0.0';

  static const String zelby = 'Zelby';
  static const String hazel = 'Hazel';
  static const String alby = 'Alby';

  static const double borderRadius = 20;
  static const double borderRadiusSmall = 12;
  static const double borderRadiusLarge = 28;

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration feedbackDuration = Duration(milliseconds: 600);

  static const int maxOnboardingSlides = 3;
  static const int maxLevels = 8;
  static const int xpPerQuestion = 10;
  static const int xpPerLesson = 50;
  static const int xpPerLevel = 200;
  static const int streakBonus = 25;
  static const int totalQuestionsPerSession = 5;

  static const int xpBadge100 = 100;
  static const int xpBadge500 = 500;
  static const int xpBadge1000 = 1000;
  static const int streakMinForBadge = 3;
  static const int streakBadgeThreshold = 7;

  static const String defaultAvatarId = 'avatar_1';
  static const String defaultAvatarPath = 'assets/characters/zelby_happy.png';
  static const String defaultGuestId = 'guest_default';

  static String characterName(String character) {
    switch (character.toLowerCase()) {
      case 'zelby':
        return zelby;
      case 'hazel':
        return hazel;
      case 'alby':
        return alby;
      default:
        return zelby;
    }
  }
}
