import 'json_lesson_loader.dart';
import '../domain/lesson_step.dart';

class LessonRepository {
  final JsonLessonLoader _loader;

  LessonRepository({JsonLessonLoader? loader})
      : _loader = loader ?? JsonLessonLoader();

  List<LessonStep> _cachedSteps = [];
  bool _loaded = false;

  Future<List<LessonStep>> loadSampleLessonPack() async {
    if (_loaded) return _cachedSteps;
    final steps = await _loader.loadFromAsset(
      'assets/sample_lessons/sample_lesson_pack.json',
    );
    _cachedSteps = steps;
    _loaded = true;
    return steps;
  }

  Future<List<LessonStep>> loadCustomPack(String assetPath) async {
    return _loader.loadFromAsset(assetPath);
  }

  List<LessonStep> getCachedSteps() => _cachedSteps;

  bool isLoaded() => _loaded;

  void clearCache() {
    _cachedSteps = [];
    _loaded = false;
  }

  LessonStep? getStepById(String id) {
    try {
      return _cachedSteps.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
