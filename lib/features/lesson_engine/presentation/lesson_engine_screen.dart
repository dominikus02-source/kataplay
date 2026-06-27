import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/providers.dart';
import '../../curriculum/application/curriculum_provider.dart';
import '../application/lesson_controller.dart';
import '../application/lesson_state.dart';
import '../domain/lesson_result.dart';
import 'lesson_shell.dart';
import 'lesson_completion_screen.dart';

class LessonEngineScreen extends ConsumerStatefulWidget {
  final String? assetPath;
  final int? levelIndex;
  final String? lessonId;

  const LessonEngineScreen({
    super.key,
    this.assetPath,
    this.levelIndex,
    this.lessonId,
  });

  @override
  ConsumerState<LessonEngineScreen> createState() => _LessonEngineScreenState();
}

class _LessonEngineScreenState extends ConsumerState<LessonEngineScreen>
    implements LessonControllerListener {
  late LessonController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LessonController();
    _controller.addListener(this);
    _initLesson();
  }

  @override
  void onLessonStateChanged(LessonState state) {
    if (mounted) setState(() {});
  }

  Future<void> _initLesson() async {
    if (widget.lessonId != null) {
      final curriculumRepo = ref.read(curriculumRepositoryProvider);
      await _controller.loadLessonById(widget.lessonId!, curriculumRepo);
    } else if (widget.assetPath != null) {
      await _controller.loadLessonPack(assetPath: widget.assetPath);
    } else {
      await _controller.loadLessonPack();
    }
    if (_controller.state.steps.isNotEmpty) {
      _controller.startLesson();
    }
  }

  Future<void> _retry() async {
    _controller.reset();
    await _initLesson();
  }

  @override
  void dispose() {
    _controller.removeListener(this);
    super.dispose();
  }

  void _goBack() {
    context.pop();
  }

  void _onComplete() {
    final state = _controller.state;
    final effectiveLessonId =
        widget.lessonId ?? 'lesson_engine_${DateTime.now().millisecondsSinceEpoch}';
    final result = LessonResult(
      lessonId: effectiveLessonId,
      stepResults: state.stepResults,
      totalSteps: state.totalSteps,
      correctSteps: state.score,
      totalXpEarned: state.xpEarnedSoFar,
      completedAt: DateTime.now(),
    );

    ref.read(progressProvider.notifier).completeLesson(
          effectiveLessonId,
          result.totalXpEarned,
        );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    if (state.status == LessonStatus.completed) {
      final result = LessonResult(
        lessonId: 'lesson_engine_${DateTime.now().millisecondsSinceEpoch}',
        stepResults: state.stepResults,
        totalSteps: state.totalSteps,
        correctSteps: state.score,
        totalXpEarned: state.xpEarnedSoFar,
        completedAt: DateTime.now(),
      );

      return LessonCompletionContent(
        result: result,
        onContinue: _onComplete,
      );
    }

    return LessonShell(
      controller: _controller,
      state: state,
      onBack: _goBack,
      onRetry: _retry,
    );
  }
}
