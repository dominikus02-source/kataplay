/// Represents the complete user progress in KataPlay
/// Stored in Hive via Map serialization for offline persistence
class UserProgress {
  String playerName;
  int playerAge;
  int coins;
  int xp;
  int level;
  int streakDays;
  DateTime? lastPlayDate;
  DateTime joinDate;
  int totalGamesPlayed;
  int totalCorrectAnswers;
  int totalWordsLearned;

  UserProgress({
    this.playerName = 'Petualang',
    this.playerAge = 6,
    this.coins = 0,
    this.xp = 0,
    this.level = 1,
    this.streakDays = 0,
    this.lastPlayDate,
    DateTime? joinDate,
    this.totalGamesPlayed = 0,
    this.totalCorrectAnswers = 0,
    this.totalWordsLearned = 0,
  }) : joinDate = joinDate ?? DateTime.now();

  /// XP needed for current level
  int get xpForNextLevel => _xpNeededForLevel(level + 1);

  /// XP needed for a specific level
  /// Formula from Reward Economy: 50 × N × (1 + N/10)
  static int _xpNeededForLevel(int n) => (50 * n * (1 + n / 10)).round();

  /// Total XP accumulated from level 1 to current level
  int get totalXpForCurrentLevel {
    int total = 0;
    for (int i = 2; i <= level; i++) {
      total += _xpNeededForLevel(i);
    }
    return total;
  }

  /// Progress ratio (0.0 - 1.0) towards next level
  double get levelProgress {
    if (level <= 0) return 0.0;
    final xpInCurrentLevel = xp - totalXpForCurrentLevel;
    final xpNeeded = xpForNextLevel - totalXpForCurrentLevel;
    if (xpNeeded <= 0) return 1.0;
    return (xpInCurrentLevel / xpNeeded).clamp(0.0, 1.0);
  }

  /// Check if player has played today
  bool get hasPlayedToday {
    if (lastPlayDate == null) return false;
    final now = DateTime.now();
    return now.year == lastPlayDate!.year &&
        now.month == lastPlayDate!.month &&
        now.day == lastPlayDate!.day;
  }

  /// Add XP and check for level up
  /// Returns true if level up occurred
  bool addXp(int amount) {
    xp += amount;
    bool leveledUp = false;

    while (xp >= xpForNextLevel) {
      level++;
      leveledUp = true;
    }
    return leveledUp;
  }

  /// Add coins with max cap (99,999 per economy design)
  void addCoins(int amount) {
    coins = (coins + amount).clamp(0, 99999);
  }

  /// Spend coins, returns false if not enough
  bool spendCoins(int amount) {
    if (coins < amount) return false;
    coins -= amount;
    return true;
  }

  /// Record daily play (for streak calculation)
  void recordDailyPlay() {
    final now = DateTime.now();
    if (lastPlayDate != null) {
      final diff = now.difference(lastPlayDate!);
      if (diff.inDays == 1) {
        streakDays++;
      } else if (diff.inDays > 1) {
        streakDays = 1;
      }
      // Same day = no change to streak
    } else {
      streakDays = 1;
    }
    lastPlayDate = now;
  }

  /// Create a copy with updated fields
  UserProgress copyWith({
    String? playerName,
    int? playerAge,
    int? coins,
    int? xp,
    int? level,
    int? streakDays,
    DateTime? lastPlayDate,
    DateTime? joinDate,
    int? totalGamesPlayed,
    int? totalCorrectAnswers,
    int? totalWordsLearned,
  }) {
    return UserProgress(
      playerName: playerName ?? this.playerName,
      playerAge: playerAge ?? this.playerAge,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      lastPlayDate: lastPlayDate ?? this.lastPlayDate,
      joinDate: joinDate ?? this.joinDate,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
    );
  }

  /// Convert to Map for Hive storage
  Map<String, dynamic> toMap() => {
        'playerName': playerName,
        'playerAge': playerAge,
        'coins': coins,
        'xp': xp,
        'level': level,
        'streakDays': streakDays,
        'lastPlayDate': lastPlayDate?.toIso8601String(),
        'joinDate': joinDate.toIso8601String(),
        'totalGamesPlayed': totalGamesPlayed,
        'totalCorrectAnswers': totalCorrectAnswers,
        'totalWordsLearned': totalWordsLearned,
      };

  /// Create from Map (Hive storage)
  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        playerName: map['playerName'] as String? ?? 'Petualang',
        playerAge: map['playerAge'] as int? ?? 6,
        coins: map['coins'] as int? ?? 0,
        xp: map['xp'] as int? ?? 0,
        level: map['level'] as int? ?? 1,
        streakDays: map['streakDays'] as int? ?? 0,
        lastPlayDate: map['lastPlayDate'] != null
            ? DateTime.parse(map['lastPlayDate'] as String)
            : null,
        joinDate: map['joinDate'] != null
            ? DateTime.parse(map['joinDate'] as String)
            : DateTime.now(),
        totalGamesPlayed: map['totalGamesPlayed'] as int? ?? 0,
        totalCorrectAnswers: map['totalCorrectAnswers'] as int? ?? 0,
        totalWordsLearned: map['totalWordsLearned'] as int? ?? 0,
      );

  /// Default starter progress for new players
  factory UserProgress.newPlayer({String name = 'Petualang', int age = 6}) {
    return UserProgress(
      playerName: name,
      playerAge: age,
      coins: 50, // Welcome bonus per economy design
      xp: 0,
      level: 1,
      streakDays: 0,
      joinDate: DateTime.now(),
    );
  }
}
