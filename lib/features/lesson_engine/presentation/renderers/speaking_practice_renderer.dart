import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class SpeakingPracticeRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState state;
  final VoidCallback onRecord;

  const SpeakingPracticeRenderer({
    super.key,
    required this.step,
    required this.state,
    required this.onRecord,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.zelbyColor.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            step.question ?? step.instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: onRecord,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.tertiary, AppColors.tertiaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 38),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Bacakan kalimat dengan nyaring',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
