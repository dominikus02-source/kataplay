class FirebaseAuthService {
  Future<void> saveProgressToFirestore({
    required String userId,
    required int xp,
    required int streak,
    required Set<String> completedLessonIds,
    required Set<String> collectedBadges,
    required int currentLevelIndex,
    required String selectedAvatarId,
  }) async {
  }

  Future<Map<String, dynamic>?> loadProgressFromFirestore(String userId) async {
    return null;
  }
}
