import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/matching_game_model.dart';
import '../../data/models/word_item_model.dart';
import '../../../core/providers/app_providers.dart';

// ============================================================
// MATCHING GAME NOTIFIER
// ============================================================

class MatchingGameNotifier extends StateNotifier<MatchingGameState> {
  Timer? _timer;
  final Ref _ref;

  MatchingGameNotifier(this._ref) : super(const MatchingGameState());

  /// Start a new game at the given level
  void startGame({int level = 1}) {
    // Cancel any existing timer
    _timer?.cancel();

    final pairs = MatchingGameState.pairsForLevel(level);
    final timeLimit = MatchingGameState.timeLimitForLevel(level);
    final words = WordItem.getRandomWords(pairs, maxDifficulty: level);

    // Create cards: for each word, create a word card and an emoji card
    final cards = <MatchCard>[];
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final pairId = 'pair_$i';

      // Word card
      cards.add(MatchCard(
        id: 'word_$i',
        type: CardType.word,
        display: word.word,
        pairId: pairId,
        wordItem: word,
      ));

      // Emoji card
      cards.add(MatchCard(
        id: 'emoji_$i',
        type: CardType.emoji,
        display: word.emoji,
        pairId: pairId,
        wordItem: word,
      ));
    }

    // Shuffle cards
    cards.shuffle();

    state = MatchingGameState(
      phase: GamePhase.playing,
      cards: cards,
      totalPairs: pairs,
      timeLimit: timeLimit,
      currentLevel: level,
      wordsUsed: words,
    );

    // Start the timer
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final newElapsed = state.elapsed + const Duration(seconds: 1);
      state = state.copyWith(elapsed: newElapsed);

      if (state.isTimeUp && !state.isComplete) {
        _endGame();
      }
    });
  }

  /// Handle card tap
  void onCardTapped(String cardId) {
    if (state.phase != GamePhase.playing) return;

    final card = state.cards.firstWhere(
      (c) => c.id == cardId,
      orElse: () => throw StateError('Card not found'),
    );

    // Can't tap already revealed or matched cards
    if (card.isRevealed || card.isMatched) return;

    // Can't tap if two cards are already being compared
    if (state.secondSelected != null) return;

    // Reveal the card
    final updatedCards = [...state.cards];
    final index = updatedCards.indexWhere((c) => c.id == cardId);
    updatedCards[index] = MatchCard(
      id: card.id,
      type: card.type,
      display: card.display,
      pairId: card.pairId,
      wordItem: card.wordItem,
      isRevealed: true,
      isMatched: card.isMatched,
    );

    if (state.firstSelected == null) {
      // First card selected
      state = state.copyWith(
        cards: updatedCards,
        firstSelected: updatedCards[index],
      );
    } else {
      // Second card selected - check for match
      state = state.copyWith(
        cards: updatedCards,
        secondSelected: updatedCards[index],
      );
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    final first = state.firstSelected;
    final second = state.secondSelected;

    if (first == null || second == null) return;

    if (first.pairId == second.pairId) {
      // Match found!
      final updatedCards = [...state.cards];
      for (int i = 0; i < updatedCards.length; i++) {
        if (updatedCards[i].id == first.id || updatedCards[i].id == second.id) {
          updatedCards[i] = MatchCard(
            id: updatedCards[i].id,
            type: updatedCards[i].type,
            display: updatedCards[i].display,
            pairId: updatedCards[i].pairId,
            wordItem: updatedCards[i].wordItem,
            isRevealed: true,
            isMatched: true,
          );
        }
      }

      final newCorrectMatches = state.correctMatches + 1;
      final rewards = state.copyWith(
        correctMatches: newCorrectMatches,
        cards: updatedCards,
        clearSelection: true,
      ).calculateRewards();

      state = state.copyWith(
        cards: updatedCards,
        correctMatches: newCorrectMatches,
        coinsEarned: state.coinsEarned + 5,
        xpEarned: state.xpEarned + 10,
        clearSelection: true,
      );

      // Check if game is complete
      if (newCorrectMatches >= state.totalPairs) {
        _endGame();
      }
    } else {
      // No match - show briefly then hide
      state = state.copyWith(phase: GamePhase.showingResult);

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        final updatedCards = [...state.cards];
        for (int i = 0; i < updatedCards.length; i++) {
          if ((updatedCards[i].id == first.id ||
                  updatedCards[i].id == second.id) &&
              !updatedCards[i].isMatched) {
            updatedCards[i] = MatchCard(
              id: updatedCards[i].id,
              type: updatedCards[i].type,
              display: updatedCards[i].display,
              pairId: updatedCards[i].pairId,
              wordItem: updatedCards[i].wordItem,
              isRevealed: false,
              isMatched: false,
            );
          }
        }

        state = state.copyWith(
          cards: updatedCards,
          wrongAttempts: state.wrongAttempts + 1,
          phase: GamePhase.playing,
          clearSelection: true,
        );
      });
    }
  }

  void _endGame() {
    _timer?.cancel();

    // Calculate final rewards
    final rewards = state.calculateRewards();

    // Add perfect game bonus
    int bonusCoins = 0;
    int bonusXp = 0;
    if (state.isPerfect) {
      bonusCoins = 10;
      bonusXp = 15;
    }

    state = state.copyWith(
      phase: GamePhase.completed,
      coinsEarned: rewards.coins + bonusCoins,
      xpEarned: rewards.xp + bonusXp,
    );

    // Process rewards through user progress provider
    _ref.read(userProgressProvider.notifier).processGameRewards(
          coins: state.coinsEarned,
          xp: state.xpEarned,
        );

    // Update daily quests
    _updateDailyQuests();
  }

  void _updateDailyQuests() {
    final questNotifier = _ref.read(dailyQuestProvider.notifier);
    final quests = _ref.read(dailyQuestProvider);

    // Quest: Selesaikan mini game
    for (final quest in quests) {
      if (quest.description.contains('mini game') && !quest.isCompleted) {
        questNotifier.incrementQuest(quest.id);
      }
      if (quest.description.contains('jawaban benar') && !quest.isCompleted) {
        // Add correct matches count
        for (int i = 0; i < state.correctMatches; i++) {
          questNotifier.incrementQuest(quest.id);
        }
      }
      if (quest.description.contains('kata baru') && !quest.isCompleted) {
        // Add words learned count
        for (int i = 0; i < state.wordsUsed.length; i++) {
          questNotifier.incrementQuest(quest.id);
        }
      }
    }
  }

  /// Proceed to next level
  void nextLevel() {
    final nextLevel = state.currentLevel + 1;
    if (nextLevel <= 3) {
      startGame(level: nextLevel);
    }
  }

  /// Restart current level
  void restartGame() {
    startGame(level: state.currentLevel);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ============================================================
// MATCHING GAME PROVIDER
// ============================================================

final matchingGameProvider =
    StateNotifierProvider<MatchingGameNotifier, MatchingGameState>((ref) {
  return MatchingGameNotifier(ref);
});
