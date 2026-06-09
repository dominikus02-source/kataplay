import 'package:flutter_test/flutter_test.dart';
import 'package:kataplay/features/minigames/data/models/matching_game_model.dart';
import 'package:kataplay/features/minigames/data/models/word_item_model.dart';

void main() {
  group('MatchingGameState', () {
    test('pairsForLevel returns correct values', () {
      expect(MatchingGameState.pairsForLevel(1), 4);
      expect(MatchingGameState.pairsForLevel(2), 6);
      expect(MatchingGameState.pairsForLevel(3), 8);
    });

    test('timeLimitForLevel returns correct durations', () {
      expect(MatchingGameState.timeLimitForLevel(1), const Duration(seconds: 60));
      expect(MatchingGameState.timeLimitForLevel(2), const Duration(seconds: 75));
      expect(MatchingGameState.timeLimitForLevel(3), const Duration(seconds: 90));
    });

    test('isComplete when all pairs matched', () {
      final state = MatchingGameState(
        correctMatches: 4,
        totalPairs: 4,
      );
      expect(state.isComplete, true);
    });

    test('isNotComplete when pairs remain', () {
      final state = MatchingGameState(
        correctMatches: 2,
        totalPairs: 4,
      );
      expect(state.isComplete, false);
    });

    test('isPerfect when no wrong attempts and all matched', () {
      final state = MatchingGameState(
        correctMatches: 4,
        wrongAttempts: 0,
        totalPairs: 4,
      );
      expect(state.isPerfect, true);
    });

    test('isNotPerfect when wrong attempts exist', () {
      final state = MatchingGameState(
        correctMatches: 4,
        wrongAttempts: 1,
        totalPairs: 4,
      );
      expect(state.isPerfect, false);
    });

    test('calculateRewards matches economy spec', () {
      final state = MatchingGameState(
        correctMatches: 4,
        wrongAttempts: 0,
        totalPairs: 4,
      );
      final rewards = state.calculateRewards();
      // 4 matches × 5 coins = 20, + 10 perfect bonus = 30
      expect(rewards.coins, 30);
      // 4 matches × 10 xp = 40, + 15 perfect bonus = 55
      expect(rewards.xp, 55);
    });

    test('calculateRewards without perfect bonus', () {
      final state = MatchingGameState(
        correctMatches: 3,
        wrongAttempts: 2,
        totalPairs: 4,
      );
      final rewards = state.calculateRewards();
      // 3 matches × 5 coins = 15, no perfect bonus
      expect(rewards.coins, 15);
      // 3 matches × 10 xp = 30, no perfect bonus
      expect(rewards.xp, 30);
    });

    test('gridColumns returns correct values', () {
      expect(MatchingGameState(totalPairs: 4).gridColumns, 4);
      expect(MatchingGameState(totalPairs: 6).gridColumns, 4);
      expect(MatchingGameState(totalPairs: 8).gridColumns, 4);
    });

    test('timeRemaining is calculated correctly', () {
      final state = MatchingGameState(
        elapsed: const Duration(seconds: 30),
        timeLimit: const Duration(seconds: 60),
      );
      expect(state.timeRemaining, 30);
    });

    test('timeRemaining clamps to 0', () {
      final state = MatchingGameState(
        elapsed: const Duration(seconds: 70),
        timeLimit: const Duration(seconds: 60),
      );
      expect(state.timeRemaining, 0);
    });

    test('copyWith preserves unmodified fields', () {
      final state = MatchingGameState(
        correctMatches: 3,
        totalPairs: 4,
        coinsEarned: 15,
        xpEarned: 30,
      );
      final updated = state.copyWith(correctMatches: 4);
      expect(updated.correctMatches, 4);
      expect(updated.totalPairs, 4);
      expect(updated.coinsEarned, 15);
      expect(updated.xpEarned, 30);
    });
  });

  group('WordItem', () {
    test('allWords is not empty', () {
      expect(WordItem.allWords, isNotEmpty);
    });

    test('getByDifficulty filters correctly', () {
      final easyWords = WordItem.getByDifficulty(1);
      expect(easyWords.every((w) => w.difficulty == 1), true);
    });

    test('getByCategory filters correctly', () {
      final hewanWords = WordItem.getByCategory('hewan');
      expect(hewanWords.every((w) => w.category == 'hewan'), true);
    });

    test('getRandomWords returns requested count', () {
      final words = WordItem.getRandomWords(4);
      expect(words.length, 4);
    });

    test('getRandomWords respects maxDifficulty', () {
      final words = WordItem.getRandomWords(10, maxDifficulty: 1);
      expect(words.every((w) => w.difficulty <= 1), true);
    });
  });
}
