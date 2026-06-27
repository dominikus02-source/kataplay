import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../application/lesson_controller.dart';
import '../application/lesson_state.dart';
import '../domain/lesson_step.dart';
import '../domain/lesson_type.dart';
import 'lesson_renderer_factory.dart';

class LessonShell extends StatelessWidget {
  final LessonController controller;
  final LessonState state;
  final VoidCallback onBack;
  final VoidCallback? onRetry;
  final String characterAsset;

  const LessonShell({
    super.key,
    required this.controller,
    required this.state,
    required this.onBack,
    this.onRetry,
    this.characterAsset = 'assets/characters/zelby_happy.png',
  });

  @override
  Widget build(BuildContext context) {
    final step = state.currentStep;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, step),
            Expanded(
              child: step != null
                  ? _buildContent(context, step)
                  : _buildEmptyState(),
            ),
            _buildBottomAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, LessonStep? step) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: onBack,
            splashRadius: 24,
          ),
          if (state.totalSteps > 0)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.progressBarHeight / 2),
                child: LinearProgressIndicator(
                  value: state.currentStepIndex / state.totalSteps,
                  backgroundColor: AppColors.primaryBg,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: AppDimensions.progressBarHeight,
                ),
              ),
            ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_rounded, color: AppColors.wrong, size: 20),
              const SizedBox(width: 4),
              Text(
                '${state.heartsRemaining}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, LessonStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                _buildCharacterSection(),
                const SizedBox(height: 16),
                _buildPrompt(step),
                const SizedBox(height: 20),
                LessonRendererFactory.build(
                  step: step,
                  state: state,
                  onSelect: (answer) {
                    final currentStep = state.currentStep;
                    if (currentStep?.type.name == 'wordOrder' ||
                        currentStep?.hasMatchPairs == true ||
                        currentStep?.correctAnswer.length != 1) {
                      controller.selectAnswer(answer);
                    } else {
                      controller.selectSingleAnswer(answer);
                      controller.checkAnswer();
                    }
                  },
                  onContinue: () {
                    controller.nextStep();
                  },
                  onRecord: () {},
                ),
                if (step.hint != null &&
                    state.status == LessonStatus.playing &&
                    (step.type == LessonType.wordChoice ||
                        step.type == LessonType.sentenceChoice ||
                        step.type == LessonType.fillBlank))
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.goldBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        step.hint!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.goldDark,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCharacterSection() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppDimensions.softShadow,
      ),
      child: ClipOval(
        child: Image.asset(
          characterAsset,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.zelbyColor,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt(LessonStep step) {
    final isStoryType = step.type == LessonType.storyReading ||
        step.type == LessonType.storyComprehension;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isStoryType && step.instruction.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              step.instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Text(
          step.prompt,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    if (state.status == LessonStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sentiment_dissatisfied_rounded,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Gagal memuat pelajaran',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Coba Lagi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Memuat pelajaran...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    if (state.status == LessonStatus.feedback) {
      return _buildFeedbackBar(context);
    }

    if (state.status == LessonStatus.playing) {
      final isStoryReading =
          state.currentStep?.type == LessonType.storyReading;
      final isVoiceType = state.currentStep?.type == LessonType.recordVoice ||
          state.currentStep?.type == LessonType.speakingPractice;

      if (isStoryReading) return const SizedBox();

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.hasSelection
                  ? () => controller.checkAnswer()
                  : isVoiceType
                      ? () {}
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: state.hasSelection
                    ? AppColors.primary
                    : AppColors.primaryBg,
                foregroundColor: state.hasSelection
                    ? Colors.white
                    : AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: state.hasSelection ? 4 : 0,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
              child: Text(
                isVoiceType ? 'Rekam' : 'Cek Jawaban',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildFeedbackBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: state.isCorrect ? AppColors.correctBg : AppColors.wrongBg,
        border: Border(
          top: BorderSide(
            color: state.isCorrect
                ? AppColors.correct.withValues(alpha: 0.2)
                : AppColors.wrong.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  state.isCorrect
                      ? Icons.check_circle_rounded
                      : Icons.refresh_rounded,
                  color: state.isCorrect ? AppColors.correct : AppColors.wrong,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.feedbackMessage ??
                        (state.isCorrect ? 'Hebat!' : 'Coba lagi!'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: state.isCorrect
                          ? AppColors.correct
                          : AppColors.wrong,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => state.isCorrect
                    ? controller.nextStep()
                    : controller.retry(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      state.isCorrect ? AppColors.primary : AppColors.wrong,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: (state.isCorrect
                          ? AppColors.primary
                          : AppColors.wrong)
                      .withValues(alpha: 0.3),
                ),
                child: Text(
                  state.isCorrect
                      ? (state.hasNext ? 'Lanjut' : 'Selesai')
                      : 'Coba Lagi',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
