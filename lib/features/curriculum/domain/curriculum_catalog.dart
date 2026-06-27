import 'curriculum_stage.dart';
import 'curriculum_unit.dart';
import 'curriculum_lesson.dart';

class CurriculumCatalog {
  final List<CurriculumStage> stages;

  const CurriculumCatalog({this.stages = const []});

  int get totalStages => stages.length;
  int get totalUnits => stages.fold(0, (sum, s) => sum + s.unitCount);
  int get totalLessons => stages.fold(0, (sum, s) => sum + s.lessonCount);
  int get totalXp => stages.fold(0, (sum, s) => sum + s.totalXp);

  CurriculumStage? getStageById(String id) {
    try {
      return stages.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  CurriculumUnit? getUnitById(String id) {
    for (final stage in stages) {
      for (final unit in stage.units) {
        if (unit.id == id) return unit;
      }
    }
    return null;
  }

  CurriculumStage? getLessonById(String id) {
    for (final stage in stages) {
      for (final unit in stage.units) {
        for (final lesson in unit.lessons) {
          if (lesson.id == id) return stage;
        }
      }
    }
    return null;
  }

  CurriculumLesson? findLessonById(String id) {
    for (final stage in stages) {
      for (final unit in stage.units) {
        for (final lesson in unit.lessons) {
          if (lesson.id == id) return lesson;
        }
      }
    }
    return null;
  }

  CurriculumLesson? getFirstAvailableLesson() {
    if (stages.isEmpty) return null;
    final firstUnit = stages.first.units;
    if (firstUnit.isEmpty) return null;
    return firstUnit.first.lessons.firstOrNull;
  }

  CurriculumLesson? getNextLesson(String currentLessonId) {
    CurriculumLesson? found;
    CurriculumStage? foundStage;
    CurriculumUnit? foundUnit;
    int stageIndex = -1;
    int unitIndex = -1;
    int lessonIndex = -1;

    for (int s = 0; s < stages.length; s++) {
      for (int u = 0; u < stages[s].units.length; u++) {
        for (int l = 0; l < stages[s].units[u].lessons.length; l++) {
          if (stages[s].units[u].lessons[l].id == currentLessonId) {
            found = stages[s].units[u].lessons[l];
            foundStage = stages[s];
            foundUnit = stages[s].units[u];
            stageIndex = s;
            unitIndex = u;
            lessonIndex = l;
          }
        }
      }
    }

    if (found == null) return null;

    if (lessonIndex + 1 < foundUnit!.lessons.length) {
      return foundUnit.lessons[lessonIndex + 1];
    }
    if (unitIndex + 1 < foundStage!.units.length) {
      return foundStage.units[unitIndex + 1].lessons.firstOrNull;
    }
    if (stageIndex + 1 < stages.length) {
      return stages[stageIndex + 1].units.first.lessons.firstOrNull;
    }
    return null;
  }

  factory CurriculumCatalog.fromJson(Map<String, dynamic> json) {
    final stagesJson = json['stages'] as List<dynamic>? ?? [];
    return CurriculumCatalog(
      stages: stagesJson
          .map((s) => CurriculumStage.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'stages': stages.map((s) => s.toJson()).toList(),
      };
}
