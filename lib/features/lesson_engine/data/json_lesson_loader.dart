import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../domain/lesson_step.dart';
import '../domain/lesson_type.dart';

class JsonLessonLoader {
  Future<List<LessonStep>> loadFromAsset(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final stepsJson = data['steps'] as List<dynamic>? ?? [];
      return stepsJson
          .map((s) => LessonStep.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Failed to load lesson JSON: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> loadLessonPackMeta(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      return {
        'id': data['id'] as String? ?? '',
        'title': data['title'] as String? ?? '',
        'world': data['world'] as String? ?? '',
      };
    } catch (e) {
      debugPrint('Failed to load lesson pack meta: $e');
      return {};
    }
  }

  List<LessonStep> parseJsonString(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final stepsJson = data['steps'] as List<dynamic>? ?? [];
      return stepsJson
          .map((s) => LessonStep.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Failed to parse lesson JSON: $e');
      return [];
    }
  }

  bool validateSteps(List<LessonStep> steps) {
    if (steps.isEmpty) return false;
    for (final step in steps) {
      if (step.id.isEmpty) return false;
      if (step.correctAnswer.isEmpty) return false;
      if (step.type != LessonType.storyReading &&
          step.type != LessonType.recordVoice &&
          step.type != LessonType.speakingPractice &&
          step.choices.isEmpty &&
          step.matchPairs == null) {
        return false;
      }
    }
    return true;
  }
}

void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
