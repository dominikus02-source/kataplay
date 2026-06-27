import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/progress_bar.dart';

class LessonTopBar extends StatelessWidget {
  final double progress;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onClose;
  final int? xp;

  const LessonTopBar({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    required this.onClose,
    this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.primaryBg.withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 24),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: AppProgressBar(
                progress: progress,
                height: 7,
                color: AppColors.primary,
                backgroundColor: AppColors.primaryBg.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Text(
                '$currentStep/$totalSteps',
                style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary,
                ),
              ),
            ),
            if (xp != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                    const SizedBox(width: 2),
                    Text(
                      '$xp',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.goldDark),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
