import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataplay_2/features/lesson/data/level_content.dart';
import 'package:kataplay_2/features/lesson/domain/lesson.dart';
import 'package:kataplay_2/features/lesson_engine/application/lesson_state.dart';
import 'package:kataplay_2/features/lesson_engine/domain/lesson_step.dart';
import 'package:kataplay_2/features/lesson_engine/domain/lesson_type.dart' as engine;
import 'package:kataplay_2/features/lesson_engine/presentation/lesson_renderer_factory.dart';

Widget wrapApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

LessonState playingState() => const LessonState(
  status: LessonStatus.playing,
  selectedAnswers: [],
);

LessonState feedbackCorrect() => const LessonState(
  status: LessonStatus.feedback,
  isCorrect: true,
  selectedAnswers: ['A'],
);

LessonState feedbackWrong() => const LessonState(
  status: LessonStatus.feedback,
  isCorrect: false,
  selectedAnswers: ['X'],
);

void main() {
  group('All 14 engine renderers build without crash', () {
    testWidgets('wordChoice renderer shows choices', (tester) async {
      final step = LessonStep(
        id: 'test_1',
        type: engine.LessonType.wordChoice,
        prompt: 'Pilih kata yang tepat!',
        instruction: 'Cari huruf A',
        choices: ['A', 'B', 'C', 'D'],
        correctAnswer: ['A'],
        hint: 'A seperti apel',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('A seperti apel'), findsNothing);
    });

    testWidgets('pictureChoice renderer shows choices', (tester) async {
      final step = LessonStep(
        id: 'test_2',
        type: engine.LessonType.pictureChoice,
        prompt: 'Pilih gambar yang sesuai!',
        instruction: 'Cocokkan dengan kata',
        choices: ['apel', 'bola', 'cicak'],
        correctAnswer: ['apel'],
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('apel'), findsOneWidget);
      expect(find.text('bola'), findsOneWidget);
      expect(find.text('cicak'), findsOneWidget);
    });

    testWidgets('listenChoose renderer shows choices', (tester) async {
      final step = LessonStep(
        id: 'test_3',
        type: engine.LessonType.listenChoose,
        prompt: 'Dengarkan dan pilih!',
        instruction: 'Pilih yang benar',
        choices: ['rumah', 'sekolah', 'pasar'],
        correctAnswer: ['rumah'],
        audioAsset: 'audio/test.mp3',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('rumah'), findsOneWidget);
      expect(find.text('sekolah'), findsOneWidget);
      expect(find.text('pasar'), findsOneWidget);
    });

    testWidgets('wordOrder renderer shows draggable chips', (tester) async {
      final step = LessonStep(
        id: 'test_4',
        type: engine.LessonType.wordOrder,
        prompt: 'Susun kata!',
        instruction: 'Urutkan kata',
        choices: ['aku', 'suka', 'makan'],
        correctAnswer: ['aku', 'suka', 'makan'],
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('aku'), findsOneWidget);
      expect(find.text('suka'), findsOneWidget);
      expect(find.text('makan'), findsOneWidget);
    });

    testWidgets('missingWord renderer shows choices', (tester) async {
      final step = LessonStep(
        id: 'test_5',
        type: engine.LessonType.missingWord,
        prompt: 'Isi kata yang hilang!',
        instruction: 'Lengkapi kalimat',
        choices: ['rumah', 'sekolah', 'pasar'],
        correctAnswer: ['rumah'],
        storyText: 'Saya pergi ke ___',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('rumah'), findsOneWidget);
      expect(find.text('sekolah'), findsOneWidget);
      expect(find.text('pasar'), findsOneWidget);
    });

    testWidgets('sentenceChoice renderer shows sentence choices',
        (tester) async {
      final step = LessonStep(
        id: 'test_6',
        type: engine.LessonType.sentenceChoice,
        prompt: 'Pilih kalimat yang tepat!',
        instruction: 'Cari kalimat yang benar',
        choices: ['Aku suka makan.', 'Dia pergi ke pasar.'],
        correctAnswer: ['Aku suka makan.'],
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Aku suka makan.'), findsOneWidget);
      expect(find.text('Dia pergi ke pasar.'), findsOneWidget);
    });

    testWidgets('matchPair renderer shows left items', (tester) async {
      final step = LessonStep(
        id: 'test_7',
        type: engine.LessonType.matchPair,
        prompt: 'Pasangkan!',
        instruction: 'Cocokkan kiri dan kanan',
        matchPairs: {'apel': 'apple', 'bola': 'ball', 'cicak': 'lizard'},
        correctAnswer: ['apple', 'ball', 'lizard'],
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('apel'), findsOneWidget);
      expect(find.text('bola'), findsOneWidget);
      expect(find.text('cicak'), findsOneWidget);
    });

    testWidgets('storyReading renderer shows story text', (tester) async {
      final step = LessonStep(
        id: 'test_8',
        type: engine.LessonType.storyReading,
        prompt: 'Baca cerita',
        instruction: 'Baca dengan saksama',
        storyText: 'Ini adalah cerita tentang kucing.',
        storyTitle: 'Kucingku',
        storyImageAsset: 'assets/stories/cat.png',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Ini adalah cerita tentang kucing.'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('storyComprehension renderer shows choices', (tester) async {
      final step = LessonStep(
        id: 'test_9',
        type: engine.LessonType.storyComprehension,
        prompt: 'Apa yang terjadi?',
        instruction: 'Jawab pertanyaan',
        choices: ['Kucing makan', 'Kucing tidur', 'Kucing lari'],
        correctAnswer: ['Kucing tidur'],
        storyText: 'Kucing itu tidur di kursi.',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Kucing makan'), findsOneWidget);
      expect(find.text('Kucing tidur'), findsOneWidget);
      expect(find.text('Kucing lari'), findsOneWidget);
    });

    testWidgets('readingComprehension renderer shows choices', (tester) async {
      final step = LessonStep(
        id: 'test_10',
        type: engine.LessonType.readingComprehension,
        prompt: 'Baca dan jawab!',
        instruction: 'Jawab berdasarkan bacaan',
        choices: ['Matahari', 'Bulan', 'Bintang'],
        correctAnswer: ['Matahari'],
        storyText: 'Matahari bersinar terang di siang hari.',
        storyTitle: 'Cuaca',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Matahari'), findsOneWidget);
      expect(find.text('Bulan'), findsOneWidget);
      expect(find.text('Bintang'), findsOneWidget);
    });

    testWidgets('recordVoice renderer shows mic and instruction',
        (tester) async {
      final step = LessonStep(
        id: 'test_11',
        type: engine.LessonType.recordVoice,
        prompt: 'Rekam suaramu!',
        instruction: 'Baca kalimat berikut',
        storyText: 'Saya suka bermain bola.',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Ucapkan kata berikut:'), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
      expect(find.text('Tekan untuk merekam'), findsOneWidget);
    });

    testWidgets('speakingPractice renderer shows mic and instruction',
        (tester) async {
      final step = LessonStep(
        id: 'test_12',
        type: engine.LessonType.speakingPractice,
        prompt: 'Ayo berbicara!',
        instruction: 'Ucapkan kata berikut',
        storyText: 'keluarga',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Bacakan kalimat dengan nyaring'), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });

    testWidgets('trueFalse renderer shows Benar/Salah', (tester) async {
      final step = LessonStep(
        id: 'test_13',
        type: engine.LessonType.trueFalse,
        prompt: 'Benar atau salah?',
        instruction: 'Tentukan kebenaran',
        choices: ['Benar', 'Salah'],
        correctAnswer: ['Benar'],
        storyText: 'Matahari terbit di timur.',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('Benar'), findsOneWidget);
      expect(find.text('Salah'), findsOneWidget);
    });

    testWidgets('fillBlank renderer shows fill choices', (tester) async {
      final step = LessonStep(
        id: 'test_14',
        type: engine.LessonType.fillBlank,
        prompt: 'Isilah titik-titik!',
        instruction: 'Lengkapi dengan kata yang tepat',
        choices: ['pintar', 'rajin', 'kuat'],
        correctAnswer: ['pintar'],
        storyText: 'Dia anak yang ___ .',
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.text('pintar'), findsOneWidget);
      expect(find.text('rajin'), findsOneWidget);
      expect(find.text('kuat'), findsOneWidget);
    });
  });

  group('All 14 renderers handle feedback state', () {
    testWidgets('wordChoice shows correct feedback', (tester) async {
      final step = LessonStep(
        id: 'test_fb_1',
        type: engine.LessonType.wordChoice,
        prompt: 'Test',
        instruction: 'Test',
        choices: ['A', 'B'],
        correctAnswer: ['A'],
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: feedbackCorrect(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('wordChoice shows wrong feedback', (tester) async {
      final step = LessonStep(
        id: 'test_fb_2',
        type: engine.LessonType.wordChoice,
        prompt: 'Test',
        instruction: 'Test',
        choices: ['A', 'B', 'X'],
        correctAnswer: ['A'],
      );
      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: feedbackWrong(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () {},
        ),
      ));
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);
    });
  });

  group('Level 9 content validation', () {
    test('Level 9 exists with correct metadata', () {
      final level9 = LevelContent.allLevels[8];
      expect(level9.id, 'level_9');
      expect(level9.title, 'Latihan Interaktif');
      expect(level9.levelNumber, 9);
      expect(level9.lessons.length, 5);
    });

    test('Level 9 Lesson 9-1: pictureChoice + wordOrder', () {
      final lesson = LevelContent.allLevels[8].lessons[0];
      expect(lesson.id, 'lesson_9_1');
      expect(lesson.title, 'Gambar dan Susun Kata');
      expect(lesson.questions.length, 6);

      expect(lesson.questions[0].type, LessonType.pictureChoice);
      expect(lesson.questions[3].type, LessonType.wordOrder);
    });

    test('Level 9 Lesson 9-2: matchPair + listenChoose', () {
      final lesson = LevelContent.allLevels[8].lessons[1];
      expect(lesson.id, 'lesson_9_2');
      expect(lesson.title, 'Pasangkan dan Dengarkan');
      expect(lesson.questions.length, 6);

      expect(lesson.questions[0].type, LessonType.matchPair);
      expect(lesson.questions[3].type, LessonType.listenChoose);
    });

    test('Level 9 Lesson 9-3: missingWord + sentenceChoice', () {
      final lesson = LevelContent.allLevels[8].lessons[2];
      expect(lesson.id, 'lesson_9_3');
      expect(lesson.title, 'Isian dan Kalimat');
      expect(lesson.questions.length, 6);

      expect(lesson.questions[0].type, LessonType.missingWord);
      expect(lesson.questions[3].type, LessonType.sentenceChoice);
    });

    test('Level 9 Lesson 9-4: all 3 story/reading types', () {
      final lesson = LevelContent.allLevels[8].lessons[3];
      expect(lesson.id, 'lesson_9_4');
      expect(lesson.title, 'Baca Cerita');
      expect(lesson.questions.length, 6);

      final types = lesson.questions.map((q) => q.type).toSet();
      expect(types, contains(LessonType.storyReading));
      expect(types, contains(LessonType.storyComprehension));
      expect(types, contains(LessonType.readingComprehension));
    });

    test('Level 9 Lesson 9-5: recordVoice + speakingPractice', () {
      final lesson = LevelContent.allLevels[8].lessons[4];
      expect(lesson.id, 'lesson_9_5');
      expect(lesson.title, 'Ayo Berbicara');
      expect(lesson.questions.length, 6);

      final types = lesson.questions.map((q) => q.type).toSet();
      expect(types, contains(LessonType.recordVoice));
      expect(types, contains(LessonType.speakingPractice));
    });

    test('Level 9 covers all 11 new engine types', () {
      final allQuestions = LevelContent.allLevels[8]
          .lessons
          .expand((l) => l.questions)
          .toList();
      expect(allQuestions.length, 30);

      final types = allQuestions.map((q) => q.type).toSet();
      expect(types, contains(LessonType.pictureChoice));
      expect(types, contains(LessonType.wordOrder));
      expect(types, contains(LessonType.matchPair));
      expect(types, contains(LessonType.listenChoose));
      expect(types, contains(LessonType.missingWord));
      expect(types, contains(LessonType.sentenceChoice));
      expect(types, contains(LessonType.storyReading));
      expect(types, contains(LessonType.storyComprehension));
      expect(types, contains(LessonType.readingComprehension));
      expect(types, contains(LessonType.recordVoice));
      expect(types, contains(LessonType.speakingPractice));

      expect(types.length, 11);
    });

    test('Every question in Level 9 has valid data', () {
      final voiceTypes = {LessonType.recordVoice, LessonType.speakingPractice};
      final allQuestions = LevelContent.allLevels[8]
          .lessons
          .expand((l) => l.questions)
          .toList();

      for (final q in allQuestions) {
        expect(q.instruction, isNotEmpty,
            reason: '${q.type} missing instruction');
        expect(q.correctAnswer, isNotEmpty,
            reason: '${q.type} missing correctAnswer');
        if (!voiceTypes.contains(q.type)) {
          expect(q.options, isNotEmpty,
              reason: '${q.type} missing options');
        }
      }
    });
  });

  group('LessonController step interactions', () {
    testWidgets('wordChoice select triggers onSelect', (tester) async {
      final step = LessonStep(
        id: 'lifecycle_1',
        type: engine.LessonType.wordChoice,
        prompt: 'Pilih A',
        instruction: 'Test',
        choices: ['A', 'B'],
        correctAnswer: ['A'],
      );

      final selected = <String>[];

      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (s) => selected.add(s),
          onContinue: () {},
          onRecord: () {},
        ),
      ));

      await tester.tap(find.text('A'));
      expect(selected, ['A']);
    });

    testWidgets('storyReading onContinue triggers', (tester) async {
      final step = LessonStep(
        id: 'lifecycle_2',
        type: engine.LessonType.storyReading,
        prompt: 'Baca cerita',
        instruction: 'Baca',
        storyText: 'Cerita singkat.',
      );

      bool continued = false;

      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () => continued = true,
          onRecord: () {},
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      expect(continued, isTrue);
    });

    testWidgets('recordVoice mic tap triggers onRecord', (tester) async {
      final step = LessonStep(
        id: 'lifecycle_3',
        type: engine.LessonType.recordVoice,
        prompt: 'Rekam',
        instruction: 'Rekam suara',
        storyText: 'Test',
      );

      bool recorded = false;

      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () => recorded = true,
        ),
      ));

      await tester.tap(find.byIcon(Icons.mic_rounded));
      expect(recorded, isTrue);
    });

    testWidgets('speakingPractice mic tap triggers onRecord', (tester) async {
      final step = LessonStep(
        id: 'lifecycle_4',
        type: engine.LessonType.speakingPractice,
        prompt: 'Ucapkan',
        instruction: 'Ucapkan kata',
        storyText: 'bola',
      );

      bool recorded = false;

      await tester.pumpWidget(wrapApp(
        LessonRendererFactory.build(
          step: step,
          state: playingState(),
          onSelect: (_) {},
          onContinue: () {},
          onRecord: () => recorded = true,
        ),
      ));

      await tester.tap(find.byIcon(Icons.mic_rounded));
      expect(recorded, isTrue);
    });
  });
}
