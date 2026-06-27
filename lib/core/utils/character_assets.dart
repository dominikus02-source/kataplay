class CharacterAssets {
  CharacterAssets._();

  static const String basePath = 'assets/characters';

  // Zelby
  static const String zelbyIdle = '$basePath/zelby_idle.png';
  static const String zelbyHappy = '$basePath/zelby_happy.png';
  static const String zelbyWave = '$basePath/zelby_wave.png';
  static const String zelbyThinking = '$basePath/zelby_thinking.png';
  static const String zelbyCelebrate = '$basePath/zelby_celebrate.png';
  static const String zelbyReading = '$basePath/zelby_reading.png';

  // Hazel
  static const String hazelIdle = '$basePath/hazel_idle.png';
  static const String hazelHappy = '$basePath/hazel_happy.png';
  static const String hazelReading = '$basePath/hazel_reading.png';
  static const String hazelReadingSitting = '$basePath/hazel_reading_sitting.png';
  static const String hazelEncouraging = '$basePath/hazel_encouraging.png';
  static const String hazelCelebrate = '$basePath/hazel_celebrate.png';
  static const String hazelThinking = '$basePath/hazel_thinking.png';

  // Alby
  static const String albyIdle = '$basePath/alby_idle.png';
  static const String albyHappy = '$basePath/alby_happy.png';
  static const String albyCelebrate = '$basePath/alby_celebrate.png';
  static const String albyJumping = '$basePath/alby_jumping.png';
  static const String albyLaughing = '$basePath/alby_laughing.png';
  static const String albyQuestioning = '$basePath/alby_questioning.png';

  static String getImageForCharacter(String character, {String mood = 'idle'}) {
    switch (character.toLowerCase()) {
      case 'zelby':
        return _zelbyMood(mood);
      case 'hazel':
        return _hazelMood(mood);
      case 'alby':
        return _albyMood(mood);
      default:
        return zelbyIdle;
    }
  }

  static String _zelbyMood(String mood) {
    switch (mood) {
      case 'happy':
        return zelbyHappy;
      case 'wave':
        return zelbyWave;
      case 'thinking':
        return zelbyThinking;
      case 'celebrate':
        return zelbyCelebrate;
      case 'reading':
        return zelbyReading;
      default:
        return zelbyIdle;
    }
  }

  static String _hazelMood(String mood) {
    switch (mood) {
      case 'happy':
        return hazelHappy;
      case 'reading':
        return hazelReading;
      case 'reading_sitting':
        return hazelReadingSitting;
      case 'encouraging':
        return hazelEncouraging;
      case 'celebrate':
        return hazelCelebrate;
      case 'thinking':
        return hazelThinking;
      default:
        return hazelIdle;
    }
  }

  static String _albyMood(String mood) {
    switch (mood) {
      case 'happy':
        return albyHappy;
      case 'celebrate':
        return albyCelebrate;
      case 'jumping':
        return albyJumping;
      case 'laughing':
        return albyLaughing;
      case 'questioning':
        return albyQuestioning;
      default:
        return albyIdle;
    }
  }
}
