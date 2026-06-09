/// Represents a collectible sticker in KataPlay
class Sticker {
  final String id;
  final String name;
  final String category; // hewan, buah, alfabet, karakter, seasonal, secret
  final String emoji;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String? source; // How it was unlocked (game, quest, event)

  const Sticker({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    this.isUnlocked = false,
    this.unlockedAt,
    this.source,
  });

  Sticker copyWith({
    String? id,
    String? name,
    String? category,
    String? emoji,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? source,
  }) {
    return Sticker(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'emoji': emoji,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'source': source,
      };

  factory Sticker.fromMap(Map<String, dynamic> map) => Sticker(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        emoji: map['emoji'] as String,
        isUnlocked: map['isUnlocked'] as bool? ?? false,
        unlockedAt: map['unlockedAt'] != null
            ? DateTime.parse(map['unlockedAt'] as String)
            : null,
        source: map['source'] as String?,
      );

  /// All available stickers in the game (24 total for MVP)
  static List<Sticker> get allStickers => [
        // Hewan category (6)
        Sticker(id: 'h1', name: 'Kucing', category: 'hewan', emoji: '🐱'),
        Sticker(id: 'h2', name: 'Anjing', category: 'hewan', emoji: '🐶'),
        Sticker(id: 'h3', name: 'Burung', category: 'hewan', emoji: '🐦'),
        Sticker(id: 'h4', name: 'Ikan', category: 'hewan', emoji: '🐟'),
        Sticker(id: 'h5', name: 'Kupu-kupu', category: 'hewan', emoji: '🦋'),
        Sticker(id: 'h6', name: 'Kura-kura', category: 'hewan', emoji: '🐢'),
        // Buah category (6)
        Sticker(id: 'b1', name: 'Apel', category: 'buah', emoji: '🍎'),
        Sticker(id: 'b2', name: 'Pisang', category: 'buah', emoji: '🍌'),
        Sticker(id: 'b3', name: 'Jeruk', category: 'buah', emoji: '🍊'),
        Sticker(id: 'b4', name: 'Anggur', category: 'buah', emoji: '🍇'),
        Sticker(id: 'b5', name: 'Semangka', category: 'buah', emoji: '🍉'),
        Sticker(id: 'b6', name: 'Mangga', category: 'buah', emoji: '🥭'),
        // Alfabet category (6)
        Sticker(id: 'a1', name: 'Huruf A', category: 'alfabet', emoji: '🅰️'),
        Sticker(id: 'a2', name: 'Huruf B', category: 'alfabet', emoji: '🅱️'),
        Sticker(id: 'a3', name: 'Huruf C', category: 'alfabet', emoji: '©️'),
        Sticker(id: 'a4', name: 'Huruf D', category: 'alfabet', emoji: '🔡'),
        Sticker(id: 'a5', name: 'Huruf E', category: 'alfabet', emoji: '📧'),
        Sticker(id: 'a6', name: 'Huruf F', category: 'alfabet', emoji: '🎏'),
        // Karakter category (6)
        Sticker(id: 'k1', name: 'Zelby', category: 'karakter', emoji: '🐵'),
        Sticker(id: 'k2', name: 'Hazel', category: 'karakter', emoji: '🦊'),
        Sticker(id: 'k3', name: 'Alby', category: 'karakter', emoji: '🦉'),
        Sticker(id: 'k4', name: 'Petualang', category: 'karakter', emoji: '🧑‍🤝‍🧑'),
        Sticker(id: 'k5', name: 'Guru', category: 'karakter', emoji: '👩‍🏫'),
        Sticker(id: 'k6', name: 'Koki', category: 'karakter', emoji: '👨‍🍳'),
      ];
}
