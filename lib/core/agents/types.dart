import '../../features/lesson/domain/lesson.dart';

enum DifficultyLevel { warmup, focus, challenge }
enum UIMode { standard, simplified, enhanced }

class QuestionSpec {
  final String skillId;
  final DifficultyLevel difficulty;
  final LessonType preferredType;
  final List<String> keywords;
  final String? imageContext;

  const QuestionSpec({
    required this.skillId,
    this.difficulty = DifficultyLevel.focus,
    this.preferredType = LessonType.wordChoice,
    this.keywords = const [],
    this.imageContext,
  });
}

class HintSpec {
  final String questionId;
  final LessonType questionType;
  final String correctAnswer;
  final List<String> options;
  final int attemptsUsed;
  final DifficultyLevel difficulty;
  final String? childName;

  const HintSpec({
    required this.questionId,
    required this.questionType,
    required this.correctAnswer,
    this.options = const [],
    this.attemptsUsed = 0,
    this.difficulty = DifficultyLevel.focus,
    this.childName,
  });
}

class DifficultySpec {
  final int consecutiveCorrect;
  final int consecutiveWrong;
  final double averageResponseTimeMs;
  final DifficultyLevel currentLevel;
  final int totalAttempts;
  final int totalCorrect;

  const DifficultySpec({
    this.consecutiveCorrect = 0,
    this.consecutiveWrong = 0,
    this.averageResponseTimeMs = 0,
    this.currentLevel = DifficultyLevel.focus,
    this.totalAttempts = 0,
    this.totalCorrect = 0,
  });
}

class FeedbackSpec {
  final bool isCorrect;
  final String questionType;
  final String childName;
  final int streak;
  final int xpEarned;
  final int attemptsUsed;
  final String? correctAnswer;
  final String? childAnswer;

  const FeedbackSpec({
    required this.isCorrect,
    this.questionType = '',
    this.childName = '',
    this.streak = 0,
    this.xpEarned = 0,
    this.attemptsUsed = 1,
    this.correctAnswer,
    this.childAnswer,
  });
}

class CurriculumSpec {
  final int currentLevelIndex;
  final double masteryScore;
  final List<String> completedSkills;
  final int streak;
  final int age;
  final Duration timeSinceLastPlay;

  const CurriculumSpec({
    this.currentLevelIndex = 0,
    this.masteryScore = 0,
    this.completedSkills = const [],
    this.streak = 0,
    this.age = 5,
    this.timeSinceLastPlay = Duration.zero,
  });
}

class SafetyReport {
  final bool passed;
  final List<String> warnings;
  final String? rejectedReason;

  const SafetyReport({
    this.passed = true,
    this.warnings = const [],
    this.rejectedReason,
  });
}

class UXSpec {
  final int childAge;
  final int sessionDurationMinutes;
  final int errorsInLastMinute;
  final double responseTimeAvg;
  final bool isNewUser;

  const UXSpec({
    this.childAge = 5,
    this.sessionDurationMinutes = 0,
    this.errorsInLastMinute = 0,
    this.responseTimeAvg = 0,
    this.isNewUser = true,
  });
}

class AgentContext {
  final Map<String, dynamic> data;

  const AgentContext(this.data);

  T get<T>(String key, T defaultValue) =>
      (data[key] as T?) ?? defaultValue;

  bool getBool(String key, {bool defaultValue = false}) =>
      (data[key] as bool?) ?? defaultValue;

  int getInt(String key, {int defaultValue = 0}) =>
      (data[key] as int?) ?? defaultValue;

  String getString(String key, {String defaultValue = ''}) =>
      (data[key] as String?) ?? defaultValue;
}
