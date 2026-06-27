import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lesson_controller.dart';

final lessonEngineProvider = Provider<LessonController>((ref) {
  return LessonController();
});
