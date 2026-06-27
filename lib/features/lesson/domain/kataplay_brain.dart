import 'dart:math';

import '../domain/lesson.dart';
import '../../profile/data/models/user_progress.dart';
import 'brain_types.dart';

class KataPlayBrain {
  const KataPlayBrain();

  BrainLessonSession buildSession({
    required Level level,
    required Lesson lesson,
    required UserProgress progress,
  }) {
    final adaptiveSeed = _buildSeed(
      levelNumber: level.levelNumber,
      progress: progress,
      lesson: lesson,
    );

    return BrainLessonSession(
      lessonId: lesson.id,
      title: lesson.title,
      character: lesson.character,
      openingLine: _openingLineFor(level, lesson, progress),
      focusLabel: _focusLabelFor(level, progress),
      adaptiveSeed: adaptiveSeed,
      questions: List.generate(
        lesson.questions.length,
        (index) => _decorateQuestion(
          question: lesson.questions[index],
          level: level,
          lesson: lesson,
          progress: progress,
          questionIndex: index,
          adaptiveSeed: adaptiveSeed,
        ),
      ),
    );
  }

  BrainFeedback evaluate({
    required BrainLessonSession session,
    required int questionIndex,
    required bool isCorrect,
    required int attempts,
  }) {
    final question = session.questions[questionIndex];

    if (isCorrect) {
      final messages = switch (question.difficulty) {
        BrainDifficulty.warmup => ['Bagus!', 'Sip!', 'Mantap!'],
        BrainDifficulty.focus => ['Hebat!', 'Keren!', 'Pintar!'],
        BrainDifficulty.challenge => ['Luar biasa!', 'Kamu jago!', 'Top banget!'],
      };

      final subtitles = <String>[
        question.microGoal,
        'Kamu berhasil menyelesaikan bagian ini dengan baik.',
        attempts > 0
            ? 'Tetap semangat, kamu bisa memperbaiki jawabanmu.'
            : 'Jawabanmu cepat dan tepat.',
      ];

      final pick = (session.adaptiveSeed + questionIndex + attempts) % messages.length;
      final subtitlePick =
          (session.adaptiveSeed + questionIndex + attempts) % subtitles.length;

      return BrainFeedback(
        message: messages[pick],
        subtitle: subtitles[subtitlePick],
        mood: question.difficulty == BrainDifficulty.challenge
            ? 'celebrate'
            : 'happy',
      );
    }

    final supportiveMessages = switch (question.difficulty) {
      BrainDifficulty.warmup => ['Ayo coba lagi!', 'Sedikit lagi!', 'Pelan-pelan ya!'],
      BrainDifficulty.focus => ['Hampir benar!', 'Coba lihat lagi!', 'Kamu pasti bisa!'],
      BrainDifficulty.challenge => ['Ini tantangan seru!', 'Tenang, kita bantu ya!', 'Yuk pecahkan bersama!'],
    };

    final pick =
        (session.adaptiveSeed + questionIndex + attempts) % supportiveMessages.length;

    return BrainFeedback(
      message: supportiveMessages[pick],
      subtitle: attempts > 1
          ? 'Gunakan petunjuk pintar supaya lebih mudah.'
          : 'Perhatikan lagi petunjuk dan pilihan jawaban.',
      mood: question.difficulty == BrainDifficulty.challenge
          ? 'encouraging'
          : 'thinking',
      revealedHint: question.smartHint,
    );
  }

  int _buildSeed({
    required int levelNumber,
    required UserProgress progress,
    required Lesson lesson,
  }) {
    return (levelNumber * 97) +
        (progress.completedLessonIds.length * 31) +
        (progress.xp * 3) +
        lesson.questions.length;
  }

  BrainQuestionPayload _decorateQuestion({
    required LessonQuestion question,
    required Level level,
    required Lesson lesson,
    required UserProgress progress,
    required int questionIndex,
    required int adaptiveSeed,
  }) {
    final difficulty = _difficultyFor(
      levelNumber: level.levelNumber,
      question: question,
      questionIndex: questionIndex,
      progress: progress,
    );

    return BrainQuestionPayload(
      source: question,
      options: _buildOptions(
        question: question,
        adaptiveSeed: adaptiveSeed,
        questionIndex: questionIndex,
      ),
      prompt: question.instruction,
      coachMessage: _coachMessageFor(
        question: question,
        lesson: lesson,
        difficulty: difficulty,
      ),
      microGoal: _microGoalFor(question),
      smartHint: _smartHintFor(question),
      difficulty: difficulty,
    );
  }

