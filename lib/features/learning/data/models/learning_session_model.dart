import 'question_model.dart';

/// Represents the state of a learning session (a lesson with multiple questions)
enum LearningSessionPhase {
  intro,        // Session introduction with character greeting
  question,     // Showing a question
  feedback,     // Showing correct/wrong feedback
  completed,    // All questions answered - celebration
  combo,        // Combo milestone celebration (e.g., 5/10 streak)
}

/// Tracks progress for a single question within a session
class QuestionAttempt {
  final String questionId;
  final bool isCorrect;
  final String? selectedAnswerId;
  final int attemptsCount;
  final Duration timeTaken;

  const QuestionAttempt({
    required this.questionId,
    required this.isCorrect,
    this.selectedAnswerId,
    this.attemptsCount = 1,
    this.timeTaken = Duration.zero,
  });

  QuestionAttempt copyWith({
    bool? isCorrect,
    String? selectedAnswerId,
    int? attemptsCount,
    Duration? timeTaken,
  }) {
    return QuestionAttempt(
      questionId: questionId,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedAnswerId: selectedAnswerId ?? this.selectedAnswerId,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      timeTaken: timeTaken ?? this.timeTaken,
    );
  }
}

/// Complete state of a learning session
class LearningSessionState {
  final LearningSessionPhase phase;
  final List<Question> questions;
  final int currentQuestionIndex;
  final List<QuestionAttempt> attempts;
  final int livesRemaining;
  final int maxLives;
  final int totalXpEarned;
  final int totalCoinsEarned;
  final int correctCount;
  final int wrongCount;
  final Duration elapsed;
  final String sessionTitle;
  final String islandId;
  final int levelNumber;
  final bool showHint;
  final String? feedbackMessage;
  final bool? lastAnswerCorrect;
  final int comboCount;        // Current consecutive correct streak
  final int maxCombo;          // Best combo in this session
  final String? selectedAnswerId; // Currently selected answer (before PERIKSA)

  const LearningSessionState({
    this.phase = LearningSessionPhase.intro,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.attempts = const [],
    this.livesRemaining = 3,
    this.maxLives = 3,
    this.totalXpEarned = 0,
    this.totalCoinsEarned = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.elapsed = Duration.zero,
    this.sessionTitle = 'Petualangan Kata',
    this.islandId = 'awal',
    this.levelNumber = 1,
    this.showHint = false,
    this.feedbackMessage,
    this.lastAnswerCorrect,
    this.comboCount = 0,
    this.maxCombo = 0,
    this.selectedAnswerId,
  });

  /// Current question (null if out of bounds)
  Question? get currentQuestion {
    if (currentQuestionIndex >= 0 && currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  /// Progress as 0.0 - 1.0
  double get progress =>
      questions.isEmpty ? 0.0 : currentQuestionIndex / questions.length;

  /// Whether the session is complete (all questions answered or no lives)
  bool get isComplete =>
      currentQuestionIndex >= questions.length || livesRemaining <= 0;

  /// Whether the session was successful (at least 1 correct and lives > 0)
  bool get isSuccessful => correctCount > 0 && livesRemaining > 0;

  /// Star rating based on performance (1-3 stars)
  int get starsEarned {
    if (questions.isEmpty) return 0;
    final percentage = correctCount / questions.length;
    if (percentage >= 0.9 && wrongCount == 0) return 3;
    if (percentage >= 0.7) return 2;
    if (percentage >= 0.4) return 1;
    return 0;
  }

  /// Whether it's a perfect run
  bool get isPerfect => wrongCount == 0 && correctCount == questions.length;

  /// Whether an answer is currently selected (for PERIKSA button state)
  bool get hasSelectedAnswer => selectedAnswerId != null;

  /// Total questions count
  int get totalQuestions => questions.length;

  /// Questions remaining
  int get questionsRemaining =>
      questions.length - currentQuestionIndex;

  /// Whether the current combo qualifies for a celebration
  bool get isComboMilestone => comboCount > 0 && comboCount % 5 == 0;

  LearningSessionState copyWith({
    LearningSessionPhase? phase,
    List<Question>? questions,
    int? currentQuestionIndex,
    List<QuestionAttempt>? attempts,
    int? livesRemaining,
    int? maxLives,
    int? totalXpEarned,
    int? totalCoinsEarned,
    int? correctCount,
    int? wrongCount,
    Duration? elapsed,
    String? sessionTitle,
    String? islandId,
    int? levelNumber,
    bool? showHint,
    String? feedbackMessage,
    bool? lastAnswerCorrect,
    int? comboCount,
    int? maxCombo,
    String? selectedAnswerId,
    bool clearSelectedAnswer = false,
  }) {
    return LearningSessionState(
      phase: phase ?? this.phase,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      attempts: attempts ?? this.attempts,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      maxLives: maxLives ?? this.maxLives,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      totalCoinsEarned: totalCoinsEarned ?? this.totalCoinsEarned,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      elapsed: elapsed ?? this.elapsed,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      islandId: islandId ?? this.islandId,
      levelNumber: levelNumber ?? this.levelNumber,
      showHint: showHint ?? this.showHint,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
      comboCount: comboCount ?? this.comboCount,
      maxCombo: maxCombo ?? this.maxCombo,
      selectedAnswerId: clearSelectedAnswer ? null : (selectedAnswerId ?? this.selectedAnswerId),
    );
  }
}
