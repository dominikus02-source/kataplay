import 'package:hive/hive.dart';

import '../../../../core/data/hive_boxes.dart';
import '../../../../core/error/app_exception.dart';
import '../../../adventure/data/models/island_progress_model.dart';
import '../../../../core/constants/app_constants.dart';

/// Repository for managing island (Pulau Kata) progress
class IslandRepository {
  final Box _userProgressBox;

  IslandRepository(this._userProgressBox);

  /// Get progress for all islands
  List<IslandProgress> getAllIslandProgress() {
    try {
      final data = _userProgressBox.get(HiveBoxes.islandsKey);
      if (data == null) {
        return _initDefaultIslands();
      }
      if (data is List) {
        return data
            .map((e) => IslandProgress.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return _initDefaultIslands();
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memuat data pulau',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Get progress for a specific island
  IslandProgress? getIslandProgress(int islandId) {
    final islands = getAllIslandProgress();
    return islands.where((i) => i.id == islandId).firstOrNull;
  }

  /// Update island progress
  Future<void> updateIslandProgress(IslandProgress island) async {
    try {
      final islands = getAllIslandProgress();
      final index = islands.indexWhere((i) => i.id == island.id);
      if (index >= 0) {
        islands[index] = island;
        // Auto-unlock next island when current is completed
        if (island.isCompleted && index + 1 < islands.length) {
          islands[index + 1] = islands[index + 1].copyWith(isUnlocked: true);
        }
        await _userProgressBox.put(
          HiveBoxes.islandsKey,
          islands.map((i) => i.toMap()).toList(),
        );
      }
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memperbarui progres pulau',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Complete a level on an island
  Future<void> completeLevel(int islandId, {int starsEarned = 1}) async {
    try {
      final islands = getAllIslandProgress();
      final index = islands.indexWhere((i) => i.id == islandId);
      if (index >= 0) {
        final island = islands[index];
        final newLevelsCompleted = island.levelsCompleted + 1;
        final newStarsEarned = island.starsEarned + starsEarned;
        final isCompleted = newLevelsCompleted >= island.totalLevels;

        islands[index] = island.copyWith(
          levelsCompleted: newLevelsCompleted,
          starsEarned: newStarsEarned,
          isCompleted: isCompleted,
        );

        // Auto-unlock next island
        if (isCompleted && index + 1 < islands.length) {
          islands[index + 1] = islands[index + 1].copyWith(isUnlocked: true);
        }

        await _userProgressBox.put(
          HiveBoxes.islandsKey,
          islands.map((i) => i.toMap()).toList(),
        );
      }
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal menyelesaikan level',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Initialize default islands with first island unlocked
  /// Level counts match reference design: TK=150, SD=200-250
  List<IslandProgress> _initDefaultIslands() {
    final levelCounts = [150, 150, 200, 200, 250, 250];
    final islands = List.generate(
      AppConstants.totalIslands,
      (index) => IslandProgress(
        id: index,
        name: AppConstants.islandNames[index],
        isUnlocked: index == 0, // Only first island unlocked
        isCompleted: false,
        totalLevels: levelCounts[index],
        maxStars: levelCounts[index] * 3, // 3 stars per level
      ),
    );

    _userProgressBox.put(
      HiveBoxes.islandsKey,
      islands.map((i) => i.toMap()).toList(),
    );
    return islands;
  }
}
