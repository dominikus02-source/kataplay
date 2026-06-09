import 'package:flutter_test/flutter_test.dart';
import 'package:kataplay/features/home/data/models/user_progress_model.dart';

void main() {
  group('UserProgress Model', () {
    test('creates with default values', () {
      final progress = UserProgress();
      expect(progress.playerName, 'Petualang');
      expect(progress.playerAge, 6);
      expect(progress.coins, 0);
      expect(progress.xp, 0);
      expect(progress.level, 1);
      expect(progress.streakDays, 0);
      expect(progress.totalGamesPlayed, 0);
    });

    test('creates new player with welcome bonus', () {
      final progress = UserProgress.newPlayer();
      expect(progress.coins, 50); // Welcome bonus
      expect(progress.level, 1);
      expect(progress.streakDays, 0);
    });

    test('addXp increases xp and returns false when no level up', () {
      final progress = UserProgress();
      final leveledUp = progress.addXp(50);
      expect(progress.xp, 50);
      expect(leveledUp, false);
    });

    test('addXp triggers level up when threshold is reached', () {
      final progress = UserProgress();
      // Level 2 needs 110 XP (50 * 2 * (1 + 2/10))
      final leveledUp = progress.addXp(150);
      expect(progress.level, greaterThan(1));
      expect(leveledUp, true);
    });

    test('addCoins respects max cap of 99999', () {
      final progress = UserProgress(coins: 99998);
      progress.addCoins(100);
      expect(progress.coins, 99999);
    });

    test('spendCoins succeeds when enough coins', () {
      final progress = UserProgress(coins: 100);
      final success = progress.spendCoins(50);
      expect(success, true);
      expect(progress.coins, 50);
    });

    test('spendCoins fails when not enough coins', () {
      final progress = UserProgress(coins: 30);
      final success = progress.spendCoins(50);
      expect(success, false);
      expect(progress.coins, 30);
    });

    test('recordDailyPlay sets streak to 1 for first time', () {
      final progress = UserProgress();
      progress.recordDailyPlay();
      expect(progress.streakDays, 1);
      expect(progress.lastPlayDate, isNotNull);
    });

    test('recordDailyPlay increments streak on consecutive days', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final progress = UserProgress(streakDays: 3, lastPlayDate: yesterday);
      progress.recordDailyPlay();
      expect(progress.streakDays, 4);
    });

    test('recordDailyPlay resets streak if gap > 1 day', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final progress = UserProgress(streakDays: 5, lastPlayDate: twoDaysAgo);
      progress.recordDailyPlay();
      expect(progress.streakDays, 1);
    });

    test('hasPlayedToday returns false initially', () {
      final progress = UserProgress();
      expect(progress.hasPlayedToday, false);
    });

    test('hasPlayedToday returns true after recording', () {
      final progress = UserProgress();
      progress.recordDailyPlay();
      expect(progress.hasPlayedToday, true);
    });

    test('toMap and fromMap roundtrip preserves data', () {
      final original = UserProgress(
        playerName: 'Rafa',
        playerAge: 7,
        coins: 245,
        xp: 500,
        level: 3,
        streakDays: 5,
        totalGamesPlayed: 10,
      );
      final map = original.toMap();
      final restored = UserProgress.fromMap(map);

      expect(restored.playerName, original.playerName);
      expect(restored.playerAge, original.playerAge);
      expect(restored.coins, original.coins);
      expect(restored.xp, original.xp);
      expect(restored.level, original.level);
      expect(restored.streakDays, original.streakDays);
      expect(restored.totalGamesPlayed, original.totalGamesPlayed);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = UserProgress(playerName: 'Rafa', coins: 100);
      final updated = original.copyWith(coins: 200);

      expect(updated.playerName, 'Rafa');
      expect(updated.coins, 200);
      expect(original.coins, 100); // Original unchanged
    });

    test('XP formula matches Reward Economy spec', () {
      // Level 2: 50 × 2 × (1 + 2/10) = 120
      expect(UserProgress._xpNeededForLevel(2), 120);
      // Level 5: 50 × 5 × (1 + 5/10) = 375
      expect(UserProgress._xpNeededForLevel(5), 375);
      // Level 10: 50 × 10 × (1 + 10/10) = 1000
      expect(UserProgress._xpNeededForLevel(10), 1000);
    });
  });
}
