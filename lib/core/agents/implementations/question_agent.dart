import 'dart:math';
import '../agent.dart';
import '../types.dart';
import '../../../features/lesson/domain/lesson.dart';

class QuestionAgent extends KataPlayAgent<QuestionSpec, LessonQuestion> {
  @override
  String get name => 'question';

  @override
  Future<LessonQuestion> process(QuestionSpec input) async {
    final seed = _seedFrom(input);
    final rng = Random(seed);
    return _generateQuestion(input, rng);
  }

  int _seedFrom(QuestionSpec input) {
    return input.skillId.hashCode ^
        DifficultyLevel.values.indexOf(input.difficulty) *
            1000 ^
        input.keywords.hashCode;
  }

  static const _instructions = {
    LessonType.wordChoice: [
      'Pilih kata yang tepat',
      'Kata mana yang benar?',
      'Cari kata yang sesuai',
      'Sentuh jawaban yang benar',
      'Pilih satu kata',
    ],
    LessonType.imageChoice: [
      'Apa nama gambar ini?',
      'Gambar apakah itu?',
      'Cocokkan dengan gambarnya',
      'Pilih nama gambar ini',
    ],
    LessonType.trueFalse: [
      'Benar atau salah?',
      'Apakah ini benar?',
      'Betul atau salah?',
      'Cek kebenarannya',
    ],
    LessonType.arrangeWord: [
      'Susun hurufnya',
      'Urutkan huruf jadi kata',
      'Buat kata dari huruf',
      'Ayo rangkai hurufnya',
    ],
    LessonType.fillBlank: [
      'Lengkapi kata',
      'Apa huruf yang hilang?',
      'Isi titik-titiknya',
      'Tambah hurufnya',
    ],
    LessonType.matching: [
      'Pasangkan dengan tepat',
      'Cocokkan gambar dan kata',
      'Tarik garis ke pasangan',
    ],
    LessonType.readSentence: [
      'Baca kalimat ini',
      'Bacalah dengan nyaring',
      'Apa bunyi kalimat ini?',
      'Baca dan jawab',
    ],
  };

  static const _distractorPool = [
    'buku',   'meja',   'kursi',   'pintu',  'jendela',
    'lampu',  'tas',    'topi',    'sepatu', 'kaos',
    'pensil', 'papan',  'kertas',  'gelas',  'piring',
    'sendok', 'kunci',  'jam',     'bola',   'boneka',
    'apel',   'jeruk',  'mangga',  'anggur', 'semangka',
    'pisang', 'wortel', 'kentang', 'cabai',  'tomat',
    'kucing', 'anjing', 'burung',  'ikan',   'kuda',
    'ayam',   'bebek',  'ular',    'belalang', 'kupu-kupu',
    'rumah',  'sekolah','pasar',   'toko',   'masjid',
    'mobil',  'motor',  'sepeda',  'bus',    'kereta',
    'bulat',  'persegi','panjang', 'pendek', 'besar',
    'kecil',  'tinggi', 'rendah',  'berat',  'ringan',
  ];

  static const _synonymMap = <String, List<String>>{
    'apel': ['buah apel', 'apel merah', 'apple'],
    'buku': ['kitab', 'bacaan', 'book'],
    'besar': ['raksasa', 'gede', 'agung'],
    'kecil': ['mungil', 'mini', 'kecil sekali'],
    'rumah': ['gedung', 'hunian', 'house'],
    'pintu': ['gerbang', 'lawang'],
    'matahari': ['mentari', 'surya', 'sun'],
  };

