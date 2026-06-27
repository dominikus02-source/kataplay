import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataplay_2/features/curriculum/data/curriculum_repository.dart';
import 'package:kataplay_2/features/lesson/domain/lesson.dart';
import 'package:kataplay_2/features/lesson/data/level_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('LevelContent data integrity', () {
    test('allLevels has 8 levels', () {
      expect(LevelContent.allLevels.length, 8);
    });

    test('all level IDs are unique', () {
      final ids = LevelContent.allLevels.map((l) => l.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('all lesson IDs are unique', () {
      final ids = <String>[];
      for (final level in LevelContent.allLevels) {
        ids.addAll(level.lessons.map((l) => l.id));
      }
      expect(ids.toSet().length, ids.length);
    });

    test('every question has correctAnswer in options', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            if (q.options.isNotEmpty) {
              expect(
                q.options.contains(q.correctAnswer),
                isTrue,
                reason:
                    'Level ${level.id} lesson ${lesson.id}: '
                    'correctAnswer "${q.correctAnswer}" not in options ${q.options}',
              );
            }
          }
        }
      }
    });

    test('every lesson has at least 4 questions', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          expect(
            lesson.questions.length >= 4,
            isTrue,
            reason:
                'Level ${level.id} lesson ${lesson.id} has '
                '${lesson.questions.length} questions (min 4)',
          );
        }
      }
    });

    test('all lesson types are supported by the engine', () {
      final supported = LessonType.values;
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            expect(
              supported.contains(q.type),
              isTrue,
              reason:
                  'Unsupported type ${q.type} in level ${level.id} lesson ${lesson.id}',
            );
          }
        }
      }
    });

    test('character values are valid', () {
      const valid = {'zelby', 'hazel', 'alby'};
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          expect(
            valid.contains(lesson.character),
            isTrue,
            reason:
                'Invalid character "${lesson.character}" in ${lesson.id}',
          );
        }
      }
    });

    test('arrangeWord questions have wordParts', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            if (q.type == LessonType.arrangeWord) {
              expect(
                q.wordParts,
                isNotNull,
                reason:
                    'arrangeWord question in ${lesson.id} has no wordParts',
              );
              expect(q.wordParts!.length >= 2, isTrue);
            }
          }
        }
      }
    });

    test('readSentence questions have a sentence', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            if (q.type == LessonType.readSentence) {
              expect(
                q.sentence,
                isNotNull,
                reason:
                    'readSentence question in ${lesson.id} has no sentence',
              );
              expect(q.sentence!.isNotEmpty, isTrue);
            }
          }
        }
      }
    });

    test('matching questions have matchLeft and matchRight', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            if (q.type == LessonType.matching) {
              expect(
                q.matchLeft,
                isNotNull,
                reason:
                    'matching question in ${lesson.id} missing matchLeft',
              );
              expect(
                q.matchRight,
                isNotNull,
                reason:
                    'matching question in ${lesson.id} missing matchRight',
              );
            }
          }
        }
      }
    });

    test('trueFalse questions have Benar/Salah options', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            if (q.type == LessonType.trueFalse) {
              expect(
                q.options.length == 2 &&
                    q.options.contains('Benar') &&
                    q.options.contains('Salah'),
                isTrue,
                reason:
                    'trueFalse question in ${lesson.id} has unexpected options: ${q.options}',
              );
            }
          }
        }
      }
    });

    test('instruction is short (max 50 chars)', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            expect(
              q.instruction.length <= 50,
              isTrue,
              reason:
                  'Instruction too long in ${lesson.id}: "${q.instruction}" '
                  '(${q.instruction.length} chars)',
            );
          }
        }
      }
    });

    test('no placeholder or dummy content', () {
      final badPatterns = ['lorem', 'test', 'sample', 'dummy', 'todo', 'xxx'];
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            final text =
                '${q.instruction} ${q.correctAnswer} ${q.hint ?? ''} '
                '${q.sentence ?? ''} ${q.options.join(' ')}';
            final lower = text.toLowerCase();
            for (final pat in badPatterns) {
              expect(
                lower.contains(pat),
                isFalse,
                reason:
                    'Found placeholder "$pat" in ${lesson.id}',
              );
            }
          }
        }
      }
    });

    test('options have 2-4 choices', () {
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          for (final q in lesson.questions) {
            expect(
              q.options.length >= 2 && q.options.length <= 4,
              isTrue,
              reason:
                  'Options count ${q.options.length} in ${lesson.id}: ${q.options}',
            );
          }
        }
      }
    });

    test('level progression feels gradual (questions increase in complexity)', () {
      // Verify Level 1 has the simplest question types
      final level1Types = <LessonType>{};
      for (final l in LevelContent.allLevels[0].lessons) {
        for (final q in l.questions) {
          level1Types.add(q.type);
        }
      }
      // Level 1 should NOT have readSentence (too complex for letter learning)
      expect(level1Types.contains(LessonType.readSentence), isFalse);
      expect(level1Types.contains(LessonType.imageChoice), isTrue);
      expect(level1Types.contains(LessonType.wordChoice), isTrue);

      // Level 5+6 should have readSentence
      final level5Types = <LessonType>{};
      for (final l in LevelContent.allLevels[4].lessons) {
        for (final q in l.questions) {
          level5Types.add(q.type);
        }
      }
      expect(level5Types.contains(LessonType.readSentence), isTrue);
    });
  });

  group('Question count per lesson', () {
    test('Level 1 has expected lessons', () {
      final level = LevelContent.allLevels[0];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 5);
    });

    test('Level 2 has expected lessons', () {
      final level = LevelContent.allLevels[1];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 4);
    });

    test('Level 3 has expected lessons', () {
      final level = LevelContent.allLevels[2];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 5);
    });

    test('Level 4 has expected lessons', () {
      final level = LevelContent.allLevels[3];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 4);
    });

    test('Level 5 has expected lessons', () {
      final level = LevelContent.allLevels[4];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 4);
      expect(level.lessons[2].questions.length, 4);
    });

    test('Level 6 has expected lessons', () {
      final level = LevelContent.allLevels[5];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 5);
    });

    test('Level 7 has expected lessons', () {
      final level = LevelContent.allLevels[6];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 4);
    });

    test('Level 8 has expected lessons', () {
      final level = LevelContent.allLevels[7];
      expect(level.lessons.length, 3);
      expect(level.lessons[0].questions.length, 5);
      expect(level.lessons[1].questions.length, 5);
      expect(level.lessons[2].questions.length, 4);
    });

    test('total question count', () {
      int total = 0;
      for (final level in LevelContent.allLevels) {
        for (final lesson in level.lessons) {
          total += lesson.questions.length;
        }
      }
      expect(total, greaterThan(80));
      expect(total, 114);
    });
  });

  group('Curriculum JSON data integrity', () {
    late CurriculumRepository repo;
    late dynamic catalog;

    setUp(() async {
      repo = CurriculumRepository();
      catalog = await repo.loadCurriculum();
    });

    test('loads 7 stages', () {
      expect(catalog.stages.length, 7);
    });

    test('all stages have unique IDs', () {
      final ids = catalog.stages.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
      for (final id in ids) {
        expect(id.isNotEmpty, isTrue);
      }
    });

    test('all stages have units', () {
      for (final stage in catalog.stages) {
        expect(stage.units.isNotEmpty, isTrue,
            reason: 'Stage ${stage.id} has no units');
      }
    });

    test('every stage has exactly 6 units', () {
      for (final stage in catalog.stages) {
        expect(stage.units.length, 6,
            reason: 'Stage ${stage.id} has ${stage.units.length} units, expected 6');
      }
    });

    test('every unit has exactly 3 lessons', () {
      for (final stage in catalog.stages) {
        for (final unit in stage.units) {
          expect(unit.lessons.length, 3,
              reason: 'Unit ${unit.id} has ${unit.lessons.length} lessons, expected 3');
        }
      }
    });

    test('total lesson count is 126', () {
      expect(catalog.totalLessons, 126);
    });

    test('all lesson IDs are unique across curriculum', () {
      final ids = <String>[];
      for (final stage in catalog.stages) {
        for (final unit in stage.units) {
          for (final lesson in unit.lessons) {
            ids.add(lesson.id);
          }
        }
      }
      expect(ids.toSet().length, ids.length);
    });

    test('first lesson is found by ID', () async {
      final lesson = await repo.findLessonById('stage_01_unit_01_lesson_01');
      expect(lesson, isNotNull);
      expect(lesson!.title, 'Mengenal A');
    });

    test('getNextLesson returns next lesson in sequence', () async {
      final next = await repo.getNextLesson('stage_01_unit_01_lesson_01');
      expect(next, isNotNull);
      expect(next!.id, 'stage_01_unit_01_lesson_02');
    });

    test('getNextLesson returns unit boundary lesson', () async {
      final next = await repo.getNextLesson('stage_01_unit_01_lesson_03');
      expect(next, isNotNull);
      expect(next!.id, 'stage_01_unit_02_lesson_01');
    });

    test('getNextLesson returns stage boundary lesson', () async {
      final next = await repo.getNextLesson('stage_01_unit_06_lesson_03');
      expect(next, isNotNull);
      expect(next!.id, 'stage_02_unit_01_lesson_01');
    });

    test('getNextLesson returns null for last lesson', () async {
      final next = await repo.getNextLesson('stage_07_unit_06_lesson_03');
      expect(next, isNull);
    });

    test('every lesson has a valid assetPath or is coming-soon', () async {
      final jsonString = await rootBundle.loadString('assets/curriculum/curriculum_map.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      int withPath = 0;
      int withoutPath = 0;
      for (final stage in data['stages'] as List<dynamic>) {
        for (final unit in stage['units'] as List<dynamic>) {
          for (final lesson in unit['lessons'] as List<dynamic>) {
            if (lesson['assetPath'] != null && (lesson['assetPath'] as String).isNotEmpty) {
              withPath++;
            } else {
              withoutPath++;
            }
          }
        }
      }
      // All 126 lessons now have asset paths
      expect(withPath, 126);
      expect(withoutPath, 0);
    });

    test('loadCurriculum has inline fallback', () async {
      // The repository should never throw, even if JSON fails
      final tempRepo = CurriculumRepository();
      final result = await tempRepo.loadCurriculum();
      expect(result.stages, isNotEmpty);
    });
  });
}
