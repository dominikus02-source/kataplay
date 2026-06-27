import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../utils/constants.dart';

class AppProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final bool showLabel;
  final bool showGlow;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = AppConstants.progressBarHeight,
    this.color,
    this.backgroundColor,
    this.showLabel = false,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final barColor = color ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height + (showGlow ? 4 : 0),
            width: double.infinity,
            decoration: showGlow
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  )
                : null,
            child: Container(
              height: height,
              width: double.infinity,
              color: backgroundColor ?? AppColors.textLight.withValues(alpha: 0.1),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: clampedProgress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        barColor,
                        barColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Text(
            '${(clampedProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
