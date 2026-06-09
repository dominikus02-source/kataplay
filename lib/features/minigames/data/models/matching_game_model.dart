import 'word_item_model.dart';

/// Represents the state of a matching game session
enum GamePhase {
  idle, // Before game starts
  playing, // Active gameplay
  showingResult, // Showing correct/wrong feedback
  completed, // Game finished, showing score
}

/// The type of a card in the matching grid
enum CardType { word, emoji }

/// Represents a single card in the matching grid
class MatchCard {
  final String id;
  final CardType type;
  final String display; // Either word text or emoji
  final String pairId; // Links word card with its emoji card
  final WordItem wordItem;

  bool isRevealed;
  bool isMatched;

  MatchCard({
    required this.id,
    required this.type,
    required this.display,
    required this.pairId,
    required this.wordItem,
    this.isRevealed = false,
    this.isMatched = false,
  });
}

/// Complete state of a matching game session
class MatchingGameState {
  final GamePhase phase;
  final List<MatchCard> cards;
  final int score;
  final int correctMatches;
  final int wrongAttempts;
  final int totalPairs;
  final int coinsEarned;
  final int xpEarned;
  final Duration elapsed;
  final Duration timeLimit;
  final MatchCard? firstSelected;
  final MatchCard? secondSelected;
  final int currentLevel;
  final List<WordItem> wordsUsed;

  const MatchingGameState({
    this.phase = GamePhase.idle,
    this.cards = const [],
    this.score = 0,
    this.correctMatches = 0,
    this.wrongAttempts = 0,
    this.totalPairs = 4,
    this.coinsEarned = 0,
    this.xpEarned = 0,
    this.elapsed = Duration.zero,
    this.timeLimit = const Duration(seconds: 60),
    this.firstSelected,
    this.secondSelected,
    this.currentLevel = 1,
    this.wordsUsed = const [],
  });

  /// Whether the game is complete (all pairs matched)
  bool get isComplete => correctMatches >= totalPairs;

  /// Score as a percentage (0-100)
  int get scorePercent =>
      totalPairs > 0 ? ((correctMatches / totalPairs) * 100).round() : 0;

  /// Whether it's a perfect game (no wrong attempts)
  bool get isPerfect => wrongAttempts == 0 && correctMatches == totalPairs;

  /// Time remaining in seconds
  int get timeRemaining =>
      (timeLimit.inSeconds - elapsed.inSeconds).clamp(0, timeLimit.inSeconds);

  /// Whether time has run out
  bool get isTimeUp => elapsed >= timeLimit;

  /// Grid columns based on number of pairs
  int get gridColumns {
    switch (totalPairs) {
      case 4:
        return 4; // 4×2 grid
      case 6:
        return 4; // 4×3 grid
      case 8:
        return 4; // 4×4 grid
      default:
        return 4;
    }
  }

  MatchingGameState copyWith({
    GamePhase? phase,
    List<MatchCard>? cards,
    int? score,
    int? correctMatches,
    int? wrongAttempts,
    int? totalPairs,
    int? coinsEarned,
    int? xpEarned,
    Duration? elapsed,
    Duration? timeLimit,
    MatchCard? firstSelected,
    MatchCard? secondSelected,
    int? currentLevel,
    List<WordItem>? wordsUsed,
    bool clearSelection = false,
  }) {
    return MatchingGameState(
      phase: phase ?? this.phase,
      cards: cards ?? this.cards,
      score: score ?? this.score,
      correctMatches: correctMatches ?? this.correctMatches,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
      totalPairs: totalPairs ?? this.totalPairs,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      xpEarned: xpEarned ?? this.xpEarned,
      elapsed: elapsed ?? this.elapsed,
      timeLimit: timeLimit ?? this.timeLimit,
      firstSelected: clearSelection ? null : (firstSelected ?? this.firstSelected),
      secondSelected: clearSelection ? null : (secondSelected ?? this.secondSelected),
      currentLevel: currentLevel ?? this.currentLevel,
      wordsUsed: wordsUsed ?? this.wordsUsed,
    );
  }

  /// Get pairs configuration by level (per MG3 Picture Match spec)
  static int pairsForLevel(int level) {
    switch (level) {
      case 1:
        return 4; // 2×4 grid (8 cards)
      case 2:
        return 6; // 3×4 grid (12 cards)
      case 3:
        return 8; // 4×4 grid (16 cards)
      default:
        return 4;
    }
  }

  /// Get time limit by level
  static Duration timeLimitForLevel(int level) {
    switch (level) {
      case 1:
        return const Duration(seconds: 60);
      case 2:
        return const Duration(seconds: 75);
      case 3:
        return const Duration(seconds: 90);
      default:
        return const Duration(seconds: 60);
    }
  }

  /// Calculate rewards based on performance
  /// Per Reward Economy: 10 XP + 5 koin per correct match, bonus for perfect
  ({int coins, int xp}) calculateRewards() {
    int coins = correctMatches * 5;
    int xp = correctMatches * 10;

    // Perfect score bonus
    if (isPerfect) {
      coins += 10;
      xp += 15;
    }

    return (coins: coins, xp: xp);
  }
}
