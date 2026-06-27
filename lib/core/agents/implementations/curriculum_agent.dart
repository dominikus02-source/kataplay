import '../agent.dart';
import '../types.dart';
import '../../constants/app_constants.dart';
import '../../../features/lesson/data/level_content.dart';

class CurriculumAgent extends KataPlayAgent<CurriculumSpec, Map<String, dynamic>> {
  @override
  String get name => 'curriculum';

  @override
  Future<Map<String, dynamic>> process(CurriculumSpec input) async {
    final levels = LevelContent.allLevels;
    final nextLevelIndex = _determineNextLevel(input);
    final nextLessonIndex = _determineNextLesson(input, nextLevelIndex);
    final reviewSkills = _getReviewSkills(input);

    return {
      'nextLevelIndex': nextLevelIndex,
      'nextLessonIndex': nextLessonIndex,
      'action': nextLevelIndex >= levels.length ? 'completed' : 'next_lesson',
      'reviewSkills': reviewSkills,
      'masteryThreshold': AppConstants.xpPerLevel,
      'estimatedMastery': input.masteryScore,
    };
  }

  int _determineNextLevel(CurriculumSpec input) {
    if (input.masteryScore >= 0.8) {
      return (input.currentLevelIndex + 1).clamp(0, AppConstants.maxLevels);
    }
    return input.currentLevelIndex;
  }

  int _determineNextLesson(CurriculumSpec input, int levelIndex) {
    if (levelIndex >= LevelContent.totalLevels) return 0;
    final level = LevelContent.allLevels[levelIndex];
    for (int i = 0; i < level.lessons.length; i++) {
      if (!input.completedSkills.contains(level.lessons[i].id)) return i;
    }
    return 0;
  }

  List<String> _getReviewSkills(CurriculumSpec input) {
    if (input.masteryScore < 0.6 && input.completedSkills.length > 3) {
      return input.completedSkills.take(3).toList();
    }
    return [];
  }
}
