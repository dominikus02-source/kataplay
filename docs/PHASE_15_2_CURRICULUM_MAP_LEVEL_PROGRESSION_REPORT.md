# Phase 15.2 — Curriculum Map + Level Progression

## Goal
- Build a scalable curriculum catalog with 7 stages × 6 units × 3 lessons (= 126 lesson metadata entries)
- Load curriculum from `assets/curriculum/curriculum_map.json` with typed domain models
- Connect the Lesson Engine to load content by `lessonId`
- Update the Belajar / Learning Path screen to render from the curriculum catalog with progression/unlock logic

## What Was Done

### 1. Domain Models (`lib/features/curriculum/domain/`)
- `CurriculumLesson` — single lesson metadata (id, unitId, title, order, xpReward, lessonType, questionCount, assetPath)
- `CurriculumUnit` — group of up to 3 lessons (id, stageId, title, order)
- `CurriculumStage` — one grade/school-year level (id, title, gradeBand, order, themeColor, icon, 6 units)
- `CurriculumCatalog` — top-level container with `findLessonById()`, `getNextLesson()`, `getFirstAvailableLesson()`
- `UserCurriculumProgress` — tracks completed/in-progress lesson IDs

### 2. Curriculum Data (`assets/curriculum/curriculum_map.json`)
- 7 stages: Pra-Baca / TK, Kelas 1–6
- 6 units per stage (42 units total)
- 3 lessons per unit (126 lessons total)
- Each lesson has: unique ID, title, order, estimatedMinutes, xpReward, lessonType, requiredCompletedLessons
- First 3 lessons of Stage 1 have `assetPath` pointing to real JSON content files
- Remaining 123 lessons are marked as "coming soon" (no `assetPath`)
- Added `id` fields to stages and units for consistent referencing

### 3. Lesson Content JSONs (`assets/lessons/stage_01/unit_01/`)
- `lesson_001.json` — 5 wordChoice questions (Mengenal A)
- `lesson_002.json` — 5 questions: wordChoice + pictureChoice + trueFalse (Huruf B dan C)
- `lesson_003.json` — 5 questions: wordChoice + imageMatch + trueFalse (Pilih Huruf yang Sama)

### 4. CurriculumRepository (`lib/features/curriculum/data/curriculum_repository.dart`)
- Loads curriculum JSON via `rootBundle.loadString()`
- Parses into typed domain models (CurriculumStage → CurriculumUnit → CurriculumLesson)
- Inline fallback catalog with 1 stage + 1 unit + 1 lesson if JSON load fails
- Validates data integrity on load
- Lookup methods: `getStageById()`, `getUnitById()`, `findLessonById()`, `getNextLesson()`, `getFirstAvailableLesson()`

### 5. CurriculumProvider (`lib/features/curriculum/application/curriculum_provider.dart`)
- `CurriculumState` — holds catalog + loading/error state + unlock logic
- `curriculumProvider` — `NotifierProvider` that loads catalog on construction
- Unlock logic: `isLessonUnlocked()`, `isUnitUnlocked()`, `isStageUnlocked()` using `requiredCompletedLessons` and sequential progression

### 6. Lesson Engine Integration
- `LessonController.loadLessonById(String lessonId, CurriculumRepository)` — new method that resolves assetPath from curriculum catalog and loads lesson steps
- `LessonEngineScreen` — new `lessonId` parameter, uses `loadLessonById` when present
- Router (`/lesson-engine`) — passes `lessonId` in route extras alongside existing `levelIndex`/`assetPath`

### 7. Belajar / Learning Path Screen (`lib/features/learning_path/presentation/screens/learning_path_screen.dart`)
- Reads from `curriculumProvider` instead of deprecated `LevelContent` when catalog is loaded
- Falls back to legacy `_buildLegacyLevelPath()` if catalog is null
- Shows stage titles (Pra-Baca / TK, Kelas 1–6) as level path cards
- Progress bar shows completed / total lessons across all stages
- Stage unlock: all lessons in previous stage must be completed
- Tap navigates to first uncompleted lesson in that stage via `lessonId`
- Loading state shows "Memuat petualangan..." while catalog loads

