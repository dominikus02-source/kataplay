import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/curriculum_repository.dart';
import '../domain/curriculum_catalog.dart';
import '../domain/curriculum_stage.dart';
import '../domain/curriculum_unit.dart';
import '../domain/curriculum_lesson.dart';

final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  return CurriculumRepository();
});

class CurriculumState {
  final CurriculumCatalog? catalog;
  final bool isLoading;
  final String? error;

  const CurriculumState({
    this.catalog,
    this.isLoading = true,
    this.error,
  });

  CurriculumState copyWith({
    CurriculumCatalog? catalog,
    bool? isLoading,
    String? error,
  }) {
    return CurriculumState(
      catalog: catalog ?? this.catalog,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool isLessonUnlocked(CurriculumLesson lesson, List<String> completedIds) {
    if (lesson.requiredCompletedLessons == 0) return true;
    return completedIds.length >= lesson.requiredCompletedLessons;
  }

  bool isUnitUnlocked(CurriculumUnit unit, List<String> completedIds) {
    if (unit.order == 1) return true;
    return _areAllLessonsInPreviousUnitCompleted(unit, completedIds);
  }

  bool isStageUnlocked(CurriculumStage stage, List<String> completedIds) {
    if (stage.order == 1) return true;
    return _areAllUnitsInPreviousStageCompleted(stage, completedIds);
  }

  bool _areAllLessonsInPreviousUnitCompleted(
      CurriculumUnit unit, List<String> completedIds) {
    if (catalog == null) return false;
    for (final stage in catalog!.stages) {
      for (final u in stage.units) {
        if (u.id == unit.id) {
          final prevUnitIndex = u.order - 2;
          if (prevUnitIndex < 0) return true;
          final prevUnit = stage.units
              .where((x) => x.order == u.order - 1)
              .firstOrNull;
          if (prevUnit == null) return true;
          return prevUnit.lessons
              .every((l) => completedIds.contains(l.id));
        }
      }
    }
    return false;
  }

  bool _areAllUnitsInPreviousStageCompleted(
      CurriculumStage stage, List<String> completedIds) {
    if (catalog == null) return false;
    final prevStageIndex = stage.order - 2;
    if (prevStageIndex < 0) return true;
    final prevStage = catalog!.stages
        .where((s) => s.order == stage.order - 1)
        .firstOrNull;
    if (prevStage == null) return true;
    for (final unit in prevStage.units) {
      if (!unit.lessons.every((l) => completedIds.contains(l.id))) {
        return false;
      }
    }
    return true;
  }

  int get totalLessons {
    if (catalog == null) return 0;
    int count = 0;
    for (final stage in catalog!.stages) {
      for (final unit in stage.units) {
        count += unit.lessons.length;
      }
    }
    return count;
  }

  int get totalStages => catalog?.stages.length ?? 0;
}

class CurriculumNotifier extends Notifier<CurriculumState> {
  @override
  CurriculumState build() {
    _load();
    return const CurriculumState();
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(curriculumRepositoryProvider);
      final catalog = await repo.loadCurriculum();
      state = CurriculumState(catalog: catalog, isLoading: false);
    } catch (e) {
      state = CurriculumState(
        isLoading: false,
        error: 'Failed to load curriculum: $e',
      );
    }
  }

  Future<void> reload() async {
    state = const CurriculumState(isLoading: true);
    await _load();
  }
}

final curriculumProvider =
    NotifierProvider<CurriculumNotifier, CurriculumState>(
  CurriculumNotifier.new,
);
