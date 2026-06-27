import 'package:flutter/foundation.dart';
import '../types.dart';
import '../implementations/curriculum_agent.dart';
import '../implementations/question_agent.dart';
import '../implementations/difficulty_agent.dart';
import '../implementations/hint_agent.dart';
import '../implementations/feedback_agent.dart';
import '../implementations/safety_agent.dart';
import '../implementations/ux_agent.dart';
import '../implementations/performance_agent.dart';
import '../../../features/lesson/domain/lesson.dart';

typedef AgentCallback = void Function(String agentName, String action, Map<String, dynamic>? data);

class LessonOrchestrator {
  final CurriculumAgent curriculum;
  final QuestionAgent question;
  final DifficultyAgent difficulty;
  final HintAgent hint;
  final FeedbackAgent feedback;
  final SafetyAgent safety;
  final UXAgent ux;
  final PerformanceAgent performance;

  AgentCallback? onAgentAction;

  LessonOrchestrator({
    this.onAgentAction,
  }) : curriculum = CurriculumAgent(),
       question = QuestionAgent(),
       difficulty = DifficultyAgent(),
       hint = HintAgent(),
       feedback = FeedbackAgent(),
       safety = SafetyAgent(),
       ux = UXAgent(),
       performance = PerformanceAgent();

  void _track(String name, String action, [Map<String, dynamic>? data]) {
    onAgentAction?.call(name, action, data);
    debugPrint('[Agent:$name] $action');
  }

  Future<LessonQuestion> prepareNextQuestion({
    required LessonType type,
    required String skillId,
    required DifficultyLevel currentDifficulty,
    required int consecutiveCorrect,
    required int consecutiveWrong,
    required List<String> keywords,
    String? imageContext,
  }) async {
    _track('orchestrator', 'prepare_question', {'type': type.name, 'skill': skillId});

    final diffResult = await difficulty.process(DifficultySpec(
      consecutiveCorrect: consecutiveCorrect,
      consecutiveWrong: consecutiveWrong,
      currentLevel: currentDifficulty,
    ));
    _track('difficulty', 'adjusted', diffResult);

    final effectiveDifficulty = diffResult['difficultyLevel'] as DifficultyLevel;

    final questionResult = await question.process(QuestionSpec(
      skillId: skillId,
      difficulty: effectiveDifficulty,
      preferredType: type,
      keywords: keywords,
      imageContext: imageContext,
    ));
    _track('question', 'generated', {'type': type.name, 'difficulty': effectiveDifficulty.name});

    final safetyResult = await safety.process(questionResult);
    if (!safetyResult.passed) {
      _track('safety', 'rejected', {'reason': safetyResult.rejectedReason});
      return await _fallbackQuestion(type, skillId, keywords);
    }

    if (safetyResult.warnings.isNotEmpty) {
      _track('safety', 'warnings', {'warnings': safetyResult.warnings});
    }

    return questionResult;
  }

  Future<Map<String, dynamic>> getHint({
    required String questionId,
    required LessonType questionType,
    required String correctAnswer,
    required List<String> options,
    required int attemptsUsed,
    required DifficultyLevel difficulty,
    String? childName,
  }) async {
    _track('orchestrator', 'request_hint');

    final result = await hint.process(HintSpec(
      questionId: questionId,
      questionType: questionType,
      correctAnswer: correctAnswer,
      options: options,
      attemptsUsed: attemptsUsed,
      difficulty: difficulty,
      childName: childName,
    ));
    _track('hint', 'provided', {'level': result['level']});
    return result;
  }

  Future<Map<String, dynamic>> generateFeedback({
    required bool isCorrect,
    required String questionType,
    required String childName,
    required int streak,
    required int xpEarned,
    required int attemptsUsed,
    String? correctAnswer,
    String? childAnswer,
  }) async {
    _track('orchestrator', 'generate_feedback');

    final result = await feedback.process(FeedbackSpec(
      isCorrect: isCorrect,
      questionType: questionType,
      childName: childName,
      streak: streak,
      xpEarned: xpEarned,
      attemptsUsed: attemptsUsed,
      correctAnswer: correctAnswer,
      childAnswer: childAnswer,
    ));
    _track('feedback', isCorrect ? 'correct' : 'incorrect', result);
    return result;
  }

  Future<Map<String, dynamic>> determineUX({
    required int childAge,
    required int sessionDurationMinutes,
    required int errorsInLastMinute,
    required double responseTimeAvg,
    required bool isNewUser,
  }) async {
    _track('orchestrator', 'determine_ux');

    final result = await ux.process(UXSpec(
      childAge: childAge,
      sessionDurationMinutes: sessionDurationMinutes,
      errorsInLastMinute: errorsInLastMinute,
      responseTimeAvg: responseTimeAvg,
      isNewUser: isNewUser,
    ));
    _track('ux', 'mode_set', {'mode': result['uiMode']});
    return result;
  }

  Future<Map<String, dynamic>> optimizePerformance(
    AgentContext context,
  ) async {
    _track('orchestrator', 'optimize_performance');

    final result = await performance.process(context);
    _track('performance', 'optimized', {
      'cacheStrategy': result['cacheStrategy'],
      'useLocalFallback': result['useLocalFallback'],
    });
    return result;
  }

  Future<Map<String, dynamic>> planCurriculum({
    required int currentLevelIndex,
    required double masteryScore,
    required List<String> completedSkills,
    required int streak,
  }) async {
    _track('orchestrator', 'plan_curriculum');

    final result = await curriculum.process(CurriculumSpec(
      currentLevelIndex: currentLevelIndex,
      masteryScore: masteryScore,
      completedSkills: completedSkills,
      streak: streak,
    ));

    _track('curriculum', 'planned', {
      'nextLevel': result['nextLevelIndex'],
      'action': result['action'],
    });
    return result;
  }

  Future<LessonQuestion> _fallbackQuestion(
    LessonType type,
    String skillId,
    List<String> keywords,
  ) async {
    return await question.process(QuestionSpec(
      skillId: skillId,
      difficulty: DifficultyLevel.warmup,
      preferredType: type,
      keywords: keywords,
    ));
  }

  void reset() {}
}
