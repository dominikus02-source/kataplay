import 'models/question_model.dart';

/// Comprehensive seed questions for all 10 question types
/// Each question uses natural, kid-friendly Bahasa Indonesia
/// Characters are assigned based on question type and learning context
class SeedQuestions {
  SeedQuestions._();

  static final List<Question> all = [
    // ================================================================
    // 1. MULTIPLE CHOICE — Pilihan Ganda
    // ================================================================

    Question(
      id: 'mc_001',
      questionType: QuestionType.multipleChoice,
      questionText: 'Gambar ini namanya apa?',
      instruction: 'Pilih jawaban yang benar, ya!',
      emoji: '🍎',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'mc_001_a', text: 'Apel', emoji: '🍎', isCorrect: true),
        AnswerOption(id: 'mc_001_b', text: 'Pisang', emoji: '🍌'),
        AnswerOption(id: 'mc_001_c', text: 'Jeruk', emoji: '🍊'),
        AnswerOption(id: 'mc_001_d', text: 'Mangga', emoji: '🥭'),
      ],
      feedbackCorrect: 'Benar! Apel warnanya merah, kamu hebat!',
      feedbackWrong: 'Hampir! Lihat lagi gambarnya, ya!',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'awal',
    ),

    Question(
      id: 'mc_002',
      questionType: QuestionType.multipleChoice,
      questionText: 'Hewan apa yang suka mengeong?',
      instruction: 'Pilih hewan yang benar!',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'mc_002_a', text: 'Anjing', emoji: '🐶'),
        AnswerOption(id: 'mc_002_b', text: 'Kucing', emoji: '🐱', isCorrect: true),
        AnswerOption(id: 'mc_002_c', text: 'Ayam', emoji: '🐔'),
        AnswerOption(id: 'mc_002_d', text: 'Sapi', emoji: '🐮'),
      ],
      feedbackCorrect: 'Pintar! Kucing memang suka mengeong!',
      feedbackWrong: 'Coba ingat lagi, hewan mana yang mengeong?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'mc_003',
      questionType: QuestionType.multipleChoice,
      questionText: 'Warna langit saat cerah itu apa?',
      instruction: 'Pilih warna yang benar!',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'mc_003_a', text: 'Merah', emoji: '🔴'),
        AnswerOption(id: 'mc_003_b', text: 'Hijau', emoji: '🟢'),
        AnswerOption(id: 'mc_003_c', text: 'Biru', emoji: '🔵', isCorrect: true),
        AnswerOption(id: 'mc_003_d', text: 'Kuning', emoji: '🟡'),
      ],
      feedbackCorrect: 'Tepat! Langit cerah warnanya biru!',
      feedbackWrong: 'Lihat langit di luar, warnanya apa ya?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'warna',
    ),

    Question(
      id: 'mc_004',
      questionType: QuestionType.multipleChoice,
      questionText: 'Benda ini untuk apa?',
      instruction: 'Pilih jawaban yang tepat!',
      emoji: '📖',
      character: CharacterType.hazel,
      options: [
        AnswerOption(id: 'mc_004_a', text: 'Untuk makan', emoji: '🍽️'),
        AnswerOption(id: 'mc_004_b', text: 'Untuk tidur', emoji: '🛏️'),
        AnswerOption(id: 'mc_004_c', text: 'Untuk membaca', emoji: '📖', isCorrect: true),
        AnswerOption(id: 'mc_004_d', text: 'Untuk berenang', emoji: '🏊'),
      ],
      feedbackCorrect: 'Benar! Buku memang untuk dibaca!',
      feedbackWrong: 'Pikirkan lagi, buku itu untuk apa ya?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'awal',
    ),

    // ================================================================
    // 2. TRUE / FALSE — Benar / Salah
    // ================================================================

    Question(
      id: 'tf_001',
      questionType: QuestionType.trueFalse,
      questionText: 'Gajah itu hewan yang kecil?',
      instruction: 'Benar atau salah, ya?',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'tf_001_b', text: 'Benar', emoji: '✅'),
        AnswerOption(id: 'tf_001_s', text: 'Salah', emoji: '❌', isCorrect: true),
      ],
      feedbackCorrect: 'Tepat! Gajah itu hewan paling besar!',
      feedbackWrong: 'Gajah itu hewan besar loh, bukan kecil!',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'tf_002',
      questionType: QuestionType.trueFalse,
      questionText: 'Matahari terbit dari arah timur?',
      instruction: 'Benar atau salah?',
      character: CharacterType.hazel,
      options: [
        AnswerOption(id: 'tf_002_b', text: 'Benar', emoji: '✅', isCorrect: true),
        AnswerOption(id: 'tf_002_s', text: 'Salah', emoji: '❌'),
      ],
      feedbackCorrect: 'Pintar! Matahari memang terbit dari timur!',
      feedbackWrong: 'Ingat ya, matahari terbit dari arah timur!',
      xpReward: 10,
      coinReward: 3,
      difficulty: 2,
      category: 'alam',
    ),

    Question(
      id: 'tf_003',
      questionType: QuestionType.trueFalse,
      questionText: 'Air bisa mengalir ke atas tanpa bantuan?',
      instruction: 'Benar atau salah?',
      character: CharacterType.hazel,
      options: [
        AnswerOption(id: 'tf_003_b', text: 'Benar', emoji: '✅'),
        AnswerOption(id: 'tf_003_s', text: 'Salah', emoji: '❌', isCorrect: true),
      ],
      feedbackCorrect: 'Benar! Air selalu mengalir ke bawah!',
      feedbackWrong: 'Air itu selalu mengalir ke bawah, lho!',
      xpReward: 12,
      coinReward: 4,
      difficulty: 2,
      category: 'alam',
    ),

    Question(
      id: 'tf_004',
      questionType: QuestionType.trueFalse,
      questionText: 'Kupu-kupu bisa terbang?',
      instruction: 'Benar atau salah?',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'tf_004_b', text: 'Benar', emoji: '✅', isCorrect: true),
        AnswerOption(id: 'tf_004_s', text: 'Salah', emoji: '❌'),
      ],
      feedbackCorrect: 'Ya! Kupu-kupu punya sayap yang indah!',
      feedbackWrong: 'Kupu-kupu memang bisa terbang dengan sayapnya!',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    // ================================================================
    // 3. MATCH WORD & IMAGE — Menjodohkan Kata dan Gambar
    // ================================================================

    Question(
      id: 'mw_001',
      questionType: QuestionType.matchWordImage,
      questionText: 'Gambar mana yang cocok dengan kata "Matahari"?',
      instruction: 'Pilih gambar yang cocok!',
      character: CharacterType.alby,
      options: [
        AnswerOption(id: 'mw_001_a', text: 'Matahari', emoji: '☀️', isCorrect: true),
        AnswerOption(id: 'mw_001_b', text: 'Bulan', emoji: '🌙'),
        AnswerOption(id: 'mw_001_c', text: 'Bintang', emoji: '⭐'),
        AnswerOption(id: 'mw_001_d', text: 'Awan', emoji: '☁️'),
      ],
      feedbackCorrect: 'Hebat! Matahari itu cerah dan hangat!',
      feedbackWrong: 'Coba lihat lagi, mana yang seperti matahari?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'alam',
    ),

    Question(
      id: 'mw_002',
      questionType: QuestionType.matchWordImage,
      questionText: 'Gambar mana yang cocok dengan kata "Pisang"?',
      instruction: 'Pilih gambar yang cocok!',
      character: CharacterType.alby,
      options: [
        AnswerOption(id: 'mw_002_a', text: 'Apel', emoji: '🍎'),
        AnswerOption(id: 'mw_002_b', text: 'Pisang', emoji: '🍌', isCorrect: true),
        AnswerOption(id: 'mw_002_c', text: 'Anggur', emoji: '🍇'),
        AnswerOption(id: 'mw_002_d', text: 'Semangka', emoji: '🍉'),
      ],
      feedbackCorrect: 'Tepat! Pisang itu kuning dan manis!',
      feedbackWrong: 'Lihat bentuknya, mana yang seperti pisang?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'buah',
    ),

    // ================================================================
    // 4. LISTEN AND CHOOSE — Dengarkan & Pilih
    // ================================================================

    Question(
      id: 'lc_001',
      questionType: QuestionType.listenAndChoose,
      questionText: 'Dengarkan baik-baik, lalu pilih kata yang kamu dengar!',
      instruction: 'Tekan tombol putar, lalu pilih jawabannya!',
      character: CharacterType.alby,
      hint: 'Kata ini nama hewan yang suka menggonggong',
      correctAnswer: 'Anjing',
      options: [
        AnswerOption(id: 'lc_001_a', text: 'Kucing', emoji: '🐱'),
        AnswerOption(id: 'lc_001_b', text: 'Anjing', emoji: '🐶', isCorrect: true),
        AnswerOption(id: 'lc_001_c', text: 'Burung', emoji: '🐦'),
        AnswerOption(id: 'lc_001_d', text: 'Ikan', emoji: '🐟'),
      ],
      feedbackCorrect: 'Luar biasa! Kamu bisa mendengar dengan baik!',
      feedbackWrong: 'Dengar lagi suaranya, hewan apa itu?',
      xpReward: 12,
      coinReward: 4,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'lc_002',
      questionType: QuestionType.listenAndChoose,
      questionText: 'Dengarkan suaranya, kata apa yang kamu dengar?',
      instruction: 'Tekan tombol play, ya!',
      character: CharacterType.alby,
      hint: 'Ini nama buah yang warnanya oranye',
      correctAnswer: 'Jeruk',
      options: [
        AnswerOption(id: 'lc_002_a', text: 'Apel', emoji: '🍎'),
        AnswerOption(id: 'lc_002_b', text: 'Jeruk', emoji: '🍊', isCorrect: true),
        AnswerOption(id: 'lc_002_c', text: 'Pisang', emoji: '🍌'),
        AnswerOption(id: 'lc_002_d', text: 'Mangga', emoji: '🥭'),
      ],
      feedbackCorrect: 'Keren! Kamu punya telinga yang tajam!',
      feedbackWrong: 'Coba dengar sekali lagi, ya!',
      xpReward: 12,
      coinReward: 4,
      difficulty: 2,
      category: 'buah',
    ),

    // ================================================================
    // 5. FILL IN THE BLANK — Isi Kalimat Rumpang
    // ================================================================

    Question(
      id: 'fb_001',
      questionType: QuestionType.fillInTheBlank,
      questionText: 'Aku suka makan ___ yang manis dan kuning.',
      instruction: 'Isi kata yang hilang!',
      character: CharacterType.hazel,
      hint: 'Buah ini berbentuk melengkung',
      correctAnswer: 'pisang',
      options: [
        AnswerOption(id: 'fb_001_a', text: 'pisang', emoji: '🍌', isCorrect: true),
        AnswerOption(id: 'fb_001_b', text: 'apel', emoji: '🍎'),
        AnswerOption(id: 'fb_001_c', text: 'nasi', emoji: '🍚'),
      ],
      feedbackCorrect: 'Tepat! Pisang memang manis dan kuning!',
      feedbackWrong: 'Baca pelan-pelan, buah mana yang kuning dan manis?',
      xpReward: 12,
      coinReward: 4,
      difficulty: 2,
      category: 'buah',
    ),

    Question(
      id: 'fb_002',
      questionType: QuestionType.fillInTheBlank,
      questionText: 'Setiap pagi, ___ terbit dari arah timur.',
      instruction: 'Isi kata yang hilang!',
      character: CharacterType.hazel,
      hint: 'Benda langit yang cerah dan hangat',
      correctAnswer: 'matahari',
      options: [
        AnswerOption(id: 'fb_002_a', text: 'bulan', emoji: '🌙'),
        AnswerOption(id: 'fb_002_b', text: 'matahari', emoji: '☀️', isCorrect: true),
        AnswerOption(id: 'fb_002_c', text: 'bintang', emoji: '⭐'),
      ],
      feedbackCorrect: 'Pintar! Matahari selalu terbit di pagi hari!',
      feedbackWrong: 'Apa yang terbit setiap pagi dan menerangi bumi?',
      xpReward: 12,
      coinReward: 4,
      difficulty: 2,
      category: 'alam',
    ),

    // ================================================================
    // 6. ARRANGE WORDS — Susun Kata Menjadi Kalimat
    // ================================================================

    Question(
      id: 'aw_001',
      questionType: QuestionType.arrangeWords,
      questionText: 'Susun kata-kata ini menjadi kalimat yang benar!',
      instruction: 'Sentuh kata satu per satu dalam urutan yang benar!',
      character: CharacterType.hazel,
      fragments: [
        WordFragment(id: 'aw_001_1', text: 'Saya', correctPosition: 0),
        WordFragment(id: 'aw_001_2', text: 'suka', correctPosition: 1),
        WordFragment(id: 'aw_001_3', text: 'membaca', correctPosition: 2),
        WordFragment(id: 'aw_001_4', text: 'buku', correctPosition: 3),
      ],
      feedbackCorrect: 'Bagus sekali! Kalimatnya sudah benar!',
      feedbackWrong: 'Coba urutkan lagi, kata mana yang paling depan?',
      xpReward: 15,
      coinReward: 5,
      difficulty: 2,
      category: 'awal',
    ),

    Question(
      id: 'aw_002',
      questionType: QuestionType.arrangeWords,
      questionText: 'Susun kata-kata ini menjadi kalimat yang benar!',
      instruction: 'Pilih kata dalam urutan yang tepat, ya!',
      character: CharacterType.hazel,
      fragments: [
        WordFragment(id: 'aw_002_1', text: 'Kucing', correctPosition: 0),
        WordFragment(id: 'aw_002_2', text: 'itu', correctPosition: 1),
        WordFragment(id: 'aw_002_3', text: 'sedang', correctPosition: 2),
        WordFragment(id: 'aw_002_4', text: 'tidur', correctPosition: 3),
      ],
      feedbackCorrect: 'Hebat! Kamu bisa menyusun kalimat dengan benar!',
      feedbackWrong: 'Ingat, siapa dulu baru apa yang dilakukan?',
      xpReward: 15,
      coinReward: 5,
      difficulty: 2,
      category: 'hewan',
    ),

    // ================================================================
    // 7. PICK CORRECT IMAGE — Pilih Gambar yang Benar
    // ================================================================

    Question(
      id: 'pi_001',
      questionType: QuestionType.pickCorrectImage,
      questionText: 'Gambar mana yang menunjukkan "Hujan"?',
      instruction: 'Pilih gambar yang tepat!',
      character: CharacterType.alby,
      options: [
        AnswerOption(id: 'pi_001_a', text: 'Matahari', emoji: '☀️'),
        AnswerOption(id: 'pi_001_b', text: 'Hujan', emoji: '🌧️', isCorrect: true),
        AnswerOption(id: 'pi_001_c', text: 'Salju', emoji: '❄️'),
        AnswerOption(id: 'pi_001_d', text: 'Angin', emoji: '💨'),
      ],
      feedbackCorrect: 'Tepat! Hujan turun dari awan!',
      feedbackWrong: 'Mana yang menunjukkan air turun dari langit?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'alam',
    ),

    Question(
      id: 'pi_002',
      questionType: QuestionType.pickCorrectImage,
      questionText: 'Gambar mana yang menunjukkan "Sekolah"?',
      instruction: 'Pilih gambar yang tepat!',
      character: CharacterType.alby,
      options: [
        AnswerOption(id: 'pi_002_a', text: 'Rumah', emoji: '🏠'),
        AnswerOption(id: 'pi_002_b', text: 'Sekolah', emoji: '🏫', isCorrect: true),
        AnswerOption(id: 'pi_002_c', text: 'Toko', emoji: '🏪'),
        AnswerOption(id: 'pi_002_d', text: 'Rumah Sakit', emoji: '🏥'),
      ],
      feedbackCorrect: 'Benar! Sekolah adalah tempat kita belajar!',
      feedbackWrong: 'Tempat mana yang kita kunjungi untuk belajar?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'tempat',
    ),

    // ================================================================
    // 8. DRAG & DROP — Pasangan Kata
    // ================================================================

    Question(
      id: 'dd_001',
      questionType: QuestionType.dragAndDrop,
      questionText: 'Pasangkan hewan dengan suaranya!',
      instruction: 'Pilih pasangan yang benar!',
      character: CharacterType.alby,
      fragments: [
        WordFragment(id: 'dd_001_1', text: 'Kucing → Meong', correctPosition: 0),
        WordFragment(id: 'dd_001_2', text: 'Anjing → Guk guk', correctPosition: 1),
        WordFragment(id: 'dd_001_3', text: 'Ayam → Kukuruyuk', correctPosition: 2),
        WordFragment(id: 'dd_001_4', text: 'Sapi → Mooo', correctPosition: 3),
      ],
      options: [
        AnswerOption(id: 'dd_001_a', text: 'Kucing → Meong', emoji: '🐱', isCorrect: true),
        AnswerOption(id: 'dd_001_b', text: 'Anjing → Guk guk', emoji: '🐶'),
        AnswerOption(id: 'dd_001_c', text: 'Ayam → Kukuruyuk', emoji: '🐔'),
        AnswerOption(id: 'dd_001_d', text: 'Sapi → Mooo', emoji: '🐮'),
      ],
      feedbackCorrect: 'Hebat! Kamu tahu suara semua hewan!',
      feedbackWrong: 'Coba ingat lagi, hewan mana yang suaranya seperti itu?',
      xpReward: 15,
      coinReward: 5,
      difficulty: 2,
      category: 'hewan',
    ),

    // ================================================================
    // 9. ORDER STORY — Urutkan Cerita
    // ================================================================

    Question(
      id: 'os_001',
      questionType: QuestionType.orderStory,
      questionText: 'Urutkan cerita ini dengan benar!',
      instruction: 'Pilih kalimat satu per satu dalam urutan yang tepat!',
      character: CharacterType.hazel,
      storySteps: [
        StoryStep(id: 'os_001_1', text: 'Pagi-pagi, Rani bangun tidur.', emoji: '🌅', correctPosition: 0),
        StoryStep(id: 'os_001_2', text: 'Rani sarapan roti dan susu.', emoji: '🍞', correctPosition: 1),
        StoryStep(id: 'os_001_3', text: 'Lalu, Rani berangkat ke sekolah.', emoji: '🏫', correctPosition: 2),
        StoryStep(id: 'os_001_4', text: 'Di sekolah, Rani belajar membaca.', emoji: '📖', correctPosition: 3),
      ],
      feedbackCorrect: 'Ceritanya sudah runtut! Kamu pintar menyusun cerita!',
      feedbackWrong: 'Ingat, cerita dimulai dari pagi, lalu apa yang terjadi berikutnya?',
      xpReward: 18,
      coinReward: 6,
      difficulty: 2,
      category: 'awal',
    ),

    Question(
      id: 'os_002',
      questionType: QuestionType.orderStory,
      questionText: 'Urutkan cerita ini dengan benar!',
      instruction: 'Apa yang terjadi duluan, ya?',
      character: CharacterType.hazel,
      storySteps: [
        StoryStep(id: 'os_002_1', text: 'Budi melihat kupu-kupu di taman.', emoji: '🦋', correctPosition: 0),
        StoryStep(id: 'os_002_2', text: 'Kupu-kupu itu hinggap di bunga.', emoji: '🌸', correctPosition: 1),
        StoryStep(id: 'os_002_3', text: 'Budi menggambar kupu-kupu itu.', emoji: '✏️', correctPosition: 2),
        StoryStep(id: 'os_002_4', text: 'Gambar Budi sangat bagus!', emoji: '🎨', correctPosition: 3),
      ],
      feedbackCorrect: 'Bagus sekali! Ceritanya jadi seru!',
      feedbackWrong: 'Pikirkan apa yang terjadi duluan di cerita ini!',
      xpReward: 18,
      coinReward: 6,
      difficulty: 2,
      category: 'alam',
    ),

    // ================================================================
    // 10. PICK INITIAL LETTER — Pilih Huruf Awal
    // ================================================================

    Question(
      id: 'il_001',
      questionType: QuestionType.pickInitialLetter,
      questionText: 'Huruf awal gambar ini apa?',
      instruction: 'Pilih huruf pertama dari kata ini!',
      emoji: '🍎',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'il_001_a', text: 'A', isCorrect: true),
        AnswerOption(id: 'il_001_b', text: 'I'),
        AnswerOption(id: 'il_001_c', text: 'U'),
        AnswerOption(id: 'il_001_d', text: 'E'),
      ],
      feedbackCorrect: 'Benar! Apel dimulai dengan huruf A!',
      feedbackWrong: 'Apel... huruf pertamanya apa ya?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'awal',
    ),

    Question(
      id: 'il_002',
      questionType: QuestionType.pickInitialLetter,
      questionText: 'Huruf awal gambar ini apa?',
      instruction: 'Pilih huruf pertamanya, ya!',
      emoji: '🐱',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'il_002_a', text: 'B'),
        AnswerOption(id: 'il_002_b', text: 'K', isCorrect: true),
        AnswerOption(id: 'il_002_c', text: 'M'),
        AnswerOption(id: 'il_002_d', text: 'S'),
      ],
      feedbackCorrect: 'Pintar! Kucing dimulai dengan huruf K!',
      feedbackWrong: 'Kucing... huruf pertamanya apa ya?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'il_003',
      questionType: QuestionType.pickInitialLetter,
      questionText: 'Huruf awal nama hewan ini apa?',
      instruction: 'Lihat gambarnya, lalu pilih huruf awalnya!',
      emoji: '🐘',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'il_003_a', text: 'G', isCorrect: true),
        AnswerOption(id: 'il_003_b', text: 'J'),
        AnswerOption(id: 'il_003_c', text: 'H'),
        AnswerOption(id: 'il_003_d', text: 'K'),
      ],
      feedbackCorrect: 'Hebat! Gajah dimulai dengan huruf G!',
      feedbackWrong: 'Gajah... huruf pertamanya apa?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'il_004',
      questionType: QuestionType.pickInitialLetter,
      questionText: 'Huruf awal bunga ini apa?',
      instruction: 'Pilih huruf pertamanya!',
      emoji: '🌸',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'il_004_a', text: 'M'),
        AnswerOption(id: 'il_004_b', text: 'P'),
        AnswerOption(id: 'il_004_c', text: 'B', isCorrect: true),
        AnswerOption(id: 'il_004_d', text: 'T'),
      ],
      feedbackCorrect: 'Tepat! Bunga dimulai dengan huruf B!',
      feedbackWrong: 'Bunga... huruf pertamanya apa ya?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'alam',
    ),

    // ================================================================
    // ADDITIONAL VARIETY — More questions for longer sessions
    // ================================================================

    Question(
      id: 'mc_005',
      questionType: QuestionType.multipleChoice,
      questionText: 'Hewan apa yang bisa terbang?',
      instruction: 'Pilih jawaban yang benar!',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'mc_005_a', text: 'Ikan', emoji: '🐟'),
        AnswerOption(id: 'mc_005_b', text: 'Burung', emoji: '🐦', isCorrect: true),
        AnswerOption(id: 'mc_005_c', text: 'Sapi', emoji: '🐮'),
        AnswerOption(id: 'mc_005_d', text: 'Kucing', emoji: '🐱'),
      ],
      feedbackCorrect: 'Benar! Burung punya sayap untuk terbang!',
      feedbackWrong: 'Hewan mana yang punya sayap?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'tf_005',
      questionType: QuestionType.trueFalse,
      questionText: 'Roti itu termasuk minuman?',
      instruction: 'Benar atau salah?',
      character: CharacterType.hazel,
      options: [
        AnswerOption(id: 'tf_005_b', text: 'Benar', emoji: '✅'),
        AnswerOption(id: 'tf_005_s', text: 'Salah', emoji: '❌', isCorrect: true),
      ],
      feedbackCorrect: 'Tepat! Roti itu makanan, bukan minuman!',
      feedbackWrong: 'Roti itu makanan loh, bukan minuman!',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'makanan',
    ),

    Question(
      id: 'mc_006',
      questionType: QuestionType.multipleChoice,
      questionText: 'Warna rumput itu apa?',
      instruction: 'Pilih warna yang benar!',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'mc_006_a', text: 'Merah', emoji: '🔴'),
        AnswerOption(id: 'mc_006_b', text: 'Biru', emoji: '🔵'),
        AnswerOption(id: 'mc_006_c', text: 'Hijau', emoji: '🟢', isCorrect: true),
        AnswerOption(id: 'mc_006_d', text: 'Kuning', emoji: '🟡'),
      ],
      feedbackCorrect: 'Benar! Rumput itu hijau segar!',
      feedbackWrong: 'Lihat rumput di halaman, warnanya apa?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'warna',
    ),

    Question(
      id: 'mw_003',
      questionType: QuestionType.matchWordImage,
      questionText: 'Gambar mana yang cocok dengan kata "Susu"?',
      instruction: 'Pilih gambar yang cocok!',
      character: CharacterType.alby,
      options: [
        AnswerOption(id: 'mw_003_a', text: 'Air', emoji: '💧'),
        AnswerOption(id: 'mw_003_b', text: 'Susu', emoji: '🥛', isCorrect: true),
        AnswerOption(id: 'mw_003_c', text: 'Jus', emoji: '🧃'),
        AnswerOption(id: 'mw_003_d', text: 'Teh', emoji: '🍵'),
      ],
      feedbackCorrect: 'Tepat! Susu itu putih dan sehat!',
      feedbackWrong: 'Mana yang putih dan enak diminum?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'minuman',
    ),

    Question(
      id: 'fb_003',
      questionType: QuestionType.fillInTheBlank,
      questionText: 'Ibu memasak ___ di dapur.',
      instruction: 'Isi kata yang hilang!',
      character: CharacterType.hazel,
      hint: 'Makanan pokok orang Indonesia, warnanya putih',
      correctAnswer: 'nasi',
      options: [
        AnswerOption(id: 'fb_003_a', text: 'nasi', emoji: '🍚', isCorrect: true),
        AnswerOption(id: 'fb_003_b', text: 'buku', emoji: '📖'),
        AnswerOption(id: 'fb_003_c', text: 'meja', emoji: '🪑'),
      ],
      feedbackCorrect: 'Benar! Nasi adalah makanan kita sehari-hari!',
      feedbackWrong: 'Apa yang biasa ibu masak di dapur?',
      xpReward: 12,
      coinReward: 4,
      difficulty: 2,
      category: 'makanan',
    ),

    Question(
      id: 'pi_003',
      questionType: QuestionType.pickCorrectImage,
      questionText: 'Gambar mana yang menunjukkan "Bunga"?',
      instruction: 'Pilih gambarnya, ya!',
      character: CharacterType.alby,
      options: [
        AnswerOption(id: 'pi_003_a', text: 'Pohon', emoji: '🌳'),
        AnswerOption(id: 'pi_003_b', text: 'Bunga', emoji: '🌸', isCorrect: true),
        AnswerOption(id: 'pi_003_c', text: 'Rumput', emoji: '🌿'),
        AnswerOption(id: 'pi_003_d', text: 'Batang', emoji: '🪵'),
      ],
      feedbackCorrect: 'Cantik! Bunga memang indah, ya!',
      feedbackWrong: 'Mana yang punya kelopak yang indah?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'alam',
    ),

    Question(
      id: 'il_005',
      questionType: QuestionType.pickInitialLetter,
      questionText: 'Huruf awal gambar ini apa?',
      instruction: 'Pilih huruf pertamanya!',
      emoji: '🐟',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'il_005_a', text: 'A'),
        AnswerOption(id: 'il_005_b', text: 'I', isCorrect: true),
        AnswerOption(id: 'il_005_c', text: 'U'),
        AnswerOption(id: 'il_005_d', text: 'B'),
      ],
      feedbackCorrect: 'Hebat! Ikan dimulai dengan huruf I!',
      feedbackWrong: 'Ikan... huruf awalnya apa ya?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'lc_003',
      questionType: QuestionType.listenAndChoose,
      questionText: 'Dengarkan suaranya, warna apa yang kamu dengar?',
      instruction: 'Tekan tombol play, lalu pilih warnanya!',
      character: CharacterType.alby,
      hint: 'Warna daun dan rumput',
      correctAnswer: 'Hijau',
      options: [
        AnswerOption(id: 'lc_003_a', text: 'Merah', emoji: '🔴'),
        AnswerOption(id: 'lc_003_b', text: 'Hijau', emoji: '🟢', isCorrect: true),
        AnswerOption(id: 'lc_003_c', text: 'Biru', emoji: '🔵'),
        AnswerOption(id: 'lc_003_d', text: 'Kuning', emoji: '🟡'),
      ],
      feedbackCorrect: 'Tepat! Hijau seperti daun dan rumput!',
      feedbackWrong: 'Warna apa yang sama dengan daun?',
      xpReward: 12,
      coinReward: 4,
      difficulty: 2,
      category: 'warna',
    ),

    Question(
      id: 'tf_006',
      questionType: QuestionType.trueFalse,
      questionText: 'Kucing suka makan ikan?',
      instruction: 'Benar atau salah?',
      character: CharacterType.zelby,
      options: [
        AnswerOption(id: 'tf_006_b', text: 'Benar', emoji: '✅', isCorrect: true),
        AnswerOption(id: 'tf_006_s', text: 'Salah', emoji: '❌'),
      ],
      feedbackCorrect: 'Ya! Kucing memang suka ikan!',
      feedbackWrong: 'Kucing itu suka sekali makan ikan, lho!',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'hewan',
    ),

    Question(
      id: 'mc_007',
      questionType: QuestionType.multipleChoice,
      questionText: 'Siapa yang membacakan cerita sebelum tidur?',
      instruction: 'Pilih jawaban yang benar!',
      character: CharacterType.hazel,
      options: [
        AnswerOption(id: 'mc_007_a', text: 'Ibu', emoji: '👩', isCorrect: true),
        AnswerOption(id: 'mc_007_b', text: 'Meja', emoji: '🪑'),
        AnswerOption(id: 'mc_007_c', text: 'Buku', emoji: '📖'),
        AnswerOption(id: 'mc_007_d', text: 'Kursi', emoji: '💺'),
      ],
      feedbackCorrect: 'Benar! Ibu sering membacakan cerita untuk kita!',
      feedbackWrong: 'Siapa orang yang membacakan cerita dongeng?',
      xpReward: 10,
      coinReward: 3,
      difficulty: 1,
      category: 'keluarga',
    ),

    Question(
      id: 'aw_003',
      questionType: QuestionType.arrangeWords,
      questionText: 'Susun kata-kata ini menjadi kalimat yang benar!',
      instruction: 'Urutkan katanya, ya!',
      character: CharacterType.hazel,
      fragments: [
        WordFragment(id: 'aw_003_1', text: 'Ayah', correctPosition: 0),
        WordFragment(id: 'aw_003_2', text: 'bekerja', correctPosition: 1),
        WordFragment(id: 'aw_003_3', text: 'di', correctPosition: 2),
        WordFragment(id: 'aw_003_4', text: 'kantor', correctPosition: 3),
      ],
      feedbackCorrect: 'Sempurna! Kalimatnya sudah benar!',
      feedbackWrong: 'Siapa yang melakukan, lalu apa yang dilakukan?',
      xpReward: 15,
      coinReward: 5,
      difficulty: 2,
      category: 'keluarga',
    ),
  ];
}
