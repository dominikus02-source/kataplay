import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;
  final double? progress;

  const LessonCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.isCompleted = false,
    this.isLocked = false,
    this.onTap,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: isLocked ? null : onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? AppColors.correct.withValues(alpha: 0.3)
                  : AppColors.cardBorder,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isCompleted ? AppColors.correct : iconColor)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_rounded : icon,
                  color: isCompleted ? AppColors.correct : iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (progress != null && progress! > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isLocked)
                Icon(Icons.lock_rounded,
                    color: AppColors.textLight, size: 18)
              else if (isCompleted)
                Icon(Icons.check_circle_rounded,
                    color: AppColors.correct, size: 22)
              else
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
