/// Question types supported by the Learning Screen
/// Each type renders differently in the QuestionRenderer
enum QuestionType {
  multipleChoice,     // Pilihan ganda (pick 1 of N)
  trueFalse,          // Benar / Salah
  matchWordImage,     // Menjodohkan kata dan gambar
  listenAndChoose,    // Dengarkan audio, pilih jawaban
  fillInTheBlank,     // Isi kalimat rumpang
  arrangeWords,       // Susun kata menjadi kalimat
  pickCorrectImage,   // Pilih gambar yang benar
  dragAndDrop,        // Drag & drop pasangan kata
  orderStory,         // Urutkan cerita pendek
  pickInitialLetter,  // Pilih huruf awal dari gambar
}

/// Character types that can accompany a question
enum CharacterType {
  zelby,  // Teman belajar utama - semangat &鼓励
  hazel,  // Ahli membaca & cerita - hint & bantuan
  alby,   // Ahli suara & menyusun kata - tantangan cepat
}

/// Extension for character metadata
extension CharacterTypeExtension on CharacterType {
  /// Display name in Bahasa Indonesia
  String get displayName {
    switch (this) {
      case CharacterType.zelby:
        return 'Zelby';
      case CharacterType.hazel:
        return 'Hazel';
      case CharacterType.alby:
        return 'Alby';
    }
  }

  /// Emoji fallback when image assets are unavailable
  String get emoji {
    switch (this) {
      case CharacterType.zelby:
        return '🐵';
      case CharacterType.hazel:
        return '🦉';
      case CharacterType.alby:
        return '🐿️';
    }
  }

  /// Personality description
  String get personality {
    switch (this) {
      case CharacterType.zelby:
        return 'Teman belajar yang ceria dan selalu memberi semangat';
      case CharacterType.hazel:
        return 'Ahli membaca yang bijak dan suka membantu';
      case CharacterType.alby:
        return 'Si cepat tanggap yang suka tantangan kata';
    }
  }

  /// Background color for avatar circle
  int get colorValue {
    switch (this) {
      case CharacterType.zelby:
        return 0xFF0B7A5C; // Emerald green (primary)
      case CharacterType.hazel:
        return 0xFF6B4FA0; // Purple (wise)
      case CharacterType.alby:
        return 0xFFFF9E3D; // Orange (energetic)
    }
  }

  /// Asset path for character illustration
  String get assetPath {
    switch (this) {
      case CharacterType.zelby:
        return 'assets/images/characters/zelby.png';
      case CharacterType.hazel:
        return 'assets/images/characters/hazel.png';
      case CharacterType.alby:
        return 'assets/images/characters/alby.png';
    }
  }

  /// Suggested character for each question type
  static CharacterType? suggestedForType(QuestionType type) {
    switch (type) {
      case QuestionType.pickInitialLetter:
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
        return CharacterType.zelby;
      case QuestionType.fillInTheBlank:
      case QuestionType.orderStory:
      case QuestionType.arrangeWords:
        return CharacterType.hazel;
      case QuestionType.listenAndChoose:
      case QuestionType.dragAndDrop:
      case QuestionType.matchWordImage:
      case QuestionType.pickCorrectImage:
        return CharacterType.alby;
    }
  }
}

/// Represents a single answer option
class AnswerOption {
  final String id;
  final String text;
  final String? emoji;      // Optional emoji/icon for the option
  final String? imagePath;  // Optional image asset path
  final bool isCorrect;

  const AnswerOption({
    required this.id,
    required this.text,
    this.emoji,
    this.imagePath,
    this.isCorrect = false,
  });

  AnswerOption copyWith({bool? isCorrect}) {
    return AnswerOption(
      id: id,
      text: text,
      emoji: emoji,
      imagePath: imagePath,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'emoji': emoji,
    'imagePath': imagePath,
    'isCorrect': isCorrect,
  };

  factory AnswerOption.fromJson(Map<String, dynamic> json) => AnswerOption(
    id: json['id'] as String? ?? '',
    text: json['text'] as String? ?? '',
    emoji: json['emoji'] as String?,
    imagePath: json['imagePath'] as String?,
    isCorrect: json['isCorrect'] as bool? ?? false,
  );
}

/// Represents a word fragment for arrange/drag-drop questions
class WordFragment {
  final String id;
  final String text;
  final int correctPosition; // 0-based index in the correct sequence

  const WordFragment({
    required this.id,
    required this.text,
    required this.correctPosition,
  });
}

/// Represents a story step for ordering questions
class StoryStep {
  final String id;
  final String text;
  final String? emoji;
  final int correctPosition;

