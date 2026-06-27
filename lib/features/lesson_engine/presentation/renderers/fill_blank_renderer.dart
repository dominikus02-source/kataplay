import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class FillBlankRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const FillBlankRenderer({
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
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
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
        child: Text(
          choice,
          style: TextStyle(
            fontSize: 16,
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
    );
  }
}
