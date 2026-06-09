import 'package:hive/hive.dart';

import '../../../../core/data/hive_boxes.dart';
import '../../../../core/error/app_exception.dart';
import '../../data/models/user_progress_model.dart';
import '../../data/models/daily_quest_model.dart';

/// Repository for managing user progress data
/// Abstracts Hive operations behind a clean interface using Map serialization
class UserProgressRepository {
  final Box _userProgressBox;

  UserProgressRepository(this._userProgressBox);

  /// Get current user progress
  UserProgress getUserProgress() {
    try {
      final data = _userProgressBox.get(HiveBoxes.profileKey);
      if (data == null) {
        // First time user - create default progress
        final newProgress = UserProgress.newPlayer();
        saveUserProgress(newProgress);
        return newProgress;
      }
      if (data is Map) {
        return UserProgress.fromMap(Map<String, dynamic>.from(data));
      }
      return UserProgress.newPlayer();
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memuat data progres pengguna',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Save user progress
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      await _userProgressBox.put(HiveBoxes.profileKey, progress.toMap());
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal menyimpan data progres pengguna',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Add XP and check for level up
  Future<bool> addXp(int amount) async {
    try {
      final progress = getUserProgress();
      final leveledUp = progress.addXp(amount);
      await saveUserProgress(progress);
      return leveledUp;
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal menambahkan XP',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Add coins
  Future<void> addCoins(int amount) async {
    try {
      final progress = getUserProgress();
      progress.addCoins(amount);
      await saveUserProgress(progress);
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal menambahkan koin',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Spend coins, returns false if insufficient
  Future<bool> spendCoins(int amount) async {
    try {
      final progress = getUserProgress();
      final success = progress.spendCoins(amount);
      if (success) {
        await saveUserProgress(progress);
      }
      return success;
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal mengurangi koin',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Record daily play and update streak
  Future<void> recordDailyPlay() async {
    try {
      final progress = getUserProgress();
      progress.recordDailyPlay();
      await saveUserProgress(progress);
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal merekam aktivitas harian',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Increment games played counter
  Future<void> incrementGamesPlayed() async {
    try {
      final progress = getUserProgress();
      progress.totalGamesPlayed++;
      await saveUserProgress(progress);
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memperbarui jumlah permainan',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Update player profile
  Future<void> updateProfile({String? name, int? age}) async {
    try {
      final progress = getUserProgress();
      final updated = progress.copyWith(
        playerName: name,
        playerAge: age,
      );
      await saveUserProgress(updated);
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memperbarui profil',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Get daily quests for today
  List<DailyQuest> getDailyQuests() {
    try {
      final data = _userProgressBox.get(HiveBoxes.questsKey);
      if (data == null) {
        return _generateAndSaveDailyQuests();
      }
      if (data is List) {
        final quests = data
            .map((e) => DailyQuest.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
        // Check if quests are from today
        if (quests.isNotEmpty && _isSameDay(quests.first.date, DateTime.now())) {
          return quests;
        }
        // Generate new quests for today
        return _generateAndSaveDailyQuests();
      }
      return _generateAndSaveDailyQuests();
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memuat misi harian',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Update a specific daily quest
  Future<void> updateDailyQuest(DailyQuest quest) async {
    try {
      final quests = getDailyQuests();
      final index = quests.indexWhere((q) => q.id == quest.id);
      if (index >= 0) {
        quests[index] = quest;
        await _userProgressBox.put(
          HiveBoxes.questsKey,
          quests.map((q) => q.toMap()).toList(),
        );
      }
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memperbarui misi harian',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  List<DailyQuest> _generateAndSaveDailyQuests() {
    final quests = DailyQuest.generateForToday();
    _userProgressBox.put(
      HiveBoxes.questsKey,
      quests.map((q) => q.toMap()).toList(),
    );
    return quests;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
