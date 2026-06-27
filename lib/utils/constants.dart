import '../app/theme/app_dimensions.dart';

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

  static const double bottomNavHeight = AppDimensions.bottomNavHeight;
  static const double progressBarHeight = AppDimensions.progressBarHeight;
  static const double characterSize = AppDimensions.characterSizeLg;
  static const double characterSizeSmall = AppDimensions.characterSizeSm;

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
