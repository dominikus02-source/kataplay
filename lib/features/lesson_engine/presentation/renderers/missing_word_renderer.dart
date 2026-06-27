import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class MissingWordRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const MissingWordRenderer({
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
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryBg.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Text(
            step.question ?? step.instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: step.choices.map((choice) {
            final isSelected = state.selectedAnswers.contains(choice);
            final showFeedback = state.status == LessonStatus.feedback;
            final isCorrect = showFeedback && step.isCorrectAnswer(choice);
            final isWrong = showFeedback && isSelected && !isCorrect;

            return GestureDetector(
              onTap: state.status == LessonStatus.playing
                  ? () => onSelect(choice)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                height: 64,
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
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (isCorrect
                                    ? AppColors.correct
                                    : AppColors.primary)
                                .withValues(alpha: 0.1),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: isCorrect
                          ? AppColors.correct
                          : isWrong
                              ? AppColors.wrong
                              : isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (step.hint != null && state.status == LessonStatus.playing) ...[
          const SizedBox(height: 16),
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
}
