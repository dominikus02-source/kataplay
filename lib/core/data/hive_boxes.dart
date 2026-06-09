/// Central Hive box names and initialization
/// All box names are defined here for consistency
class HiveBoxes {
  HiveBoxes._();

  static const String userProgress = 'user_progress';
  static const String gameProgress = 'game_progress';
  static const String onboarding = 'onboarding';
  static const String settings = 'settings';

  /// Keys within user_progress box
  static const String profileKey = 'user_profile';
  static const String streakKey = 'streak_data';
  static const String islandsKey = 'islands_progress';
  static const String stickersKey = 'stickers_data';
  static const String questsKey = 'daily_quests';

  /// Keys within game_progress box
  static const String matchingGameKey = 'matching_game_state';

  /// Keys within onboarding box
  static const String completedKey = 'onboarding_completed';
  static const String playerNameKey = 'player_name';
  static const String playerAgeKey = 'player_age';

  /// Keys within settings box
  static const String soundEnabledKey = 'sound_enabled';
  static const String musicEnabledKey = 'music_enabled';
}
