import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/question_model.dart';
import '../data/models/learning_session_model.dart';
import '../data/repositories/question_bank_repository.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/widgets/character/character_components.dart';

// ============================================================
// QUESTION BANK PROVIDER
// ============================================================

final questionBankProvider = Provider<QuestionBankRepository>((ref) {
  return QuestionBankRepository();
});

// ============================================================
// LEARNING SESSION NOTIFIER
// ============================================================

class LearningSessionNotifier extends StateNotifier<LearningSessionState> {
  final QuestionBankRepository _questionBank;
  final Ref _ref;
  Timer? _timer;

  LearningSessionNotifier(this._ref, this._questionBank)
      : super(const LearningSessionState());

  /// Start a new learning session
  void startSession({
    required String islandId,
    required int levelNumber,
    required int difficulty,
    String? sessionTitle,
    int questionCount = 6,
  }) {
    _timer?.cancel();

    final questions = _questionBank.getSessionQuestions(
      category: islandId,
      difficulty: difficulty,
      count: questionCount,
    );

    // Filter out any invalid questions as extra safety
    final validQuestions = questions.where((q) => q.validate().isValid).toList();

    if (validQuestions.isEmpty) {
      // If no valid questions, create a fallback session
      state = const LearningSessionState(
        phase: LearningSessionPhase.completed,
        sessionTitle: 'Tidak ada soal',
      );
      return;
    }

    state = LearningSessionState(
      phase: LearningSessionPhase.intro,
      questions: validQuestions,
      livesRemaining: 3,
      maxLives: 3,
      sessionTitle: sessionTitle ?? 'Petualangan Kata',
      islandId: islandId,
      levelNumber: levelNumber,
    );

    _startTimer();
  }

  /// Move from intro to first question
  void startQuestions() {
    state = state.copyWith(phase: LearningSessionPhase.question);
  }

  /// Submit an answer for the current question
  void submitAnswer(String selectedAnswerId) {
    final question = state.currentQuestion;
    if (question == null) return;

    final isCorrect = question.correctOptionIds.contains(selectedAnswerId);

    _processAnswer(isCorrect: isCorrect, selectedId: selectedAnswerId);
  }

  /// Submit a free-text answer (for fill-in-the-blank)
  void submitTextAnswer(String answer) {
    final question = state.currentQuestion;
    if (question == null) return;

    final isCorrect = question.correctAnswer != null &&
        answer.trim().toLowerCase() == question.correctAnswer!.trim().toLowerCase();

    _processAnswer(isCorrect: isCorrect);
  }

  /// Submit an arranged sequence (for arrange/drag-drop/order)
  void submitSequence(List<int> positions) {
    final question = state.currentQuestion;
    if (question == null) return;

    bool isCorrect = false;

    if (question.questionType == QuestionType.arrangeWords ||
        question.questionType == QuestionType.dragAndDrop) {
      if (question.fragments != null) {
        final correctPositions = question.fragments!
            .map((f) => f.correctPosition)
            .toList();
        isCorrect = _listsEqual(positions, correctPositions);
      }
    } else if (question.questionType == QuestionType.orderStory) {
      if (question.storySteps != null) {
        final correctPositions = question.storySteps!
            .map((s) => s.correctPosition)
            .toList();
        isCorrect = _listsEqual(positions, correctPositions);
      }
    }

    _processAnswer(isCorrect: isCorrect);
  }

  /// Process the answer result
  void _processAnswer({required bool isCorrect, String? selectedId}) {
    final question = state.currentQuestion;
    if (question == null) return;

    final feedbackMessage = isCorrect
        ? question.feedbackCorrect
        : question.feedbackWrong;

    final attempt = QuestionAttempt(
      questionId: question.id,
      isCorrect: isCorrect,
      selectedAnswerId: selectedId,
    );

    state = state.copyWith(
      phase: LearningSessionPhase.feedback,
      lastAnswerCorrect: isCorrect,
      feedbackMessage: feedbackMessage,
      attempts: [...state.attempts, attempt],
      correctCount: isCorrect ? state.correctCount + 1 : state.correctCount,
      wrongCount: isCorrect ? state.wrongCount : state.wrongCount + 1,
      livesRemaining: isCorrect
          ? state.livesRemaining
          : (state.livesRemaining - 1).clamp(0, state.maxLives),
      totalXpEarned: isCorrect
          ? state.totalXpEarned + question.xpReward
          : state.totalXpEarned,
      totalCoinsEarned: isCorrect
          ? state.totalCoinsEarned + question.coinReward
          : state.totalCoinsEarned,
    );
  }

  /// Move to the next question after feedback
  void nextQuestion() {
    final nextIndex = state.currentQuestionIndex + 1;

    if (nextIndex >= state.questions.length || state.livesRemaining <= 0) {
      // Session complete
      _completeSession();
      return;
    }

    state = state.copyWith(
      phase: LearningSessionPhase.question,
      currentQuestionIndex: nextIndex,
      showHint: false,
      feedbackMessage: null,
      lastAnswerCorrect: null,
    );
  }

  /// Show hint for the current question
  void showHint() {
    state = state.copyWith(showHint: true);
  }

  /// Complete the session and process rewards
  void _completeSession() {
    _timer?.cancel();

    state = state.copyWith(
      phase: LearningSessionPhase.completed,
      feedbackMessage: null,
    );

    // Process rewards through user progress
    if (state.totalXpEarned > 0 || state.totalCoinsEarned > 0) {
      _ref.read(userProgressProvider.notifier).processGameRewards(
            coins: state.totalCoinsEarned,
            xp: state.totalXpEarned,
          );
    }

    // Update island progress if successful
    if (state.isSuccessful) {
      try {
        final islandId = int.tryParse(state.islandId);
        if (islandId != null) {
          _ref.read(islandProgressProvider.notifier).completeLevel(
                islandId,
                starsEarned: state.starsEarned,
              );
        }
      } catch (_) {
        // Non-critical: don't crash if island update fails
      }
    }
  }

  /// Timer for tracking session duration
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      state = state.copyWith(
        elapsed: state.elapsed + const Duration(seconds: 1),
      );
    });
  }

  /// Retry the current session
  void retrySession() {
    startSession(
      islandId: state.islandId,
      levelNumber: state.levelNumber,
      difficulty: state.questions.isNotEmpty
          ? state.questions.first.difficulty
          : 1,
      sessionTitle: state.sessionTitle,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ============================================================
// LEARNING SESSION PROVIDER
// ============================================================

final learningSessionProvider =
    StateNotifierProvider<LearningSessionNotifier, LearningSessionState>((ref) {
  final questionBank = ref.watch(questionBankProvider);
  return LearningSessionNotifier(ref, questionBank);
});
