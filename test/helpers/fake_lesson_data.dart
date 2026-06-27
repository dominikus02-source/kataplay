import 'package:kataplay_2/features/lesson/domain/lesson.dart';
import 'package:kataplay_2/features/lesson/domain/brain_types.dart';

/// Stable, deterministic fake lesson data for widget tests.
///
/// Does not depend on JSON files, network, or production LevelContent.
/// All correct answers are present in their options lists.

final fakeLevel1 = Level(
  id: 'test_level_1',
  title: 'Test Level',
  description: 'Level for testing',
  levelNumber: 1,
  icon: '🔤',
  lessons: [
    Lesson(
      id: 'test_lesson_1',
      title: 'Mengenal Huruf',
      description: 'Tes mengenal huruf',
      character: 'zelby',
      questions: [
        const LessonQuestion(
          type: LessonType.imageChoice,
          instruction: 'Huruf apa ini?',
          correctAnswer: 'A',
          options: ['E', 'U', 'A', 'I'],
          imageText: 'A',
          hint: 'A seperti ayam',
        ),
        const LessonQuestion(
          type: LessonType.wordChoice,
          instruction: 'Pilih kata yang benar',
          correctAnswer: 'buku',
          options: ['buku', 'bola', 'rumah', 'meja'],
          hint: 'Benda untuk dibaca',
        ),
        const LessonQuestion(
          type: LessonType.trueFalse,
          instruction: 'Apakah ini benar?',
          correctAnswer: 'Benar',
          options: ['Benar', 'Salah'],
        ),
        const LessonQuestion(
          type: LessonType.fillBlank,
          instruction: 'Lengkapi kata: bu_',
          correctAnswer: 'buku',
        ),
        const LessonQuestion(
          type: LessonType.arrangeWord,
          instruction: 'Susun kata: buku',
          correctAnswer: 'buku',
          wordParts: ['bu', 'ku'],
        ),
      ],
      xpReward: 50,
    ),
  ],
);

/// A single fake question for quick lesson screen tests.
final fakeImageChoiceQuestion = const LessonQuestion(
  type: LessonType.imageChoice,
  instruction: 'Huruf apa ini?',
  correctAnswer: 'A',
  options: ['E', 'U', 'A', 'I'],
  imageText: 'A',
  hint: 'A seperti ayam',
);

final fakeLessonWithOneQuestion = Lesson(
  id: 'test_single',
  title: 'Test Single',
  description: 'Single question lesson',
  questions: [fakeImageChoiceQuestion],
  xpReward: 10,
);

/// Creates a BrainQuestionPayload from a LessonQuestion for engine tests.
BrainQuestionPayload fakePayloadFromQuestion(
  LessonQuestion question, {
  BrainDifficulty difficulty = BrainDifficulty.warmup,
}) {
  return BrainQuestionPayload(
    source: question,
    options: question.options,
    prompt: question.instruction,
    coachMessage: 'Ayo coba jawab!',
    microGoal: 'Kenali huruf',
    smartHint: question.hint ?? 'Coba pikirkan baik-baik',
    difficulty: difficulty,
  );
}
