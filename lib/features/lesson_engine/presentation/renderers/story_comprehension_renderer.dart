import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class StoryComprehensionRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const StoryComprehensionRenderer({
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryBg.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Text(
            step.question ?? step.instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
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
                padding: const EdgeInsets.all(10),
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
                child: Center(
                  child: Text(
                    choice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isCorrect
                          ? AppColors.correct
                          : isWrong
                              ? AppColors.wrong
                              : isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
