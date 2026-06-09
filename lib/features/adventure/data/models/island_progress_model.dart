/// Represents progress on a single island (Pulau)
class IslandProgress {
  final int id;
  final String name;
  final bool isUnlocked;
  final bool isCompleted;
  final int levelsCompleted;
  final int totalLevels;
  final int starsEarned;
  final int maxStars;

  const IslandProgress({
    required this.id,
    required this.name,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.levelsCompleted = 0,
    this.totalLevels = 5,
    this.starsEarned = 0,
    this.maxStars = 15, // 5 levels × 3 stars
  });

  /// Progress ratio for this island (0.0 - 1.0)
  double get progress =>
      totalLevels > 0 ? levelsCompleted / totalLevels : 0.0;

  /// Star completion ratio
  double get starProgress =>
      maxStars > 0 ? starsEarned / maxStars : 0.0;

  IslandProgress copyWith({
    int? id,
    String? name,
    bool? isUnlocked,
    bool? isCompleted,
    int? levelsCompleted,
    int? totalLevels,
    int? starsEarned,
    int? maxStars,
  }) {
    return IslandProgress(
      id: id ?? this.id,
      name: name ?? this.name,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      totalLevels: totalLevels ?? this.totalLevels,
      starsEarned: starsEarned ?? this.starsEarned,
      maxStars: maxStars ?? this.maxStars,
    );
  }

  /// Convert to/from Map for Hive storage
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isUnlocked': isUnlocked,
        'isCompleted': isCompleted,
        'levelsCompleted': levelsCompleted,
        'totalLevels': totalLevels,
        'starsEarned': starsEarned,
        'maxStars': maxStars,
      };

  factory IslandProgress.fromMap(Map<String, dynamic> map) => IslandProgress(
        id: map['id'] as int,
        name: map['name'] as String,
        isUnlocked: map['isUnlocked'] as bool? ?? false,
        isCompleted: map['isCompleted'] as bool? ?? false,
        levelsCompleted: map['levelsCompleted'] as int? ?? 0,
        totalLevels: map['totalLevels'] as int? ?? 5,
        starsEarned: map['starsEarned'] as int? ?? 0,
        maxStars: map['maxStars'] as int? ?? 15,
      );
}
