import '../agent.dart';
import '../types.dart';
import '../../../features/lesson/domain/lesson.dart';

class SafetyAgent extends KataPlayAgent<LessonQuestion, SafetyReport> {
  @override
  String get name => 'safety';

  @override
  Future<SafetyReport> process(LessonQuestion input) async {
    return _validate(input);
  }

  SafetyReport _validate(LessonQuestion input) {
    final warnings = <String>[];

    if (_hasProfanity(input.instruction)) {
      warnings.add('instruction_profanity');
    }
    if (_hasProfanity(input.correctAnswer)) {
      warnings.add('answer_profanity');
    }
    for (final opt in input.options) {
      if (_hasProfanity(opt)) {
        warnings.add('option_profanity');
      }
    }
    if (input.sentence != null && _hasProfanity(input.sentence!)) {
      warnings.add('sentence_profanity');
    }

    if (input.instruction.isEmpty) {
      warnings.add('empty_instruction');
    }
    if (input.correctAnswer.isEmpty) {
      warnings.add('empty_correct_answer');
    }
    if (input.options.isEmpty && _needsOptions(input.type)) {
      warnings.add('missing_options');
    }
    if (!input.options.contains(input.correctAnswer) && input.options.isNotEmpty) {
      warnings.add('correct_answer_not_in_options');
    }

    if (input.instruction.length > 200) {
      warnings.add('instruction_too_long');
    }
    if (input.correctAnswer.length > 50) {
      warnings.add('answer_too_long');
    }

    final critical = ['empty_instruction', 'empty_correct_answer', 'correct_answer_not_in_options'];
    final hasCriticalWarning = warnings.any((w) => critical.contains(w) || w.contains('profanity'));

    return SafetyReport(
      passed: !hasCriticalWarning,
      warnings: warnings,
      rejectedReason: hasCriticalWarning ? _rejectionReason(warnings) : null,
    );
  }

  String? _rejectionReason(List<String> warnings) {
    if (warnings.any((w) => w.startsWith('empty_'))) return 'Question has empty required fields';
    if (warnings.any((w) => w == 'correct_answer_not_in_options')) return 'Correct answer not found in options';
    if (warnings.any((w) => w.contains('profanity'))) return 'Question contains inappropriate language';
    return null;
  }

  bool _hasProfanity(String text) {
    const badWords = ['anjing', 'babi', 'bodoh', 'tolol', 'goblok', 'bangsat'];
    final lower = text.toLowerCase();
    return badWords.any((w) => lower.contains(w));
  }

  bool _needsOptions(LessonType type) {
    return type == LessonType.wordChoice ||
        type == LessonType.imageChoice ||
        type == LessonType.trueFalse ||
        type == LessonType.matching ||
        type == LessonType.readSentence;
  }
}
