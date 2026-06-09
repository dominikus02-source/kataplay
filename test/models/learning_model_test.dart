import 'package:flutter_test/flutter_test.dart';
import 'package:kataplay/features/learning/data/models/question_model.dart';
import 'package:kataplay/features/learning/data/models/learning_session_model.dart';
import 'package:kataplay/features/learning/data/seed_questions.dart';

void main() {
  group('Question Model', () {
    test('QuestionType enum has all 10 types', () {
      expect(QuestionType.values.length, 10);
    });

    test('CharacterType enum has all 3 characters', () {
      expect(CharacterType.values.length, 3);
    });

    test('CharacterType.suggestedForType returns correct character', () {
      expect(CharacterType.suggestedForType(QuestionType.pickInitialLetter),
          CharacterType.zelby);
      expect(CharacterType.suggestedForType(QuestionType.fillInTheBlank),
          CharacterType.hazel);
      expect(CharacterType.suggestedForType(QuestionType.listenAndChoose),
          CharacterType.alby);
    });

    test('CharacterType extension properties work', () {
      expect(CharacterType.zelby.displayName, 'Zelby');
      expect(CharacterType.hazel.displayName, 'Hazel');
      expect(CharacterType.alby.displayName, 'Alby');
      expect(CharacterType.zelby.emoji, '🐵');
      expect(CharacterType.hazel.emoji, '🦉');
      expect(CharacterType.alby.emoji, '🐿️');
    });

    test('AnswerOption toJson/fromJson roundtrip', () {
      const option = AnswerOption(
        id: 'test_1',
        text: 'Apel',
        emoji: '🍎',
        isCorrect: true,
      );
      final json = option.toJson();
      final fromJson = AnswerOption.fromJson(json);
      expect(fromJson.id, option.id);
      expect(fromJson.text, option.text);
      expect(fromJson.emoji, option.emoji);
      expect(fromJson.isCorrect, option.isCorrect);
    });
  });

  group('Question Validator', () {
    test('Valid multiple choice question passes validation', () {
      final question = Question(
        id: 'test_mc',
        questionType: QuestionType.multipleChoice,
        questionText: 'Huruf awal gambar ini apa?',
        options: [
          AnswerOption(id: 'a', text: 'A', isCorrect: true),
          AnswerOption(id: 'b', text: 'B'),
        ],
      );
      final result = question.validate();
      expect(result.isValid, true);
      expect(result.hasErrors, false);
    });

    test('Question with empty text fails validation', () {
      final question = Question(
        id: 'test_empty',
        questionType: QuestionType.multipleChoice,
        questionText: '',
        options: [
          AnswerOption(id: 'a', text: 'A', isCorrect: true),
        ],
      );
      final result = question.validate();
      expect(result.isValid, false);
      expect(result.errors.any((e) => e.contains('empty')), true);
    });

    test('Multiple choice without correct answer fails', () {
      final question = Question(
        id: 'test_no_correct',
        questionType: QuestionType.multipleChoice,
        questionText: 'Pilih jawaban',
        options: [
          AnswerOption(id: 'a', text: 'A'),
          AnswerOption(id: 'b', text: 'B'),
        ],
      );
      final result = question.validate();
      expect(result.isValid, false);
    });

    test('Fill in blank without correctAnswer fails', () {
      final question = Question(
        id: 'test_fb',
        questionType: QuestionType.fillInTheBlank,
        questionText: 'Isi rumpang ___',
      );
      final result = question.validate();
      expect(result.isValid, false);
    });

    test('Arrange words without fragments fails', () {
      final question = Question(
        id: 'test_aw',
        questionType: QuestionType.arrangeWords,
        questionText: 'Susun kata!',
      );
      final result = question.validate();
      expect(result.isValid, false);
    });

    test('Order story with less than 3 steps fails', () {
      final question = Question(
        id: 'test_os',
        questionType: QuestionType.orderStory,
        questionText: 'Urutkan!',
        storySteps: [
          StoryStep(id: '1', text: 'Step 1', correctPosition: 0),
          StoryStep(id: '2', text: 'Step 2', correctPosition: 1),
        ],
      );
      final result = question.validate();
      expect(result.isValid, false);
    });
  });

  group('Learning Session State', () {
    test('Initial state has correct defaults', () {
      const state = LearningSessionState();
      expect(state.phase, LearningSessionPhase.intro);
      expect(state.livesRemaining, 3);
      expect(state.maxLives, 3);
      expect(state.correctCount, 0);
      expect(state.wrongCount, 0);
      expect(state.progress, 0.0);
    });

    test('Star calculation works correctly', () {
      // 3 stars: 90%+ and no wrong
      final perfect = LearningSessionState(
        questions: List.filled(5, _dummyQuestion),
        correctCount: 5,
        wrongCount: 0,
      );
      expect(perfect.starsEarned, 3);
      expect(perfect.isPerfect, true);

      // 2 stars: 70%+
      final good = LearningSessionState(
        questions: List.filled(5, _dummyQuestion),
        correctCount: 4,
        wrongCount: 1,
      );
      expect(good.starsEarned, 2);

      // 1 star: 40%+
      final ok = LearningSessionState(
        questions: List.filled(5, _dummyQuestion),
        correctCount: 2,
        wrongCount: 3,
      );
      expect(ok.starsEarned, 1);

      // 0 stars: below 40%
      final fail = LearningSessionState(
        questions: List.filled(5, _dummyQuestion),
        correctCount: 1,
        wrongCount: 4,
      );
      expect(fail.starsEarned, 0);
    });

    test('isComplete returns true when all questions answered', () {
      final state = LearningSessionState(
        questions: List.filled(3, _dummyQuestion),
        currentQuestionIndex: 3,
      );
      expect(state.isComplete, true);
    });

    test('isComplete returns true when lives are 0', () {
      final state = LearningSessionState(
        questions: List.filled(5, _dummyQuestion),
        currentQuestionIndex: 2,
        livesRemaining: 0,
      );
      expect(state.isComplete, true);
    });

    test('isSuccessful requires at least 1 correct and lives > 0', () {
      final success = LearningSessionState(
        questions: List.filled(3, _dummyQuestion),
        correctCount: 2,
        livesRemaining: 1,
      );
      expect(success.isSuccessful, true);

      final failed = LearningSessionState(
        questions: List.filled(3, _dummyQuestion),
        correctCount: 2,
        livesRemaining: 0,
      );
      expect(failed.isSuccessful, false);
    });
  });

  group('Seed Questions', () {
    test('All seed questions are valid', () {
      for (final q in SeedQuestions.all) {
        final result = q.validate();
        expect(result.isValid, true,
            reason: 'Question ${q.id} is invalid: ${result.errors}');
      }
    });

    test('Seed questions cover all 10 question types', () {
      final types = SeedQuestions.all.map((q) => q.questionType).toSet();
      for (final type in QuestionType.values) {
        expect(types.contains(type), true,
            reason: 'Missing seed questions for type: ${type.name}');
      }
    });

    test('All 3 characters are used in seed questions', () {
      final characters = SeedQuestions.all
          .where((q) => q.character != null)
          .map((q) => q.character!)
          .toSet();
      expect(characters.contains(CharacterType.zelby), true);
      expect(characters.contains(CharacterType.hazel), true);
      expect(characters.contains(CharacterType.alby), true);
    });

    test('Seed questions have natural, kid-friendly text', () {
      for (final q in SeedQuestions.all) {
        // No empty question text
        expect(q.questionText.isNotEmpty, true);
        // No extremely long questions (max ~80 chars for kids)
        expect(q.questionText.length <= 100, true,
            reason: 'Question ${q.id} text too long: "${q.questionText}"');
        // Feedback should be positive
        expect(q.feedbackCorrect.isNotEmpty, true);
        expect(q.feedbackWrong.isNotEmpty, true);
      }
    });

    test('All choice-based questions have at least one correct answer', () {
      final choiceTypes = {
        QuestionType.multipleChoice,
        QuestionType.trueFalse,
        QuestionType.matchWordImage,
        QuestionType.pickCorrectImage,
        QuestionType.pickInitialLetter,
        QuestionType.listenAndChoose,
      };

      for (final q in SeedQuestions.all) {
        if (choiceTypes.contains(q.questionType)) {
          expect(q.correctOptionIds.isNotEmpty, true,
              reason: 'Question ${q.id} has no correct option');
        }
      }
    });
  });
}

// Dummy question for testing session state
const _dummyQuestion = Question(
  id: 'dummy',
  questionType: QuestionType.multipleChoice,
  questionText: 'Test?',
  options: [
    AnswerOption(id: 'a', text: 'A', isCorrect: true),
  ],
);
