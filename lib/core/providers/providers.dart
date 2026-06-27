import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../features/profile/data/models/user_progress.dart';
import '../../features/profile/data/repositories/avatar_repository.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/lesson/data/level_content.dart';
import '../../features/curriculum/application/curriculum_provider.dart';
import '../../features/curriculum/domain/curriculum_stage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/storage_keys.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../services/auth_service.dart';
import '../services/app_mode.dart';
import '../services/firebase_auth_service.dart';
import '../agents/orchestrator/lesson_orchestrator.dart';

final appModeProvider = Provider<AppModeConfig>((ref) => const AppModeConfig());

final firebaseAuthServiceProvider = Provider<FirebaseAuthService?>((ref) {
  try {
    return FirebaseAuthService();
  } catch (_) {
    return null;
  }
});

final authServiceProvider = Provider<AuthService>((ref) {
  final config = ref.watch(appModeProvider);
  final profileRepo = ProfileRepository();
  final firebaseAuth = ref.watch(firebaseAuthServiceProvider);
  return AuthService(
    profileRepo: profileRepo,
    appMode: config,
    firebaseAuth: firebaseAuth,
  );
});

class ProgressState {
  final UserProgress progress;
  final Set<String> newlyAwardedBadges;
  final bool isLoading;

  const ProgressState({
    this.progress = const UserProgress(),
    this.newlyAwardedBadges = const {},
    this.isLoading = true,
  });

