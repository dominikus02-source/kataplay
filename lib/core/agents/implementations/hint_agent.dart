import '../agent.dart';
import '../types.dart';
import '../../../features/lesson/domain/lesson.dart';

class HintAgent extends KataPlayAgent<HintSpec, Map<String, dynamic>> {
  @override
  String get name => 'hint';

  @override
  Future<Map<String, dynamic>> process(HintSpec input) async {
    return _buildHint(input);
  }

  Map<String, dynamic> _buildHint(HintSpec input) {
    final level = input.attemptsUsed > 2 ? 'full' : input.attemptsUsed > 1 ? 'partial' : 'subtle';
    final childPrefix = input.childName != null && input.childName!.isNotEmpty
        ? '${input.childName}, '
        : '';

    String hintText;
    String hintType;
    Map<String, dynamic>? visualHint;

    switch (level) {
      case 'subtle':
        hintType = 'elimination';
        hintText = _subtleHint(input);
        break;
      case 'partial':
        hintType = 'scaffold';
        hintText = _partialHint(input);
        visualHint = _visualScaffold(input);
        break;
      case 'full':
        hintType = 'direct';
        hintText = _fullHint(input);
        break;
      default:
        hintType = 'subtle';
        hintText = _subtleHint(input);
    }

    return {
      'text': '$childPrefix$hintText',
      'type': hintType,
      'level': level,
      'visualHint': visualHint,
      'revealLetter': level == 'full' ? _revealPosition(input) : null,
      'reduceOptions': level == 'subtle' && input.options.length > 2,
    };
  }

  String _subtleHint(HintSpec input) {
    switch (input.questionType) {
      case LessonType.wordChoice:
        return 'Coba lihat huruf awalnya...';
      case LessonType.imageChoice:
        return 'Apa ya nama benda ini?';
      case LessonType.trueFalse:
        return 'Coba dibaca pelan-pelan...';
      case LessonType.arrangeWord:
        return 'Huruf pertama adalah ${input.correctAnswer[0].toUpperCase()}';
      case LessonType.fillBlank:
        return 'Kata ini punya ${input.correctAnswer.length} huruf';
      case LessonType.matching:
        return 'Cocokkan yang mirip ya';
      case LessonType.readSentence:
        return 'Baca satu-satu ya';
    }
  }

  String _partialHint(HintSpec input) {
    final firstLetter = input.correctAnswer[0].toUpperCase();
    switch (input.questionType) {
      case LessonType.wordChoice:
        return 'Huruf pertama adalah "$firstLetter". '
            'Cari kata yang diawali $firstLetter. '
            '${input.correctAnswer.length} huruf';
      case LessonType.arrangeWord:
        final revealed = input.correctAnswer
            .substring(0, (input.correctAnswer.length / 2).ceil())
            .toUpperCase();
        return 'Dua huruf pertama: $revealed';
      case LessonType.fillBlank:
        return 'Kata ini adalah "${input.correctAnswer}"';
      default:
        return 'Coba ingat-ingat pelajaran sebelumnya';
    }
  }

  String _fullHint(HintSpec input) {
    final answer = input.correctAnswer;
    switch (input.questionType) {
      case LessonType.wordChoice:
        return 'Jawabannya adalah "$answer"';
      case LessonType.arrangeWord:
        return 'Susunannya: ${answer.toUpperCase().split('').join(' ')}';
      default:
        return 'Jawabannya: "$answer"';
    }
  }

  Map<String, dynamic>? _visualScaffold(HintSpec input) {
    if (input.questionType == LessonType.arrangeWord && input.correctAnswer.length > 2) {
      return {
        'type': 'letter_outline',
        'positions': List.generate(input.correctAnswer.length, (i) => i),
        'revealedCount': (input.correctAnswer.length / 3).ceil(),
      };
    }
    return null;
  }

  int? _revealPosition(HintSpec input) {
    if (input.questionType != LessonType.arrangeWord) return null;
    return (input.correctAnswer.length / 2).floor();
  }
}
