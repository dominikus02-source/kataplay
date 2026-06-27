import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class WordChoiceRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const WordChoiceRenderer({
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
        if (step.hasImage)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                step.imageAsset!,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.image_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
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
