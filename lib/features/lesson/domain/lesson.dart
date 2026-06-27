/// Main lesson type enum for all 18 question types.
///
/// Types handled natively (non-engine): imageChoice, wordChoice, trueFalse,
/// arrangeWord, fillBlank, matching, readSentence — rendered directly by
/// lesson_screen.dart widgets.
///
/// Types bridged to lesson_engine renderers: pictureChoice, wordOrder,
/// matchPair, listenChoose, missingWord, sentenceChoice, storyReading,
/// storyComprehension, readingComprehension, recordVoice, speakingPractice.
///
/// Lihat juga lib/features/lesson_engine/domain/lesson_type.dart untuk
/// versi internal engine (subset dari enum ini).
enum LessonType {
  imageChoice,
  pictureChoice,
  wordChoice,
  trueFalse,
  arrangeWord,
  wordOrder,
  fillBlank,
  matching,
  matchPair,
  readSentence,
  listenChoose,
  missingWord,
  sentenceChoice,
  storyReading,
  storyComprehension,
  readingComprehension,
  recordVoice,
  speakingPractice,
}

class LessonQuestion {
  final LessonType type;
  final String instruction;
  final String correctAnswer;
  final List<String> options;
  final List<String>? wordParts;
  final String? sentence;
  final String? hint;
  final String? imageText;
  final String? imageAsset;
  final String? matchLeft;
  final String? matchRight;

  const LessonQuestion({
    required this.type,
    required this.instruction,
    required this.correctAnswer,
    this.options = const [],
    this.wordParts,
    this.sentence,
    this.hint,
    this.imageText,
    this.imageAsset,
    this.matchLeft,
    this.matchRight,
  });
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String character;
  final List<LessonQuestion> questions;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.character = 'zelby',
    required this.questions,
    this.xpReward = 50,
  });

  int get totalXp => questions.length * 10 + xpReward;
}

class Level {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final String icon;
  final int levelNumber;

  const Level({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    this.icon = '🎯',
    required this.levelNumber,
  });

  int get totalXp => lessons.fold(0, (sum, l) => sum + l.totalXp);
}
