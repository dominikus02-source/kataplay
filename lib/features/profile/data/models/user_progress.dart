import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/storage_keys.dart';

class UserProgress {
  final int xp;
  final int streak;
  final String childName;
  final Set<String> completedLessonIds;
  final Set<String> collectedBadges;
  final DateTime? lastPlayedDate;
  final int currentLevelIndex;
  final String selectedAvatarId;
  final String selectedAvatarPath;

  const UserProgress({
    this.xp = 0,
    this.streak = 0,
    this.childName = '',
    this.completedLessonIds = const {},
    this.collectedBadges = const {},
    this.lastPlayedDate,
    this.currentLevelIndex = 0,
    this.selectedAvatarId = AppConstants.defaultAvatarId,
    this.selectedAvatarPath = AppConstants.defaultAvatarPath,
  });

  UserProgress copyWith({
    int? xp,
    int? streak,
    String? childName,
    Set<String>? completedLessonIds,
    Set<String>? collectedBadges,
    DateTime? lastPlayedDate,
    int? currentLevelIndex,
    String? selectedAvatarId,
    String? selectedAvatarPath,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      childName: childName ?? this.childName,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      collectedBadges: collectedBadges ?? this.collectedBadges,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      selectedAvatarId: selectedAvatarId ?? this.selectedAvatarId,
      selectedAvatarPath: selectedAvatarPath ?? this.selectedAvatarPath,
    );
  }

  int get levelProgress => xp ~/ AppConstants.xpPerLevel;
  int get xpInCurrentLevel => xp % AppConstants.xpPerLevel;
  int get xpForNextLevel => AppConstants.xpPerLevel - xpInCurrentLevel;
  int get levelNumber => levelProgress + 1;

  bool isLessonCompleted(String lessonId) =>
      completedLessonIds.contains(lessonId);

  bool isLevelUnlocked(int levelIndex, int totalLevels) {
    if (levelIndex == 0) return true;
    if (levelIndex >= totalLevels) return false;
    return currentLevelIndex >= levelIndex;
  }

  int calculateStreak(DateTime now) {
    if (lastPlayedDate == null) return 1;
    final diff = now.difference(lastPlayedDate!).inDays;
    if (diff == 0) return streak;
    if (diff == 1) return streak + 1;
    return 1;
  }

  factory UserProgress.fromHive(Box box) {
    return UserProgress(
      childName: box.get(StorageKeys.childName) ?? '',
      selectedAvatarId: box.get(StorageKeys.selectedAvatarId) ??
          AppConstants.defaultAvatarId,
      selectedAvatarPath: box.get(StorageKeys.selectedAvatarPath) ??
          AppConstants.defaultAvatarPath,
      xp: box.get(StorageKeys.xp) ?? 0,
      streak: box.get(StorageKeys.streak) ?? 0,
      currentLevelIndex: box.get(StorageKeys.currentLevelIndex) ?? 0,
      completedLessonIds: Set<String>.from(
        (box.get(StorageKeys.completedLessonIds) ?? <String>[]) as List,
      ),
      collectedBadges: Set<String>.from(
        (box.get(StorageKeys.collectedBadges) ?? <String>[]) as List,
      ),
      lastPlayedDate: _parseDate(box.get(StorageKeys.lastPlayedDate)),
    );
  }

  Future<void> saveToHive(Box box) async {
    await box.put(StorageKeys.childName, childName);
    await box.put(StorageKeys.selectedAvatarId, selectedAvatarId);
    await box.put(StorageKeys.selectedAvatarPath, selectedAvatarPath);
    await box.put(StorageKeys.xp, xp);
    await box.put(StorageKeys.streak, streak);
    await box.put(StorageKeys.currentLevelIndex, currentLevelIndex);
    await box.put(StorageKeys.completedLessonIds, completedLessonIds.toList());
    await box.put(StorageKeys.collectedBadges, collectedBadges.toList());
    if (lastPlayedDate != null) {
      await box.put(
          StorageKeys.lastPlayedDate, lastPlayedDate!.toIso8601String());
    }
  }

  static DateTime? _parseDate(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
