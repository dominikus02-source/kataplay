import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class ListenChooseRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const ListenChooseRenderer({
    super.key,
    required this.step,
    required this.state,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 8),
        Text(
          'Tekan untuk mendengar',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        ...step.choices.map((choice) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildChoiceButton(choice),
            )),
        if (step.hint != null && state.status == LessonStatus.playing) ...[
          const SizedBox(height: 8),
          Container(
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
        ],
      ],
    );
  }

  Widget _buildChoiceButton(String choice) {
    final isSelected = state.selectedAnswers.contains(choice);
    final showFeedback = state.status == LessonStatus.feedback;
    final isCorrect = showFeedback && step.isCorrectAnswer(choice);
    final isWrong = showFeedback && isSelected && !isCorrect;

    return GestureDetector(
      onTap: state.status == LessonStatus.playing ? () => onSelect(choice) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isCorrect
              ? AppColors.correctBg
              : isWrong
                  ? AppColors.wrongBg
                  : isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCorrect
                ? AppColors.correct
                : isWrong
                    ? AppColors.wrong
                    : isSelected
                        ? AppColors.primary
                        : AppColors.cardBorder,
            width: isSelected || showFeedback ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                choice,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isCorrect
                      ? AppColors.correct
                      : isWrong
                          ? AppColors.wrong
                          : isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (showFeedback && isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isCorrect ? AppColors.correct : AppColors.wrong,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