  List<String> _buildOptions({
    required LessonQuestion question,
    required int adaptiveSeed,
    required int questionIndex,
  }) {
    if (question.options.length <= 1 || question.type == LessonType.trueFalse) {
      return List<String>.from(question.options);
    }

    final shuffled = List<String>.from(question.options);
    shuffled.shuffle(Random(adaptiveSeed + (questionIndex * 11)));

    if (!shuffled.contains(question.correctAnswer)) {
      shuffled.insert(0, question.correctAnswer);
    }

    return shuffled.toSet().toList(growable: false);
  }

  BrainDifficulty _difficultyFor({
    required int levelNumber,
    required LessonQuestion question,
    required int questionIndex,
    required UserProgress progress,
  }) {
    if (question.type == LessonType.readSentence ||
        question.type == LessonType.arrangeWord ||
        levelNumber >= 7) {
      return BrainDifficulty.challenge;
    }

    if (question.type == LessonType.matching ||
        question.type == LessonType.fillBlank ||
        levelNumber >= 4 ||
        questionIndex >= 2 ||
        progress.currentLevelIndex >= 2) {
      return BrainDifficulty.focus;
    }

    return BrainDifficulty.warmup;
  }

  String _openingLineFor(Level level, Lesson lesson, UserProgress progress) {
    if (progress.completedLessonIds.contains(lesson.id)) {
      return 'Kita ulangi ${lesson.title} dengan tantangan yang lebih pintar.';
    }

    if (level.levelNumber <= 2) {
      return 'Yuk mulai dari langkah kecil, lalu kita naik pelan-pelan.';
    }

    if (level.levelNumber >= 6) {
      return 'Hari ini kita masuk ke latihan yang lebih menantang dan seru.';
    }

    return 'Aku sudah siapkan soal yang pas dengan levelmu sekarang.';
  }

  String _focusLabelFor(Level level, UserProgress progress) {
    if (progress.streak >= 7) return 'Mode Pintar Aktif';
    if (level.levelNumber >= 6) return 'Mode Tantangan';
    if (progress.completedLessonIds.isEmpty) return 'Mode Pendamping';
    return 'Mode Adaptif';
  }

  String _coachMessageFor({
    required LessonQuestion question,
    required Lesson lesson,
    required BrainDifficulty difficulty,
  }) {
    final prefix = switch (difficulty) {
      BrainDifficulty.warmup => 'Kita mulai ringan dulu.',
      BrainDifficulty.focus => 'Fokus, lihat baik-baik.',
      BrainDifficulty.challenge => 'Siap untuk tantangan kecil?',
    };

    final suffix = switch (question.type) {
      LessonType.imageChoice => 'Pilih gambar atau huruf yang paling cocok.',
      LessonType.wordChoice => 'Cari jawaban yang paling tepat.',
      LessonType.trueFalse => 'Tentukan apakah pernyataannya benar atau salah.',
      LessonType.arrangeWord => 'Susun bagian kata sampai menjadi lengkap.',
      LessonType.fillBlank => 'Cari huruf yang hilang supaya kata jadi benar.',
      LessonType.matching => 'Hubungkan petunjuk dengan jawaban yang sesuai.',
      LessonType.readSentence => 'Baca dulu kalimatnya, lalu jawab dengan tenang.',
    };

    return '$prefix $suffix';
  }

  String _microGoalFor(LessonQuestion question) {
    return switch (question.type) {
      LessonType.imageChoice => 'Kenali bentuk dan simbol utama.',
      LessonType.wordChoice => 'Latih fokus memilih kata yang tepat.',
      LessonType.trueFalse => 'Bandingkan petunjuk dan jawaban dengan cepat.',
      LessonType.arrangeWord => 'Susun pola kata secara runtut.',
      LessonType.fillBlank => 'Lengkapi huruf yang hilang.',
      LessonType.matching => 'Cocokkan petunjuk dengan maknanya.',
      LessonType.readSentence => 'Pahami isi kalimat sebelum memilih jawaban.',
    };
  }

  String _smartHintFor(LessonQuestion question) {
    final baseHint = question.hint?.trim();
    if (baseHint != null && baseHint.isNotEmpty) {
      return 'Petunjuk pintar: $baseHint';
    }

    return switch (question.type) {
      LessonType.imageChoice => 'Lihat bentuk huruf atau gambar yang paling mirip dengan jawaban benar.',
      LessonType.wordChoice => 'Baca semua pilihan pelan-pelan dan cari kata yang paling pas.',
      LessonType.trueFalse => 'Cek lagi apakah petunjuk mendukung jawaban Benar atau Salah.',
      LessonType.arrangeWord => 'Susun dari bunyi atau bagian kata yang paling familiar dulu.',
      LessonType.fillBlank => 'Bayangkan kata lengkapnya, lalu cari huruf yang hilang.',
      LessonType.matching => 'Perhatikan hubungan antara simbol, kata, dan petunjuk.',
      LessonType.readSentence => 'Cari kata kunci penting di dalam kalimat sebelum menjawab.',
    };
  }
}