### 8. Test Infrastructure
- `test/helpers/pump_kataplay_app.dart` — overrides `curriculumRepositoryProvider` with `_TestCurriculumRepository` returning a stable 7-stage mock catalog
- All widget tests use the mock catalog for deterministic rendering

### 9. Tests Added/Updated
- **Curriculum JSON data integrity** (14 tests):
  - Loads 7 stages
  - All stages have unique, non-empty IDs
  - All stages have units
  - Every stage has exactly 6 units (42 total)
  - Every unit has exactly 3 lessons (126 total)
  - Total lesson count = 126
  - All lesson IDs unique across curriculum
  - `findLessonById()` finds lesson_001 by ID
  - `getNextLesson()` returns sequential, unit-boundary, and stage-boundary lessons
  - `getNextLesson()` returns null for last lesson
  - Asset path distribution: 3 have paths, 123 are coming-soon
  - Inline fallback works when JSON fails to load
- **Widget tests updated** (3 tests):
  - Updated expectations from old level titles ("Mengenal Huruf") to stage titles ("Pra-Baca / TK", "Kelas 1"–"Kelas 6")

## Verification Results
- `flutter analyze lib/` — 0 errors, 0 warnings, 3 info-level lints (pre-existing)
- `flutter test` — 52/52 pass (38 data + 14 widget)
- `flutter build apk --release` — ✅ builds (81.0MB)

## Key Decisions
- **JSON catalog approach**: curriculum_map.json is a standalone metadata file; lesson content JSONs are separate per-lesson files. Adding new lessons requires only creating a JSON file and updating the catalog — no code changes.
- **Progression rule**: sequential — complete lesson N to unlock lesson N+1, complete all lessons in a unit to unlock next unit, complete all units in a stage to unlock next stage. The `requiredCompletedLessons` field in the JSON controls per-lesson prerequisites.
- **Inline fallback**: both the CurriculumRepository and LessonController have fallback data, preventing infinite loading.
- **Test mock**: the test helper overrides the curriculum repository provider with a synchronous mock, avoiding async asset loading in widget tests.

## Files Changed/Added
```
ADDED:
  lib/features/curriculum/domain/curriculum_lesson.dart
  lib/features/curriculum/domain/curriculum_unit.dart
  lib/features/curriculum/domain/curriculum_stage.dart
  lib/features/curriculum/domain/curriculum_catalog.dart
  lib/features/curriculum/domain/user_curriculum_progress.dart
  lib/features/curriculum/data/curriculum_repository.dart
  lib/features/curriculum/application/curriculum_provider.dart
  assets/curriculum/curriculum_map.json
  assets/lessons/stage_01/unit_01/lesson_001.json
  assets/lessons/stage_01/unit_01/lesson_002.json
  assets/lessons/stage_01/unit_01/lesson_003.json
  docs/PHASE_15_2_CURRICULUM_MAP_LEVEL_PROGRESSION_REPORT.md

MODIFIED:
  pubspec.yaml                                — added assets/curriculum/ and assets/lessons/
  lib/features/lesson_engine/application/lesson_controller.dart — added loadLessonById()
  lib/features/lesson_engine/presentation/lesson_engine_screen.dart — added lessonId param
  lib/app/router/router.dart                 — added lessonId to /lesson-engine extras
  lib/features/learning_path/presentation/screens/learning_path_screen.dart — curriculum integration
  test/data_test.dart                        — added 14 curriculum data tests
  test/widget_test.dart                      — updated 3 learning path expectations
  test/helpers/pump_kataplay_app.dart        — added mock curriculum provider + test catalog
```

## Next Steps (Future Phases)
1. Create lesson content JSONs for remaining 123 lessons (bulk generation)
2. Add per-stage completion badges/awards
3. Implement unit-level detail view (showing 3 lessons per unit)
4. Add "coming soon" placeholder screens for lessons without assetPath
5. Track curriculum-specific progress in Firestore
