class UserCurriculumProgress {
  final List<String> completedLessonIds;
  final String? currentLessonId;
  final String? currentUnitId;
  final String? currentStageId;
  final int totalXp;
  final int streak;

  const UserCurriculumProgress({
    this.completedLessonIds = const [],
    this.currentLessonId,
    this.currentUnitId,
    this.currentStageId,
    this.totalXp = 0,
    this.streak = 0,
  });

  bool isLessonCompleted(String lessonId) =>
      completedLessonIds.contains(lessonId);

  bool isLessonUnlocked(String lessonId, String? previousLessonId) {
    if (completedLessonIds.isEmpty) return true;
    if (previousLessonId == null) return true;
    return completedLessonIds.contains(previousLessonId);
  }

  int get completedCount => completedLessonIds.length;

  UserCurriculumProgress copyWith({
    List<String>? completedLessonIds,
    String? currentLessonId,
    String? currentUnitId,
    String? currentStageId,
    int? totalXp,
    int? streak,
  }) {
    return UserCurriculumProgress(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      currentUnitId: currentUnitId ?? this.currentUnitId,
      currentStageId: currentStageId ?? this.currentStageId,
      totalXp: totalXp ?? this.totalXp,
      streak: streak ?? this.streak,
    );
  }
}