  LessonQuestion _generateQuestion(QuestionSpec input, Random rng) {
    final type = input.preferredType;
    final difficultyMultiplier = input.difficulty == DifficultyLevel.warmup
        ? 0.5
        : input.difficulty == DifficultyLevel.challenge
            ? 1.5
            : 1.0;

    switch (type) {
      case LessonType.wordChoice:
        return _generateWordChoice(input, difficultyMultiplier, rng);
      case LessonType.imageChoice:
      case LessonType.pictureChoice:
        return _generateImageChoice(input, difficultyMultiplier, rng);
      case LessonType.trueFalse:
        return _generateTrueFalse(input, difficultyMultiplier, rng);
      case LessonType.arrangeWord:
      case LessonType.wordOrder:
        return _generateArrangeWord(input, difficultyMultiplier, rng);
      case LessonType.fillBlank:
        return _generateFillBlank(input, difficultyMultiplier, rng);
      case LessonType.matching:
      case LessonType.matchPair:
        return _generateMatching(input, difficultyMultiplier, rng);
      case LessonType.readSentence:
      case LessonType.readingComprehension:
        return _generateReadSentence(input, difficultyMultiplier, rng);
      case LessonType.listenChoose:
        return _generateImageChoice(input, difficultyMultiplier, rng);
      case LessonType.missingWord:
        return _generateFillBlank(input, difficultyMultiplier, rng);
      case LessonType.sentenceChoice:
        return _generateReadSentence(input, difficultyMultiplier, rng);
      case LessonType.storyReading:
      case LessonType.storyComprehension:
        return _generateReadSentence(input, difficultyMultiplier, rng);
      case LessonType.recordVoice:
      case LessonType.speakingPractice:
        return _generateWordChoice(input, difficultyMultiplier, rng);
    }
  }

  String _pickInstruction(LessonType type, Random rng) {
    final pool = _instructions[type]!;
    return pool[rng.nextInt(pool.length)];
  }

  String _pickKeyword(List<String> keywords, Random rng) {
    if (keywords.isEmpty) {
      return _distractorPool[rng.nextInt(_distractorPool.length)];
    }
    return keywords[rng.nextInt(keywords.length)];
  }

  bool _coinFlip(Random rng) => rng.nextDouble() < 0.5;

  LessonQuestion _generateWordChoice(
      QuestionSpec input, double multiplier, Random rng) {
    final keyword = _pickKeyword(input.keywords, rng);

    if (multiplier >= 1.2 && _synonymMap.containsKey(keyword) && _coinFlip(rng)) {
      final synonyms = _synonymMap[keyword]!;
      final synonym = synonyms[rng.nextInt(synonyms.length)];
      final options = _generateDistractorOptions(keyword, multiplier, rng);
      final allOptions = [keyword, ...options]..shuffle(rng);

      return LessonQuestion(
        type: LessonType.wordChoice,
        instruction: 'Apa sinonim dari $synonym?',
        correctAnswer: keyword,
        options: allOptions,
        imageAsset: input.imageContext,
      );
    }

    if (multiplier >= 1.0 && _coinFlip(rng)) {
      final options = _generateDistractorOptions(keyword, multiplier, rng);
      final correctFirst = [keyword, ...options]..shuffle(rng);

      return LessonQuestion(
        type: LessonType.wordChoice,
        instruction: _pickInstruction(LessonType.wordChoice, rng),
        correctAnswer: keyword,
        options: correctFirst,
        imageAsset: input.imageContext,
        hint: 'Kata ini diawali dengan ${keyword[0].toUpperCase()}',
      );
    }

    final options = _generateDistractorOptions(keyword, multiplier, rng);
    final allOptions = [keyword, ...options]..shuffle(rng);

    return LessonQuestion(
      type: LessonType.wordChoice,
      instruction: _pickInstruction(LessonType.wordChoice, rng),
      correctAnswer: keyword,
      options: allOptions,
      imageAsset: input.imageContext,
    );
  }

  List<String> _generateDistractorOptions(
      String correct, double multiplier, Random rng) {
    final available =
        _distractorPool.where((w) => w != correct).toList()..shuffle(rng);
    final count = multiplier >= 1.0 ? 3 : 2;
    return available.take(count).toList();
  }

  LessonQuestion _generateImageChoice(
      QuestionSpec input, double multiplier, Random rng) {
    final keyword = _pickKeyword(input.keywords, rng);
    final options = _generateDistractorOptions(keyword, multiplier, rng);
    final allOptions = [keyword, ...options]..shuffle(rng);

    return LessonQuestion(
      type: LessonType.imageChoice,
      instruction: _pickInstruction(LessonType.imageChoice, rng),
      correctAnswer: keyword,
      options: allOptions,
      imageAsset: input.imageContext ?? 'assets/Fruits/$keyword.png',
    );
  }

