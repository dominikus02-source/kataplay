import '../domain/lesson.dart';

enum BrainDifficulty {
  warmup,
  focus,
  challenge,
}

extension BrainDifficultyLabel on BrainDifficulty {
  String get label {
    switch (this) {
      case BrainDifficulty.warmup:
        return 'Pemanasan';
      case BrainDifficulty.focus:
        return 'Fokus';
      case BrainDifficulty.challenge:
        return 'Tantangan';
    }
  }
}

class BrainQuestionPayload {
  final LessonQuestion source;
  final List<String> options;
  final String prompt;
  final String coachMessage;
  final String microGoal;
  final String smartHint;
  final BrainDifficulty difficulty;

  const BrainQuestionPayload({
    required this.source,
    required this.options,
    required this.prompt,
    required this.coachMessage,
    required this.microGoal,
    required this.smartHint,
    required this.difficulty,
  });
}

class BrainLessonSession {
  final String lessonId;
  final String title;
  final String character;
  final String openingLine;
  final String focusLabel;
  final int adaptiveSeed;
  final List<BrainQuestionPayload> questions;

  const BrainLessonSession({
    required this.lessonId,
    required this.title,
    required this.character,
    required this.openingLine,
    required this.focusLabel,
    required this.adaptiveSeed,
    required this.questions,
  });
}

class BrainFeedback {
  final String message;
  final String subtitle;
  final String mood;
  final String? revealedHint;

  const BrainFeedback({
    required this.message,
    required this.subtitle,
    required this.mood,
    this.revealedHint,
  });
}
