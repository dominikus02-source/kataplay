import 'lesson_step.dart';

class StepResult {
  final LessonStep step;
  final List<String> selectedAnswers;
  final bool isCorrect;
  final int attempts;
  final Duration timeSpent;
  final int xpEarned;

  const StepResult({
    required this.step,
    required this.selectedAnswers,
    required this.isCorrect,
    this.attempts = 1,
    this.timeSpent = Duration.zero,
    this.xpEarned = 0,
  });
}

class LessonResult {
  final String lessonId;
  final List<StepResult> stepResults;
  final int totalSteps;
  final int correctSteps;
  final int totalXpEarned;
  final DateTime completedAt;
  final Duration totalTimeSpent;

  const LessonResult({
    required this.lessonId,
    required this.stepResults,
    required this.totalSteps,
    required this.correctSteps,
    required this.totalXpEarned,
    required this.completedAt,
    this.totalTimeSpent = Duration.zero,
  });

  double get scorePercentage =>
      totalSteps > 0 ? correctSteps / totalSteps : 0.0;

  bool get isPerfect => correctSteps == totalSteps && totalSteps > 0;

  int get stars {
    if (isPerfect) return 3;
    if (scorePercentage >= 0.8) return 2;
    if (scorePercentage >= 0.5) return 1;
    return 0;
  }
}
