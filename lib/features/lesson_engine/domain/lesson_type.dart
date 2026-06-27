/// Internal lesson type enum used by lesson_engine renderers.
///
/// This is a SUBSET of the main [LessonType] in lib/features/lesson/domain/lesson.dart.
/// The main lesson enum (18 values) includes non-engine types (imageChoice, matching,
/// readSentence, arrangeWord) that are rendered directly by lesson_screen.dart widgets.
///
/// When adding a new type here, also:
/// 1. Add the corresponding value to LessonType in lesson.dart
/// 2. Add mapping in _mapToEngineType() in lesson_screen.dart
/// 3. Add renderer in lesson_renderer_factory.dart
/// 4. Add data in level_content.dart or JSON asset
enum LessonType {
  wordChoice,
  pictureChoice,
  listenChoose,
  wordOrder,
  missingWord,
  sentenceChoice,
  matchPair,
  storyReading,
  storyComprehension,
  readingComprehension,
  recordVoice,
  speakingPractice,
  trueFalse,
  fillBlank,
}