  ProgressState copyWith({
    UserProgress? progress,
    Set<String>? newlyAwardedBadges,
    bool? isLoading,
  }) {
    return ProgressState(
      progress: progress ?? this.progress,
      newlyAwardedBadges: newlyAwardedBadges ?? this.newlyAwardedBadges,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get xp => progress.xp;
  int get streak => progress.streak;
  String get childName => progress.childName;
  int get currentLevelIndex => progress.currentLevelIndex;
  String get selectedAvatarId => progress.selectedAvatarId;
  String get selectedAvatarPath => progress.selectedAvatarPath;
  int get levelProgress => xp ~/ AppConstants.xpPerLevel;
  int get xpInCurrentLevel => xp % AppConstants.xpPerLevel;
  int get xpForNextLevel => AppConstants.xpPerLevel - xpInCurrentLevel;
  int get levelNumber => levelProgress + 1;
  double get lessonCompletionRatio {
    if (progress.completedLessonIds.isEmpty) return 0;
    final totalLessons = LevelContent.totalLessons;
    if (totalLessons <= 0) return 0;
    return progress.completedLessonIds.length / totalLessons;
  }
  int get completedLessonCount => progress.completedLessonIds.length;

  bool isLessonCompleted(String lessonId) =>
      progress.isLessonCompleted(lessonId);
  bool isLevelUnlocked(int levelIndex) =>
      progress.isLevelUnlocked(levelIndex, LevelContent.totalLevels);
}

class ProgressNotifier extends Notifier<ProgressState> {
  @override
  ProgressState build() {
    _loadFromHive();
    return const ProgressState();
  }

  Future<Box> _getBox() async => await Hive.openBox('kataplay_data');

  Future<void> _loadFromHive() async {
    try {
      final box = await _getBox();
      final progress = UserProgress.fromHive(box);
      final avatar = AvatarRepository.getById(progress.selectedAvatarId);
      final updatedProgress = (avatar != null &&
              avatar.assetPath != progress.selectedAvatarPath)
          ? progress.copyWith(
              selectedAvatarId: avatar.id,
              selectedAvatarPath: avatar.assetPath,
            )
          : progress;
      state = ProgressState(progress: updatedProgress, isLoading: false);
    } catch (e) {
      state = const ProgressState(isLoading: false);
    }
  }

  Future<void> _saveToHive() async {
    try {
      final box = await _getBox();
      await state.progress.saveToHive(box);
    } catch (_) {}
  }

  Future<void> completeLesson(String lessonId, int xpEarned) async {
    final now = DateTime.now();
    final updatedCompleted =
        Set<String>.from(state.progress.completedLessonIds)..add(lessonId);
    final newStreak = state.progress.calculateStreak(now);
    final newXp = state.progress.xp + xpEarned;
    final isNewLevelCompleted =
        (newXp ~/ AppConstants.xpPerLevel) >
        (state.progress.xp ~/ AppConstants.xpPerLevel);

    var p = state.progress.copyWith(
      xp: newXp,
      streak: newStreak,
      completedLessonIds: updatedCompleted,
      lastPlayedDate: now,
      currentLevelIndex: isNewLevelCompleted
          ? (state.progress.currentLevelIndex + 1)
          : state.progress.currentLevelIndex,
    );

    List<CurriculumStage> stages = [];
    try {
      final repo = ref.read(curriculumRepositoryProvider);
      final catalog = await repo.loadCurriculum();
      stages = catalog.stages;
    } catch (_) {}

    final badges = _calculateBadges(p, stages);
    final newlyAwarded = badges.difference(p.collectedBadges);
    p = p.copyWith(collectedBadges: badges);

    state = ProgressState(
      progress: p,
      newlyAwardedBadges: newlyAwarded,
      isLoading: false,
    );
    _saveToHive();
  }

  Set<String> _calculateBadges(UserProgress p, List<CurriculumStage> stages) {
    final badges = Set<String>.from(p.collectedBadges);
    final levels = LevelContent.allLevels;
    for (final level in levels) {
      if (level.lessons.every((l) => p.isLessonCompleted(l.id))) {
        final badgeId = '${level.id}_complete';
        if (!badges.contains(badgeId)) badges.add(badgeId);
      }
    }
    for (final stage in stages) {
      final allCompleted = stage.units.every((u) =>
          u.lessons.every((l) => p.isLessonCompleted(l.id)));
      if (allCompleted) {
        final badgeId = 'stage_${stage.order}_complete';
        if (!badges.contains(badgeId)) badges.add(badgeId);
      }
    }
    if (p.xp >= AppConstants.xpBadge100 && !badges.contains('xp_100')) {
      badges.add('xp_100');
    }
    if (p.xp >= AppConstants.xpBadge500 && !badges.contains('xp_500')) {
      badges.add('xp_500');
    }
    if (p.xp >= AppConstants.xpBadge1000 && !badges.contains('xp_1000')) {
      badges.add('xp_1000');
    }
    if (p.streak >= AppConstants.streakMinForBadge &&
        !badges.contains('streak_3')) {
      badges.add('streak_3');
    }
    if (p.streak >= AppConstants.streakBadgeThreshold &&
        !badges.contains('streak_7')) {
      badges.add('streak_7');
    }
    if (levels.every((l) =>
            l.lessons.every((lesson) => p.isLessonCompleted(lesson.id))) &&
        !badges.contains('all_complete')) {
      badges.add('all_complete');
    }
    return badges;
  }

  void addBadge(String badgeId) {
    final updated =
        Set<String>.from(state.progress.collectedBadges)..add(badgeId);
    final p = state.progress.copyWith(collectedBadges: updated);
    state = ProgressState(progress: p, isLoading: false);
    _saveToHive();
  }

  void setChildName(String name) {
    final p = state.progress.copyWith(childName: name);
    state = ProgressState(progress: p, isLoading: false);
    _saveToHive();
  }

  void setSelectedAvatar(String id, String assetPath) {
    final p = state.progress.copyWith(
      selectedAvatarId: id,
      selectedAvatarPath: assetPath,
    );
    state = ProgressState(progress: p, isLoading: false);
    _saveToHive();
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
      state = const ProgressState(isLoading: false);
    } catch (_) {}
  }
}

final progressProvider =
    NotifierProvider<ProgressNotifier, ProgressState>(ProgressNotifier.new);

class SettingsState {
  final AppSettings settings;
  final bool isLoading;

  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoading = true,
  });

  SettingsState copyWith({AppSettings? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get soundEnabled => settings.soundEnabled;
  bool get musicEnabled => settings.musicEnabled;
  bool get onboardingComplete => settings.onboardingComplete;
}

class SettingsNotifier extends Notifier<SettingsState> {
  final SettingsRepository _repository = SettingsRepository();

  @override
  SettingsState build() {
    _load();
    return const SettingsState();
  }

  Future<void> _load() async {
    final settings = await _repository.load();
    state = SettingsState(settings: settings, isLoading: false);
  }

  Future<void> setSoundEnabled(bool value) async {
    final s = state.settings.copyWith(soundEnabled: value);
    state = SettingsState(settings: s, isLoading: false);
    await _repository.save(s);
  }

  Future<void> setMusicEnabled(bool value) async {
    final s = state.settings.copyWith(musicEnabled: value);
    state = SettingsState(settings: s, isLoading: false);
    await _repository.save(s);
  }

  Future<void> markOnboardingComplete() async {
    final s = state.settings.copyWith(onboardingComplete: true);
    state = SettingsState(settings: s, isLoading: false);
    await _repository.save(s);
  }

  Future<void> resetToDefaults() async {
    const s = AppSettings();
    state = SettingsState(settings: s, isLoading: false);
    await _repository.save(s);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

final lessonOrchestratorProvider = Provider<LessonOrchestrator>((ref) {
  return LessonOrchestrator();
});
