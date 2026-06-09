/// Represents a daily quest in KataPlay
class DailyQuest {
  final String id;
  final String description;
  final int targetCount;
  final int currentCount;
  final int coinReward;
  final int xpReward;
  final bool isCompleted;
  final bool isClaimed;
  final DateTime date;

  const DailyQuest({
    required this.id,
    required this.description,
    this.targetCount = 1,
    this.currentCount = 0,
    this.coinReward = 10,
    this.xpReward = 20,
    this.isCompleted = false,
    this.isClaimed = false,
    required this.date,
  });

  /// Progress ratio (0.0 - 1.0)
  double get progress =>
      targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;

  DailyQuest copyWith({
    String? id,
    String? description,
    int? targetCount,
    int? currentCount,
    int? coinReward,
    int? xpReward,
    bool? isCompleted,
    bool? isClaimed,
    DateTime? date,
  }) {
    return DailyQuest(
      id: id ?? this.id,
      description: description ?? this.description,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      coinReward: coinReward ?? this.coinReward,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
      date: date ?? this.date,
    );
  }

  /// Generate daily quests for today
  /// 3 quests per day per game design
  static List<DailyQuest> generateForToday() {
    final today = DateTime.now();
    // Use day of year as seed for variety
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;

    final questTemplates = [
      DailyQuest(
        id: 'dq_${today.toIso8601String().substring(0, 10)}_1',
        description: 'Selesaikan 2 mini game hari ini',
        targetCount: 2,
        coinReward: 30,
        xpReward: 40,
        date: today,
      ),
      DailyQuest(
        id: 'dq_${today.toIso8601String().substring(0, 10)}_2',
        description: 'Dapatkan 5 jawaban benar',
        targetCount: 5,
        coinReward: 20,
        xpReward: 30,
        date: today,
      ),
      DailyQuest(
        id: 'dq_${today.toIso8601String().substring(0, 10)}_3',
        description: 'Kumpulkan 3 kata baru',
        targetCount: 3,
        coinReward: 25,
        xpReward: 35,
        date: today,
      ),
    ];

    return questTemplates;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'coinReward': coinReward,
        'xpReward': xpReward,
        'isCompleted': isCompleted,
        'isClaimed': isClaimed,
        'date': date.toIso8601String(),
      };

  factory DailyQuest.fromMap(Map<String, dynamic> map) => DailyQuest(
        id: map['id'] as String,
        description: map['description'] as String,
        targetCount: map['targetCount'] as int? ?? 1,
        currentCount: map['currentCount'] as int? ?? 0,
        coinReward: map['coinReward'] as int? ?? 10,
        xpReward: map['xpReward'] as int? ?? 20,
        isCompleted: map['isCompleted'] as bool? ?? false,
        isClaimed: map['isClaimed'] as bool? ?? false,
        date: DateTime.parse(map['date'] as String),
      );
}
