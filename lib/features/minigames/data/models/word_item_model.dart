/// Word data model for the matching game (Cocokkan Kata / Picture Match)
/// Each word has a text, an emoji representation, and a category
class WordItem {
  final String word;
  final String emoji;
  final String category;
  final int difficulty; // 1 = easy, 2 = medium, 3 = hard

  const WordItem({
    required this.word,
    required this.emoji,
    required this.category,
    this.difficulty = 1,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordItem &&
          runtimeType == other.runtimeType &&
          word == other.word;

  @override
  int get hashCode => word.hashCode;

  /// Word database organized by island and difficulty
  static const List<WordItem> allWords = [
    // === PULAU AWAL - Basic words (difficulty 1) ===
    WordItem(word: 'Kucing', emoji: '🐱', category: 'hewan', difficulty: 1),
    WordItem(word: 'Anjing', emoji: '🐶', category: 'hewan', difficulty: 1),
    WordItem(word: 'Burung', emoji: '🐦', category: 'hewan', difficulty: 1),
    WordItem(word: 'Ikan', emoji: '🐟', category: 'hewan', difficulty: 1),
    WordItem(word: 'Pohon', emoji: '🌳', category: 'alam', difficulty: 1),
    WordItem(word: 'Bunga', emoji: '🌸', category: 'alam', difficulty: 1),
    WordItem(word: 'Matahari', emoji: '☀️', category: 'alam', difficulty: 1),
    WordItem(word: 'Rumah', emoji: '🏠', category: 'tempat', difficulty: 1),
    WordItem(word: 'Buku', emoji: '📖', category: 'benda', difficulty: 1),
    WordItem(word: 'Air', emoji: '💧', category: 'alam', difficulty: 1),

    // === PULAU HEWAN - Animals (difficulty 1-2) ===
    WordItem(word: 'Gajah', emoji: '🐘', category: 'hewan', difficulty: 1),
    WordItem(word: 'Kuda', emoji: '🐴', category: 'hewan', difficulty: 1),
    WordItem(word: 'Sapi', emoji: '🐮', category: 'hewan', difficulty: 1),
    WordItem(word: 'Ayam', emoji: '🐔', category: 'hewan', difficulty: 1),
    WordItem(word: 'Bebek', emoji: '🦆', category: 'hewan', difficulty: 1),
    WordItem(word: 'Kupu-kupu', emoji: '🦋', category: 'hewan', difficulty: 2),
    WordItem(word: 'Kura-kura', emoji: '🐢', category: 'hewan', difficulty: 2),
    WordItem(word: 'Ular', emoji: '🐍', category: 'hewan', difficulty: 2),
    WordItem(word: 'Lumba-lumba', emoji: '🐬', category: 'hewan', difficulty: 2),
    WordItem(word: 'Beruang', emoji: '🐻', category: 'hewan', difficulty: 2),

    // === PULAU WARNA - Colors (difficulty 1-2) ===
    WordItem(word: 'Merah', emoji: '🔴', category: 'warna', difficulty: 1),
    WordItem(word: 'Biru', emoji: '🔵', category: 'warna', difficulty: 1),
    WordItem(word: 'Kuning', emoji: '🟡', category: 'warna', difficulty: 1),
    WordItem(word: 'Hijau', emoji: '🟢', category: 'warna', difficulty: 1),
    WordItem(word: 'Ungu', emoji: '🟣', category: 'warna', difficulty: 2),
    WordItem(word: 'Oranye', emoji: '🟠', category: 'warna', difficulty: 2),
    WordItem(word: 'Putih', emoji: '⚪', category: 'warna', difficulty: 1),
    WordItem(word: 'Hitam', emoji: '⚫', category: 'warna', difficulty: 1),

    // === PULAU MAKANAN - Food (difficulty 2-3) ===
    WordItem(word: 'Nasi', emoji: '🍚', category: 'makanan', difficulty: 2),
    WordItem(word: 'Apel', emoji: '🍎', category: 'buah', difficulty: 1),
    WordItem(word: 'Pisang', emoji: '🍌', category: 'buah', difficulty: 1),
    WordItem(word: 'Jeruk', emoji: '🍊', category: 'buah', difficulty: 1),
    WordItem(word: 'Roti', emoji: '🍞', category: 'makanan', difficulty: 2),
    WordItem(word: 'Susu', emoji: '🥛', category: 'minuman', difficulty: 2),
    WordItem(word: 'Kue', emoji: '🍰', category: 'makanan', difficulty: 2),
    WordItem(word: 'Permen', emoji: '🍬', category: 'makanan', difficulty: 2),

    // === PULAU KELUARGA - Family & People (difficulty 2-3) ===
    WordItem(word: 'Ibu', emoji: '👩', category: 'keluarga', difficulty: 2),
    WordItem(word: 'Bapak', emoji: '👨', category: 'keluarga', difficulty: 2),
    WordItem(word: 'Adik', emoji: '👧', category: 'keluarga', difficulty: 2),
    WordItem(word: 'Kakak', emoji: '🧑', category: 'keluarga', difficulty: 2),
    WordItem(word: 'Nenek', emoji: '👵', category: 'keluarga', difficulty: 3),
    WordItem(word: 'Kakek', emoji: '👴', category: 'keluarga', difficulty: 3),
    WordItem(word: 'Teman', emoji: '🤝', category: 'keluarga', difficulty: 3),

    // === PULAU PETUALANGAN - Adventure (difficulty 3) ===
    WordItem(word: 'Roket', emoji: '🚀', category: 'petualangan', difficulty: 3),
    WordItem(word: 'Bintang', emoji: '⭐', category: 'petualangan', difficulty: 3),
    WordItem(word: 'Gunung', emoji: '⛰️', category: 'petualangan', difficulty: 3),
    WordItem(word: 'Laut', emoji: '🌊', category: 'petualangan', difficulty: 3),
    WordItem(word: 'Harta', emoji: '💎', category: 'petualangan', difficulty: 3),
    WordItem(word: 'Peta', emoji: '🗺️', category: 'petualangan', difficulty: 3),
  ];

  /// Get words by difficulty level
  static List<WordItem> getByDifficulty(int difficulty) {
    return allWords.where((w) => w.difficulty == difficulty).toList();
  }

  /// Get words by category
  static List<WordItem> getByCategory(String category) {
    return allWords.where((w) => w.category == category).toList();
  }

  /// Get a random subset of words for a game round
  static List<WordItem> getRandomWords(int count, {int? maxDifficulty}) {
    final available = maxDifficulty != null
        ? allWords.where((w) => w.difficulty <= maxDifficulty).toList()
        : allWords;
    available.shuffle();
    return available.take(count).toList();
  }
}
