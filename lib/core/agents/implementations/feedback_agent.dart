import '../agent.dart';
import '../types.dart';

class FeedbackAgent extends KataPlayAgent<FeedbackSpec, Map<String, dynamic>> {
  @override
  String get name => 'feedback';

  @override
  Future<Map<String, dynamic>> process(FeedbackSpec input) async {
    return _generateFeedback(input);
  }

  Map<String, dynamic> _generateFeedback(FeedbackSpec input) {
    final name = input.childName.isNotEmpty ? '${input.childName}, ' : '';

    if (input.isCorrect) {
      return _correct(input, name);
    }
    return _incorrect(input, name);
  }

  Map<String, dynamic> _correct(FeedbackSpec input, String prefix) {
    final message = input.attemptsUsed <= 1
        ? _perfectFeedback(prefix)
        : _persistentFeedback(prefix);

    return {
      'message': message['text'],
      'title': message['title'],
      'emoji': message['emoji'],
      'type': 'correct',
      'characterReaction': 'happy',
      'particleEffect': 'stars',
      'xpAwarded': input.xpEarned,
      'soundEffect': input.xpEarned > 10 ? 'achievement' : 'correct',
    };
  }

  Map<String, dynamic> _incorrect(FeedbackSpec input, String prefix) {
    final encouragement = _encouragement(input, prefix);

    return {
      'message': encouragement['text'],
      'title': encouragement['title'],
      'emoji': encouragement['emoji'],
      'type': 'incorrect',
      'characterReaction': 'coach',
      'particleEffect': 'none',
      'xpAwarded': 0,
      'soundEffect': 'incorrect',
      'retryMessage': 'Ayo coba lagi!',
    };
  }

  Map<String, String> _perfectFeedback(String prefix) {
    final options = [
      {'text': '${prefix}Luar biasa! Kamu hebat banget!', 'title': 'Sempurna!', 'emoji': '🌟'},
      {'text': '${prefix}Keren! Jawabanmu tepat sekali!', 'title': 'Hebat!', 'emoji': '🎉'},
      {'text': '${prefix}Wah, pintar sekali!', 'title': 'Pintar!', 'emoji': '👏'},
      {'text': '${prefix}Tepat! Kamu sudah semakin jago!', 'title': 'Tepat!', 'emoji': '⭐'},
    ];
    return options[_random(options.length)];
  }

  Map<String, String> _persistentFeedback(String prefix) {
    final options = [
      {'text': '${prefix}Bagus! Kamu berhasil!', 'title': 'Berhasil!', 'emoji': '💪'},
      {'text': '${prefix}Nah gitu dong! Akhirnya berhasil!', 'title': 'Yes!', 'emoji': '🔥'},
      {'text': '${prefix}Mantap! Pantang menyerah!', 'title': 'Mantap!', 'emoji': '🎯'},
    ];
    return options[_random(options.length)];
  }

  Map<String, String> _encouragement(FeedbackSpec input, String prefix) {
    if (input.attemptsUsed >= 3) {
      return {
        'text': '${prefix}tidak apa-apa, yuk kita coba lagi pelan-pelan',
        'title': 'Coba Lagi',
        'emoji': '💪',
      };
    }
    if (input.attemptsUsed >= 2) {
      return {
        'text': '${prefix}hampir sampai! Ayo lihat lagi ya',
        'title': 'Coba Lagi',
        'emoji': '🤔',
      };
    }
    final options = [
      {'text': '${prefix}Yah, hampir! Coba perhatikan lagi ya', 'title': 'Coba Lagi', 'emoji': '😊'},
      {'text': '${prefix}Belum tepat, tapi kamu pasti bisa!', 'title': 'Coba Lagi', 'emoji': '💫'},
      {'text': '${prefix}Aduh, sedikit lagi loh! Ayo sekali lagi', 'title': 'Coba Lagi', 'emoji': '🌈'},
    ];
    return options[_random(options.length)];
  }

  int _random(int max) => DateTime.now().millisecondsSinceEpoch % max;
}
