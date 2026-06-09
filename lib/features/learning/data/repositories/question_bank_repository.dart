import '../models/question_model.dart';
import '../seed_questions.dart';

/// Repository for accessing the question bank
/// Handles question retrieval, filtering, validation, and fallback
class QuestionBankRepository {
  // In-memory cache of all questions
  List<Question>? _cachedQuestions;

  /// Get all questions, validating each before returning
  List<Question> getAllQuestions() {
    if (_cachedQuestions != null) return _cachedQuestions!;
    _cachedQuestions = _validateAndFilter(SeedQuestions.all);
    return _cachedQuestions!;
  }

  /// Get questions by category (island)
  List<Question> getByCategory(String category) {
    return getAllQuestions().where((q) => q.category == category).toList();
  }

  /// Get questions by type
  List<Question> getByType(QuestionType type) {
    return getAllQuestions().where((q) => q.questionType == type).toList();
  }

  /// Get questions by difficulty
  List<Question> getByDifficulty(int difficulty) {
    return getAllQuestions().where((q) => q.difficulty == difficulty).toList();
  }

  /// Get a learning session's worth of questions
  /// Returns 5-8 questions with good variety, filtered by category and difficulty
  List<Question> getSessionQuestions({
    required String category,
    required int difficulty,
    int count = 6,
  }) {
    var pool = getAllQuestions()
        .where((q) => q.category == category && q.difficulty <= difficulty)
        .toList();

    // If not enough questions in category, broaden the search
    if (pool.length < count) {
      final extras = getAllQuestions()
          .where((q) => q.difficulty <= difficulty && !pool.contains(q))
          .toList();
      pool.addAll(extras);
    }

    // Shuffle and take requested count
    pool.shuffle();
    final selected = pool.take(count).toList();

    // Ensure variety of question types
    _ensureTypeVariety(selected, pool, count);

    return selected;
  }

  /// Ensure we have at least 3 different question types in the session
  void _ensureTypeVariety(List<Question> selected, List<Question> pool, int count) {
    final types = selected.map((q) => q.questionType).toSet();
    if (types.length >= 3) return;

    // Try to add questions of different types
    for (final type in QuestionType.values) {
      if (types.contains(type)) continue;
      if (selected.length >= count) break;

      final candidate = pool
          .where((q) => q.questionType == type && !selected.contains(q))
          .firstOrNull;
      if (candidate != null) {
        selected.add(candidate);
      }
    }
  }

  /// Validate and filter questions — skip broken ones, log warnings
  List<Question> _validateAndFilter(List<Question> questions) {
    final valid = <Question>[];
    for (final q in questions) {
      final result = q.validate();
      if (result.isValid) {
        valid.add(q);
      }
      if (result.hasWarnings) {
        // In production, log to analytics/crashlytics
        // For now, just print
        // ignore: avoid_print
        print('[QuestionBank] Warnings for ${q.id}: ${result.warnings}');
      }
      if (result.hasErrors) {
        // ignore: avoid_print
        print('[QuestionBank] SKIPPED ${q.id}: ${result.errors}');
      }
    }
    return valid;
  }

  /// Clear cache (useful for testing)
  void clearCache() {
    _cachedQuestions = null;
  }
}
