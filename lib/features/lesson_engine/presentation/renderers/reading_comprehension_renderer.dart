import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class ReadingComprehensionRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const ReadingComprehensionRenderer({
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.zelbyColor.withValues(alpha: 0.06)),
          ),
          child: Text(
            step.storyText ?? step.instruction,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.goldBg.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            step.question ?? 'Pertanyaan:',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.goldDark,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...step.choices.map((choice) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildChoiceButton(choice),
            )),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
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
