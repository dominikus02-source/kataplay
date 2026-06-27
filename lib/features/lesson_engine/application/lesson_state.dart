import '../domain/lesson_step.dart';
import '../domain/lesson_result.dart';

enum LessonStatus {
  loading,
  ready,
  playing,
  checking,
  feedback,
  completed,
  error,
}

class LessonState {
  final List<LessonStep> steps;
  final int currentStepIndex;
  final LessonStatus status;
  final List<String> selectedAnswers;
  final bool isCorrect;
  final int score;
  final int totalSteps;
  final List<StepResult> stepResults;
  final String? feedbackMessage;
  final String? errorMessage;
  final int heartsRemaining;
  final int xpEarnedSoFar;

  const LessonState({
    this.steps = const [],
    this.currentStepIndex = 0,
    this.status = LessonStatus.loading,
    this.selectedAnswers = const [],
    this.isCorrect = false,
    this.score = 0,
    this.totalSteps = 0,
    this.stepResults = const [],
    this.feedbackMessage,
    this.errorMessage,
    this.heartsRemaining = 5,
    this.xpEarnedSoFar = 0,
  });

  LessonStep? get currentStep {
    if (currentStepIndex < 0 || currentStepIndex >= steps.length) return null;
    return steps[currentStepIndex];
  }

  bool get hasNext => currentStepIndex < steps.length - 1;
  bool get isFirst => currentStepIndex == 0;
  bool get isLast => currentStepIndex >= steps.length - 1;
  bool get hasSelection => selectedAnswers.isNotEmpty;
  double get progress => totalSteps > 0 ? currentStepIndex / totalSteps : 0.0;

  LessonState copyWith({
    List<LessonStep>? steps,
    int? currentStepIndex,
    LessonStatus? status,
    List<String>? selectedAnswers,
    bool? isCorrect,
    int? score,
    int? totalSteps,
    List<StepResult>? stepResults,
    String? feedbackMessage,
    String? errorMessage,
    int? heartsRemaining,
    int? xpEarnedSoFar,
  }) {
    return LessonState(
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      status: status ?? this.status,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isCorrect: isCorrect ?? this.isCorrect,
      score: score ?? this.score,
      totalSteps: totalSteps ?? this.totalSteps,
      stepResults: stepResults ?? this.stepResults,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      heartsRemaining: heartsRemaining ?? this.heartsRemaining,
      xpEarnedSoFar: xpEarnedSoFar ?? this.xpEarnedSoFar,
    );
  }
}
