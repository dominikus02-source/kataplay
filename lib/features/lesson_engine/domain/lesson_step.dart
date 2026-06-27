import 'lesson_type.dart';

class LessonStep {
  final String id;
  final LessonType type;
  final int level;
  final String worldId;
  final String prompt;
  final String instruction;
  final String? question;
  final List<String> choices;
  final List<String> correctAnswer;
  final String? imageAsset;
  final String? audioAsset;
  final String? storyText;
  final String? storyTitle;
  final String? storyImageAsset;
  final String? hint;
  final int difficulty;
  final Map<String, String>? matchPairs;
  final int? timeLimitSeconds;
  final int xpReward;

  const LessonStep({
    required this.id,
    required this.type,
    this.level = 1,
    this.worldId = 'hutan_kata',
    required this.prompt,
    required this.instruction,
    this.question,
    this.choices = const [],
    this.correctAnswer = const [],
    this.imageAsset,
    this.audioAsset,
    this.storyText,
    this.storyTitle,
    this.storyImageAsset,
    this.hint,
    this.difficulty = 1,
    this.matchPairs,
    this.timeLimitSeconds,
    this.xpReward = 10,
  });

  bool get hasChoices => choices.isNotEmpty;
  bool get hasStory => storyText != null && storyText!.isNotEmpty;
  bool get hasMatchPairs => matchPairs != null && matchPairs!.isNotEmpty;
  bool get hasImage => imageAsset != null && imageAsset!.isNotEmpty;

  bool isValidAnswer(List<String> answer) {
    if (correctAnswer.isEmpty) return false;
    if (answer.length != correctAnswer.length) return false;
    for (int i = 0; i < answer.length; i++) {
      if (answer[i].toLowerCase().trim() !=
          correctAnswer[i].toLowerCase().trim()) {
        return false;
      }
    }
    return true;
  }

  bool isCorrectAnswer(String answer) {
    return correctAnswer
        .any((ca) => ca.toLowerCase().trim() == answer.toLowerCase().trim());
  }

  factory LessonStep.fromJson(Map<String, dynamic> json) {
    return LessonStep(
      id: json['id'] as String? ?? '',
      type: _parseType(json['type'] as String? ?? 'wordChoice'),
      level: json['level'] as int? ?? 1,
      worldId: json['world'] as String? ?? 'hutan_kata',
      prompt: json['prompt'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
      question: json['question'] as String?,
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correctAnswer: (json['correctAnswer'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      imageAsset: json['image'] as String?,
      audioAsset: json['audio'] as String?,
      storyText: json['storyText'] as String?,
      storyTitle: json['storyTitle'] as String?,
      storyImageAsset: json['storyImage'] as String?,
      hint: json['hint'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
      matchPairs: json['matchPairs'] != null
          ? Map<String, String>.from(json['matchPairs'] as Map)
          : null,
      timeLimitSeconds: json['timeLimit'] as int?,
      xpReward: json['xpReward'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'level': level,
        'world': worldId,
        'prompt': prompt,
        'instruction': instruction,
        if (question != null) 'question': question,
        'choices': choices,
        'correctAnswer': correctAnswer,
        if (imageAsset != null) 'image': imageAsset,
        if (audioAsset != null) 'audio': audioAsset,
        if (storyText != null) 'storyText': storyText,
        if (storyTitle != null) 'storyTitle': storyTitle,
        if (storyImageAsset != null) 'storyImage': storyImageAsset,
        if (hint != null) 'hint': hint,
        'difficulty': difficulty,
        if (matchPairs != null) 'matchPairs': matchPairs,
        if (timeLimitSeconds != null) 'timeLimit': timeLimitSeconds,
        'xpReward': xpReward,
      };

  static LessonType _parseType(String type) {
    return LessonType.values.firstWhere(
      (t) => t.name == type,
      orElse: () => LessonType.wordChoice,
    );
  }
}