  const StoryStep({
    required this.id,
    required this.text,
    this.emoji,
    required this.correctPosition,
  });
}

/// The core Question model — supports all 10+ question types
class Question {
  final String id;
  final QuestionType questionType;
  final String questionText;          // Natural, kid-friendly question
  final String? instruction;          // Short instruction line above question
  final String? hint;                 // Hint text shown when user taps hint
  final String? imagePath;            // Optional image shown with the question
  final String? audioPath;            // Optional audio for listen-and-choose
  final String? emoji;                // Optional emoji for visual questions
  final List<AnswerOption> options;   // For choice-based questions
  final List<WordFragment>? fragments; // For arrange/drag-drop questions
  final List<StoryStep>? storySteps;  // For order-story questions
  final String? correctAnswer;        // Free-text correct answer for fill-in-blank
  final CharacterType? character;     // Assigned character (null = auto-assign)
  final String feedbackCorrect;       // Feedback when answer is correct
  final String feedbackWrong;         // Feedback when answer is wrong
  final int xpReward;                 // XP earned for correct answer
  final int coinReward;               // Coins earned for correct answer
  final int difficulty;               // 1-3 difficulty level
  final String category;              // Island/category this question belongs to

  const Question({
    required this.id,
    required this.questionType,
    required this.questionText,
    this.instruction,
    this.hint,
    this.imagePath,
    this.audioPath,
    this.emoji,
    this.options = const [],
    this.fragments,
    this.storySteps,
    this.correctAnswer,
    this.character,
    this.feedbackCorrect = 'Benar! Keren!',
    this.feedbackWrong = 'Coba lagi, ya!',
    this.xpReward = 10,
    this.coinReward = 3,
    this.difficulty = 1,
    this.category = 'awal',
  });

  /// Get the effective character (explicit or auto-assigned)
  CharacterType get effectiveCharacter =>
      character ?? CharacterType.suggestedForType(questionType) ?? CharacterType.zelby;

  /// Get all correct answer IDs (for choice-based questions)
  List<String> get correctOptionIds =>
      options.where((o) => o.isCorrect).map((o) => o.id).toList();

  /// Validate this question is complete and displayable
  QuestionValidationResult validate() {
    return QuestionValidator.validate(this);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionType': questionType.name,
    'questionText': questionText,
    'instruction': instruction,
    'hint': hint,
    'imagePath': imagePath,
    'audioPath': audioPath,
    'emoji': emoji,
    'options': options.map((o) => o.toJson()).toList(),
    'correctAnswer': correctAnswer,
    'character': character?.name,
    'feedbackCorrect': feedbackCorrect,
    'feedbackWrong': feedbackWrong,
    'xpReward': xpReward,
    'coinReward': coinReward,
    'difficulty': difficulty,
    'category': category,
  };
}

/// Validation result for a question
class QuestionValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const QuestionValidationResult({
    this.isValid = true,
    this.errors = const [],
    this.warnings = const [],
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    if (isValid && !hasWarnings) return 'QuestionValidationResult: valid';
    final parts = <String>[];
    if (hasErrors) parts.add('errors: $errors');
    if (hasWarnings) parts.add('warnings: $warnings');
    return 'QuestionValidationResult: ${isValid ? "valid" : "invalid"}, ${parts.join(", ")}';
  }
}

/// Validates questions before they are displayed
class QuestionValidator {
  QuestionValidator._();

  /// Validate a question is complete and safe to display
  static QuestionValidationResult validate(Question q) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields
    if (q.id.isEmpty) errors.add('Question ID is empty');
    if (q.questionText.isEmpty) errors.add('Question text is empty');

    // Type-specific validation
    switch (q.questionType) {
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
      case QuestionType.pickCorrectImage:
      case QuestionType.pickInitialLetter:
        if (q.options.isEmpty) {
          errors.add('${q.questionType.name} requires options');
        } else if (q.options.where((o) => o.isCorrect).isEmpty) {
          errors.add('${q.questionType.name} requires at least one correct option');
        }
        break;

      case QuestionType.matchWordImage:
        if (q.options.length < 2) {
          errors.add('matchWordImage requires at least 2 options');
        }
        break;

      case QuestionType.listenAndChoose:
        if (q.options.isEmpty) {
          errors.add('listenAndChoose requires options');
        }
        if (q.audioPath == null || q.audioPath!.isEmpty) {
          warnings.add('listenAndChoose: no audioPath set, will use text-to-speech fallback');
        }
        break;

      case QuestionType.fillInTheBlank:
        if (q.correctAnswer == null || q.correctAnswer!.isEmpty) {
          errors.add('fillInTheBlank requires correctAnswer');
        }
        break;

      case QuestionType.arrangeWords:
        if (q.fragments == null || q.fragments!.isEmpty) {
          errors.add('arrangeWords requires fragments');
        }
        break;

      case QuestionType.dragAndDrop:
        if (q.fragments == null || q.fragments!.length < 2) {
          errors.add('dragAndDrop requires at least 2 fragments');
        }
        break;

      case QuestionType.orderStory:
        if (q.storySteps == null || q.storySteps!.length < 3) {
          errors.add('orderStory requires at least 3 story steps');
        }
        break;
    }

    // Character validation
    if (q.character != null) {
      warnings.add('Character ${q.character!.displayName} will be auto-resolved with fallback if asset unavailable');
    }

    // Image validation
    if (q.imagePath != null && q.imagePath!.isNotEmpty) {
      warnings.add('imagePath "${q.imagePath}" should be verified at runtime');
    }

    return QuestionValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
