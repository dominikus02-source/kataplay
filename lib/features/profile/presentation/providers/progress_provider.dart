import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../data/models/user_progress.dart';
import '../../data/repositories/avatar_repository.dart';
import '../../../../features/lesson/data/level_content.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/storage_keys.dart';

class ProgressProvider extends ChangeNotifier {
  UserProgress _progress = const UserProgress();
  Set<String> _newlyAwardedBadges = {};

  UserProgress get progress => _progress;
  Set<String> get newlyAwardedBadges => _newlyAwardedBadges;

  int get xp => _progress.xp;
  int get streak => _progress.streak;
  String get childName => _progress.childName;
  int get currentLevelIndex => _progress.currentLevelIndex;
  String get selectedAvatarId => _progress.selectedAvatarId;
  String get selectedAvatarPath => _progress.selectedAvatarPath;

  int get levelProgress => xp ~/ AppConstants.xpPerLevel;
  int get xpInCurrentLevel => xp % AppConstants.xpPerLevel;
  int get xpForNextLevel => AppConstants.xpPerLevel - xpInCurrentLevel;
  int get levelNumber => levelProgress + 1;

  bool isLessonCompleted(String lessonId) =>
      _progress.isLessonCompleted(lessonId);

  bool isLevelUnlocked(int levelIndex) {
    return _progress.isLevelUnlocked(
        levelIndex, LevelContent.totalLevels);
  }

  Future<Box> _getBox() async => await Hive.openBox('kataplay_data');

  void completeLesson(String lessonId, int xpEarned) {
    _newlyAwardedBadges = {};
    final now = DateTime.now();
    final updatedCompleted = Set<String>.from(_progress.completedLessonIds)
      ..add(lessonId);

    final newStreak = _progress.calculateStreak(now);
    final newXp = _progress.xp + xpEarned;
    final isNewLevelCompleted =
        (newXp ~/ AppConstants.xpPerLevel) > (_progress.xp ~/ AppConstants.xpPerLevel);

    _progress = _progress.copyWith(
      xp: newXp,
      streak: newStreak,
      completedLessonIds: updatedCompleted,
      lastPlayedDate: now,
      currentLevelIndex: isNewLevelCompleted
          ? (_progress.currentLevelIndex + 1)
          : _progress.currentLevelIndex,
    );

    _awardBadges();
    _saveToHive();
    notifyListeners();
  }

  void _awardBadges() {
    final oldCount = _progress.collectedBadges.length;
    final badges = Set<String>.from(_progress.collectedBadges);

    final levels = LevelContent.allLevels;
    for (final level in levels) {
      final levelComplete =
          level.lessons.every((l) => _progress.isLessonCompleted(l.id));
      if (levelComplete) {
        final badgeId = '${level.id}_complete';
        if (!badges.contains(badgeId)) badges.add(badgeId);
      }
    }

    if (_progress.xp >= AppConstants.xpBadge100 &&
        !badges.contains('xp_100')) {
      badges.add('xp_100');
    }
    if (_progress.xp >= AppConstants.xpBadge500 &&
        !badges.contains('xp_500')) {
      badges.add('xp_500');
    }
    if (_progress.xp >= AppConstants.xpBadge1000 &&
        !badges.contains('xp_1000')) {
      badges.add('xp_1000');
    }

    if (_progress.streak >= AppConstants.streakMinForBadge &&
        !badges.contains('streak_3')) {
      badges.add('streak_3');
    }
    if (_progress.streak >= AppConstants.streakBadgeThreshold &&
        !badges.contains('streak_7')) {
      badges.add('streak_7');
    }

    final allLessonsCompleted = levels.every((l) =>
        l.lessons.every((lesson) => _progress.isLessonCompleted(lesson.id)));
    if (allLessonsCompleted && !badges.contains('all_complete')) {
      badges.add('all_complete');
    }

    if (badges.length != oldCount) {
      _newlyAwardedBadges = badges.difference(_progress.collectedBadges);
      _progress = _progress.copyWith(collectedBadges: badges);
    } else {
      _newlyAwardedBadges = {};
    }
  }

  void addBadge(String badgeId) {
    final updated = Set<String>.from(_progress.collectedBadges)..add(badgeId);
    _progress = _progress.copyWith(collectedBadges: updated);
    _saveToHive();
    notifyListeners();
  }

  void setChildName(String name) {
    _progress = _progress.copyWith(childName: name);
    _saveToHive();
    notifyListeners();
  }

  void setSelectedAvatar(String id, String assetPath) {
    _progress = _progress.copyWith(
      selectedAvatarId: id,
      selectedAvatarPath: assetPath,
    );
    _saveToHive();
    notifyListeners();
  }

  double get lessonCompletionRatio {
    if (_progress.completedLessonIds.isEmpty) return 0;
    final totalLessons = LevelContent.totalLessons;
    if (totalLessons <= 0) return 0;
    return _progress.completedLessonIds.length / totalLessons;
  }

  int get completedLessonCount => _progress.completedLessonIds.length;

  Future<void> loadFromHive() async {
    try {
      final box = await _getBox();
      _progress = UserProgress.fromHive(box);

      final avatar = AvatarRepository.getById(_progress.selectedAvatarId);
      if (avatar != null &&
          avatar.assetPath != _progress.selectedAvatarPath) {
        _progress = _progress.copyWith(
          selectedAvatarId: avatar.id,
          selectedAvatarPath: avatar.assetPath,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('loadFromHive error: $e');
    }
  }

  Future<void> _saveToHive() async {
    try {
      final box = await _getBox();
      await _progress.saveToHive(box);
    } catch (_) {}
  }

  Future<void> resetProgress() async {
    try {
      final box = await _getBox();
      await box.delete(StorageKeys.xp);
      await box.delete(StorageKeys.streak);
      await box.delete(StorageKeys.currentLevelIndex);
      await box.delete(StorageKeys.completedLessonIds);
      await box.delete(StorageKeys.collectedBadges);
      await box.delete(StorageKeys.lastPlayedDate);
      _progress = const UserProgress();
      _newlyAwardedBadges = {};
      notifyListeners();
    } catch (_) {}
  }
}
