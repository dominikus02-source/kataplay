import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../data/hive_boxes.dart';
import '../../features/home/data/models/user_progress_model.dart';
import '../../features/home/data/models/daily_quest_model.dart';
import '../../features/home/data/repositories/user_progress_repository.dart';
import '../../features/adventure/data/repositories/island_repository.dart';
import '../../features/adventure/data/models/island_progress_model.dart';
import '../../features/rewards/data/repositories/sticker_repository.dart';
import '../../features/rewards/data/models/sticker_model.dart';
import '../../features/auth/data/repositories/onboarding_repository.dart';

// ============================================================
// HIVE BOX PROVIDERS
// ============================================================

final userProgressBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.userProgress);
});

final onboardingBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.onboarding);
});

// ============================================================
// REPOSITORY PROVIDERS
// ============================================================

final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  final box = ref.watch(userProgressBoxProvider);
  return UserProgressRepository(box);
});

final islandRepositoryProvider = Provider<IslandRepository>((ref) {
  final box = ref.watch(userProgressBoxProvider);
  return IslandRepository(box);
});

final stickerRepositoryProvider = Provider<StickerRepository>((ref) {
  final box = ref.watch(userProgressBoxProvider);
  return StickerRepository(box);
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final box = ref.watch(onboardingBoxProvider);
  return OnboardingRepository(box);
});

// ============================================================
// USER PROGRESS STATE NOTIFIER
// ============================================================

class UserProgressNotifier extends StateNotifier<UserProgress> {
  final UserProgressRepository _repository;

  UserProgressNotifier(this._repository) : super(_repository.getUserProgress());

  /// Reload progress from storage
  void reload() {
    state = _repository.getUserProgress();
  }

  /// Add XP to current progress
  Future<bool> addXp(int amount) async {
    final leveledUp = await _repository.addXp(amount);
    state = _repository.getUserProgress();
    return leveledUp;
  }

  /// Add coins
  Future<void> addCoins(int amount) async {
    await _repository.addCoins(amount);
    state = _repository.getUserProgress();
  }

  /// Spend coins
  Future<bool> spendCoins(int amount) async {
    final success = await _repository.spendCoins(amount);
    state = _repository.getUserProgress();
    return success;
  }

  /// Record daily play (for streak)
  Future<void> recordDailyPlay() async {
    await _repository.recordDailyPlay();
    state = _repository.getUserProgress();
  }

  /// Increment games played counter
  Future<void> incrementGamesPlayed() async {
    await _repository.incrementGamesPlayed();
    state = _repository.getUserProgress();
  }

  /// Update player profile
  Future<void> updateProfile({String? name, int? age}) async {
    await _repository.updateProfile(name: name, age: age);
    state = _repository.getUserProgress();
  }

  /// Process game completion rewards
  Future<void> processGameRewards({required int coins, required int xp}) async {
    await _repository.addCoins(coins);
    await _repository.addXp(xp);
    await _repository.incrementGamesPlayed();
    await _repository.recordDailyPlay();
    state = _repository.getUserProgress();
  }
}

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  return UserProgressNotifier(repository);
});

// ============================================================
// DAILY QUEST NOTIFIER
// ============================================================

class DailyQuestNotifier extends StateNotifier<List<DailyQuest>> {
  final UserProgressRepository _repository;

  DailyQuestNotifier(this._repository)
      : super(_repository.getDailyQuests());

  /// Reload quests from storage
  void reload() {
    state = _repository.getDailyQuests();
  }

  /// Update progress on a quest
  Future<void> updateQuestProgress(String questId, int newCount) async {
    final quests = [...state];
    final index = quests.indexWhere((q) => q.id == questId);
    if (index >= 0) {
      final quest = quests[index];
      final isCompleted = newCount >= quest.targetCount;
      quests[index] = quest.copyWith(
        currentCount: newCount,
        isCompleted: isCompleted,
      );
      state = quests;
      await _repository.updateDailyQuest(quests[index]);
    }
  }

  /// Increment progress on a quest
  Future<void> incrementQuest(String questId) async {
    final quests = [...state];
    final index = quests.indexWhere((q) => q.id == questId);
    if (index >= 0) {
      final quest = quests[index];
      if (!quest.isCompleted) {
        await updateQuestProgress(questId, quest.currentCount + 1);
      }
    }
  }

  /// Get total completion progress (0.0 - 1.0)
  double get overallProgress {
    if (state.isEmpty) return 0.0;
    final completed = state.where((q) => q.isCompleted).length;
    return completed / state.length;
  }

  /// Get count of completed quests
  int get completedCount => state.where((q) => q.isCompleted).length;
}

final dailyQuestProvider =
    StateNotifierProvider<DailyQuestNotifier, List<DailyQuest>>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  return DailyQuestNotifier(repository);
});

// ============================================================
// ISLAND PROGRESS PROVIDER
// ============================================================

final islandProgressProvider =
    StateNotifierProvider<IslandProgressNotifier, List<IslandProgress>>((ref) {
  final repository = ref.watch(islandRepositoryProvider);
  return IslandProgressNotifier(repository);
});

class IslandProgressNotifier extends StateNotifier<List<IslandProgress>> {
  final IslandRepository _repository;

  IslandProgressNotifier(this._repository)
      : super(_repository.getAllIslandProgress());

  /// Reload islands from storage
  void reload() {
    state = _repository.getAllIslandProgress();
  }

  /// Complete a level on an island
  Future<void> completeLevel(int islandId, {int starsEarned = 1}) async {
    await _repository.completeLevel(islandId, starsEarned: starsEarned);
    state = _repository.getAllIslandProgress();
  }
}

// ============================================================
// STICKER COLLECTION PROVIDER
// ============================================================

final stickerCollectionProvider =
    StateNotifierProvider<StickerCollectionNotifier, List<Sticker>>((ref) {
  final repository = ref.watch(stickerRepositoryProvider);
  return StickerCollectionNotifier(repository);
});

class StickerCollectionNotifier extends StateNotifier<List<Sticker>> {
  final StickerRepository _repository;

  StickerCollectionNotifier(this._repository)
      : super(_repository.getAllStickers());

  /// Reload stickers from storage
  void reload() {
    state = _repository.getAllStickers();
  }

  /// Unlock a sticker
  Future<void> unlockSticker(String stickerId, {String source = 'game'}) async {
    await _repository.unlockSticker(stickerId, source: source);
    state = _repository.getAllStickers();
  }

  /// Get unlocked count
  int get unlockedCount => _repository.getUnlockedCount();

  /// Get total count
  int get totalCount => _repository.totalCount;
}

// ============================================================
// ONBOARDING PROVIDER
// ============================================================

final onboardingCompleteProvider = StateProvider<bool>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return repository.isOnboardingComplete();
});
