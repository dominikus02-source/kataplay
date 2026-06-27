import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class TrueFalseRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const TrueFalseRenderer({
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
            color: AppColors.zelbyBg.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.zelbyColor.withValues(alpha: 0.1)),
          ),
          child: Text(
            step.instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: step.choices.map((choice) {
            final isSelected = state.selectedAnswers.contains(choice);
            final showFeedback = state.status == LessonStatus.feedback;
            final isCorrect = showFeedback && step.isCorrectAnswer(choice);
            final isWrong = showFeedback && isSelected && !isCorrect;
            final isBenar = choice == 'Benar';

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: isBenar ? 0 : 6,
                  right: isBenar ? 6 : 0,
                ),
                child: GestureDetector(
                  onTap: state.status == LessonStatus.playing
                      ? () => onSelect(choice)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 90,
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
                        Icon(
                          isBenar
                              ? Icons.check_circle_outline_rounded
                              : Icons.cancel_outlined,
                          size: 32,
                          color: isCorrect
                              ? AppColors.correct
                              : isWrong
                                  ? AppColors.wrong
                                  : isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          choice,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isCorrect
                                ? AppColors.correct
                                : isWrong
                                    ? AppColors.wrong
                                    : isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
