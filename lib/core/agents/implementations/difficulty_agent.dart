import '../agent.dart';
import '../types.dart';
import '../../constants/app_constants.dart';

class DifficultyAgent extends KataPlayAgent<DifficultySpec, Map<String, dynamic>> {
  @override
  String get name => 'difficulty';

  @override
  Future<Map<String, dynamic>> process(DifficultySpec input) async {
    final newLevel = _calculateDifficulty(input);
    final pacing = _calculatePacing(input, newLevel);
    final retryStrategy = _retryStrategy(input);

    return {
      'difficultyLevel': newLevel,
      'label': newLevel.name,
      'pacingMs': pacing,
      'retryStrategy': retryStrategy,
      'optionsCount': newLevel == DifficultyLevel.warmup ? 3 : 4,
      'timeMultiplier': newLevel == DifficultyLevel.warmup
          ? 1.5
          : newLevel == DifficultyLevel.challenge ? 0.7 : 1.0,
    };
  }

  DifficultyLevel _calculateDifficulty(DifficultySpec input) {
    if (input.consecutiveCorrect >= 3 && input.currentLevel == DifficultyLevel.warmup) {
      return DifficultyLevel.focus;
    }
    if (input.consecutiveCorrect >= 4 && input.currentLevel == DifficultyLevel.focus) {
      return DifficultyLevel.challenge;
    }
    if (input.consecutiveWrong >= 2 && input.currentLevel == DifficultyLevel.challenge) {
      return DifficultyLevel.focus;
    }
    if (input.consecutiveWrong >= 3 && input.currentLevel == DifficultyLevel.focus) {
      return DifficultyLevel.warmup;
    }
    if (input.totalAttempts > 0) {
      final accuracy = input.totalCorrect / input.totalAttempts;
      if (accuracy < 0.4) return DifficultyLevel.warmup;
      if (accuracy > 0.85) return DifficultyLevel.challenge;
    }
    return input.currentLevel;
  }

  int _calculatePacing(DifficultySpec input, DifficultyLevel newLevel) {
    final base = newLevel == DifficultyLevel.warmup
        ? AppConstants.feedbackDuration.inMilliseconds * 2
        : AppConstants.feedbackDuration.inMilliseconds;

    if (input.averageResponseTimeMs > 10000) return base * 2;
    if (input.averageResponseTimeMs < 3000) return (base * 0.7).round();
    return base;
  }

  String _retryStrategy(DifficultySpec input) {
    if (input.consecutiveWrong >= 3) return 'simplify_and_retry';
    if (input.consecutiveWrong >= 2) return 'hint_before_retry';
    return 'normal_retry';
  }
}
