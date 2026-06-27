import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class PictureChoiceRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const PictureChoiceRenderer({
    super.key,
    required this.step,
    required this.state,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: step.choices.length,
      itemBuilder: (context, index) {
        final choice = step.choices[index];
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
            decoration: BoxDecoration(
              color: isCorrect
                  ? AppColors.correctBg
                  : isWrong
                      ? AppColors.wrongBg
                      : isSelected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.white,
              borderRadius: BorderRadius.circular(20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  choice,
                  style: TextStyle(
                    fontSize: 22,
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
                if (showFeedback && isSelected) ...[
                  const SizedBox(height: 4),
                  Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: isCorrect ? AppColors.correct : AppColors.wrong,
                    size: 22,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
