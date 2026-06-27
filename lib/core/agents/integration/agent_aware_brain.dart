import 'dart:math';
import '../../../features/lesson/domain/lesson.dart';
import '../../../features/lesson/domain/brain_types.dart';
import '../../../features/profile/data/models/user_progress.dart';
import '../../constants/app_constants.dart';
import '../orchestrator/lesson_orchestrator.dart';
import '../types.dart';

class AgentAwareBrain {
  final LessonOrchestrator orchestrator;

  AgentAwareBrain({LessonOrchestrator? orchestrator})
      : orchestrator = orchestrator ?? LessonOrchestrator();

  Future<BrainLessonSession> buildSession({
    required Level level,
    required Lesson lesson,
    required UserProgress progress,
  }) async {
    await orchestrator.planCurriculum(
      currentLevelIndex: progress.currentLevelIndex,
      masteryScore: _calculateMastery(progress),
      completedSkills: progress.completedLessonIds.toList(),
      streak: progress.streak,
    );

    final questions = <BrainQuestionPayload>[];
    for (int i = 0; i < lesson.questions.length; i++) {
      final src = lesson.questions[i];

      final difficulty = _difficultyFor(progress, i);

      final seed = level.levelNumber * 1000 + lesson.questions.length * 100 + i;
      final questionSeed = level.levelNumber * 1000 + i;
      final agentRng = Random(seed);

      final question = await orchestrator.prepareNextQuestion(
        type: src.type,
        skillId: '${lesson.id}_$questionSeed',
        currentDifficulty: _mapDifficulty(difficulty),
        consecutiveCorrect: _recentCorrect(progress),
        consecutiveWrong: 0,
        keywords: [src.correctAnswer],
        imageContext: src.imageAsset,
      );

      final useAgentQuestion = agentRng.nextDouble() < 0.8;
      final effectiveQ = useAgentQuestion ? question : src;

      final hintResult = await orchestrator.getHint(
        questionId: 'q$i',
        questionType: effectiveQ.type,
        correctAnswer: effectiveQ.correctAnswer,
        options: effectiveQ.options,
        attemptsUsed: 0,
        difficulty: _mapDifficulty(difficulty),
      );

      questions.add(BrainQuestionPayload(
        source: effectiveQ,
        options: effectiveQ.options,
        prompt: _buildPrompt(src, seed),
        coachMessage: hintResult['text'] as String? ?? '',
        microGoal: _microGoalFor(level, i),
        smartHint: hintResult['text'] as String? ?? '',
        difficulty: difficulty,
      ));
    }

    return BrainLessonSession(
      lessonId: lesson.id,
      title: lesson.title,
      character: lesson.character,
      openingLine: _openingLineFor(level, lesson, progress),
      focusLabel: _focusLabelFor(progress),
      adaptiveSeed: level.levelNumber * 100 + lesson.questions.length,
      questions: questions,
    );
  }

  String _buildPrompt(LessonQuestion q, int seed) {
    if (q.imageAsset != null) return 'Lihat gambar dan pilih jawaban yang tepat';
    return q.instruction;
  }

  String _microGoalFor(Level level, int questionIndex) {
    final total = level.lessons.fold<int>(0, (sum, l) => sum + l.questions.length);
    final progress = ((questionIndex + 1) / total * 100).round();
    return 'Soal $progress% selesai';
  }

  double _calculateMastery(UserProgress progress) {
    final total = AppConstants.maxLevels * AppConstants.totalQuestionsPerSession;
    if (total <= 0) return 0;
    return progress.completedLessonIds.length / total;
  }

  String _openingLineFor(Level level, Lesson lesson, UserProgress progress) {
    if (progress.streak > 3) return 'Ayo lanjutkan streakmu!';
    return '${lesson.title} – Yuk kita belajar!';
  }

  String _focusLabelFor(UserProgress progress) {
    if (progress.xp < 50) return 'Pemula';
    if (progress.xp < 200) return 'Semakin Jago';
    return 'Master';
  }

  int _recentCorrect(UserProgress progress) {
    return progress.completedLessonIds.length > 3 ? 2 : 0;
  }

  BrainDifficulty _difficultyFor(UserProgress progress, int questionIndex) {
    if (progress.xp > 500) return BrainDifficulty.challenge;
    if (progress.xp > 100) return BrainDifficulty.focus;
    return BrainDifficulty.warmup;
  }

  DifficultyLevel _mapDifficulty(BrainDifficulty d) {
    switch (d) {
      case BrainDifficulty.warmup: return DifficultyLevel.warmup;
      case BrainDifficulty.focus: return DifficultyLevel.focus;
      case BrainDifficulty.challenge: return DifficultyLevel.challenge;
    }
  }
}
