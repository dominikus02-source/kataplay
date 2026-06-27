import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class LessonFeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final String message;
  final Animation<double> animation;
  final Color? accentColor;

  const LessonFeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.message,
    required this.animation,
    this.accentColor,
  });

  Color get _feedbackColor => isCorrect ? AppColors.correct : (accentColor ?? AppColors.wrong);
  IconData get _icon => isCorrect ? Icons.check_circle_rounded : Icons.refresh_rounded;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCorrect
                  ? [AppColors.correct.withValues(alpha: 0.12), AppColors.correct.withValues(alpha: 0.04)]
                  : [AppColors.wrong.withValues(alpha: 0.08), AppColors.wrong.withValues(alpha: 0.03)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _feedbackColor.withValues(alpha: isCorrect ? 0.25 : 0.15),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_feedbackColor, isCorrect ? AppColors.correctLight : _feedbackColor.withValues(alpha: 0.6)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _feedbackColor.withValues(alpha: 0.2),
                      blurRadius: 8, offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(_icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isCorrect ? AppColors.correct : AppColors.wrong,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