  LessonQuestion _generateTrueFalse(
      QuestionSpec input, double multiplier, Random rng) {
    final keyword = _pickKeyword(input.keywords, rng);
    final isTrue = _coinFlip(rng);
    final sentence = isTrue
        ? '$keyword adalah sebuah kata'
        : '${_distractorPool[rng.nextInt(_distractorPool.length)]} adalah angka';
    final correct = isTrue ? 'Benar' : 'Salah';

    return LessonQuestion(
      type: LessonType.trueFalse,
      instruction: _pickInstruction(LessonType.trueFalse, rng),
      correctAnswer: correct,
      options: ['Benar', 'Salah'],
      sentence: sentence,
    );
  }

  LessonQuestion _generateArrangeWord(
      QuestionSpec input, double multiplier, Random rng) {
    final word = _pickKeyword(input.keywords, rng);
    final parts = word.split('')..shuffle(rng);

    if (multiplier >= 1.2 && parts.length >= 4 && _coinFlip(rng)) {
      final target = word[0] + word[word.length - 1];
      return LessonQuestion(
        type: LessonType.arrangeWord,
        instruction: 'Huruf apa yang hilang?',
        correctAnswer: word,
        options: [target.toUpperCase(), '${word[0].toUpperCase()}${word[word.length-1].toUpperCase()}'],
        hint: 'Ada ${word.length} huruf dalam kata ini',
      );
    }

    if (parts.length > 4) {
      parts.shuffle(rng);
    }

    return LessonQuestion(
      type: LessonType.arrangeWord,
      instruction: _pickInstruction(LessonType.arrangeWord, rng),
      correctAnswer: word,
      wordParts: parts.map((c) => c.toUpperCase()).toList(),
      hint: 'Kata ini memiliki ${word.length} huruf',
    );
  }

  LessonQuestion _generateFillBlank(
      QuestionSpec input, double multiplier, Random rng) {
    final word = _pickKeyword(input.keywords, rng);

    if (multiplier >= 1.0 && word.length > 3 && _coinFlip(rng)) {
      final blankCount = rng.nextInt(2) + 1;
      final startIndex = rng.nextInt(word.length - blankCount);

      return LessonQuestion(
        type: LessonType.fillBlank,
        instruction: 'Isi $blankCount huruf yang hilang',
        correctAnswer: word,
        hint: 'Huruf ke-${startIndex + 1} sampai ke-${startIndex + blankCount}',
      );
    }

    return LessonQuestion(
      type: LessonType.fillBlank,
      instruction: _pickInstruction(LessonType.fillBlank, rng),
      correctAnswer: word,
      hint: 'Terdapat ${word.length} huruf',
    );
  }

  LessonQuestion _generateMatching(
      QuestionSpec input, double multiplier, Random rng) {
    final keyword = _pickKeyword(input.keywords, rng);
    final options = _generateDistractorOptions(keyword, multiplier, rng);
    final allOptions = [keyword, ...options]..shuffle(rng);

    return LessonQuestion(
      type: LessonType.matching,
      instruction: _pickInstruction(LessonType.matching, rng),
      correctAnswer: keyword,
      options: allOptions,
      imageAsset: input.imageContext ?? 'assets/Fruits/$keyword.png',
    );
  }

  LessonQuestion _generateReadSentence(
      QuestionSpec input, double multiplier, Random rng) {
    final keyword = _pickKeyword(input.keywords, rng);
    final sentence = multiplier >= 1.0 && _coinFlip(rng)
        ? '${keyword[0].toUpperCase()}${keyword.substring(1)} adalah benda yang berguna'
        : '$keyword adalah kata';
    final correct = 'Benar';
    final wrongSentence = multiplier >= 1.2 && _coinFlip(rng)
        ? '${_distractorPool[rng.nextInt(_distractorPool.length)]} bisa terbang'
        : null;

    return LessonQuestion(
      type: LessonType.readSentence,
      instruction: _pickInstruction(LessonType.readSentence, rng),
      correctAnswer: correct,
      sentence: wrongSentence ?? sentence,
      options: wrongSentence != null ? ['Benar', 'Salah'] : ['Benar', 'Salah'],
    );
  }
}
