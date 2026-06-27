import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../domain/curriculum_catalog.dart';
import '../domain/curriculum_stage.dart';
import '../domain/curriculum_unit.dart';
import '../domain/curriculum_lesson.dart';

class CurriculumRepository {
  CurriculumCatalog? _cachedCatalog;
  bool _loaded = false;

  Future<CurriculumCatalog> loadCurriculum() async {
    if (_loaded && _cachedCatalog != null) return _cachedCatalog!;
    try {
      final jsonString =
          await rootBundle.loadString('assets/curriculum/curriculum_map.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      _cachedCatalog = CurriculumCatalog.fromJson(data);
      _loaded = true;
      return _cachedCatalog!;
    } catch (e) {
      debugPrint('Failed to load curriculum JSON, using fallback: $e');
      _cachedCatalog = _buildFallbackCatalog();
      _loaded = true;
      return _cachedCatalog!;
    }
  }

  Future<CurriculumStage?> getStageById(String id) async {
    final catalog = await loadCurriculum();
    return catalog.getStageById(id);
  }

  Future<CurriculumUnit?> getUnitById(String id) async {
    final catalog = await loadCurriculum();
    return catalog.getUnitById(id);
  }

  Future<CurriculumLesson?> findLessonById(String id) async {
    final catalog = await loadCurriculum();
    return catalog.findLessonById(id);
  }

  Future<CurriculumLesson?> getFirstAvailableLesson() async {
    final catalog = await loadCurriculum();
    return catalog.getFirstAvailableLesson();
  }

  Future<CurriculumLesson?> getNextLesson(String currentLessonId) async {
    final catalog = await loadCurriculum();
    return catalog.getNextLesson(currentLessonId);
  }

  Future<List<CurriculumStage>> getStages() async {
    final catalog = await loadCurriculum();
    return catalog.stages;
  }

  /// Validate the curriculum data integrity.
  Future<List<String>> validate() async {
    final errors = <String>[];
    try {
      final catalog = await loadCurriculum();
      if (catalog.stages.isEmpty) {
        errors.add('No stages found');
        return errors;
      }
      for (final stage in catalog.stages) {
        if (stage.id.isEmpty) errors.add('Stage has empty id');
        if (stage.units.isEmpty) {
          errors.add('Stage ${stage.id} has no units');
        }
        for (final unit in stage.units) {
          if (unit.id.isEmpty) errors.add('Unit has empty id in ${stage.id}');
          if (unit.lessons.isEmpty) {
            errors.add('Unit ${unit.id} has no lessons');
          }
          for (final lesson in unit.lessons) {
            if (lesson.id.isEmpty) {
              errors.add('Lesson has empty id in ${unit.id}');
            }
          }
        }
      }
    } catch (e) {
      errors.add('Failed to validate: $e');
    }
    return errors;
  }

  CurriculumCatalog _buildFallbackCatalog() {
    return CurriculumCatalog(stages: [
      CurriculumStage(
        id: 'stage_01',
        title: 'Pra-Baca',
        subtitle: 'Mengenal huruf dan bunyi',
        gradeBand: 'TK',
        order: 1,
        themeColor: 0xFF58CC02,
        icon: '🍎',
        units: [
          CurriculumUnit(
            id: 'stage_01_unit_01',
            stageId: 'stage_01',
            title: 'Mengenal Huruf',
            subtitle: 'Kenali huruf A sampai Z',
            order: 1,
            lessons: [
              const CurriculumLesson(
                id: 'stage_01_unit_01_lesson_01',
                unitId: 'stage_01_unit_01',
                title: 'Mengenal A',
                subtitle: 'Kenali huruf A',
                order: 1,
                xpReward: 50,
                lessonType: 'wordChoice',
                questionCount: 5,
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}

void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
