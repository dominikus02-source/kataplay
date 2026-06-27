import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/app_icons.dart';

class LevelPathCard extends StatelessWidget {
  final int levelNumber;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final bool isCompleted;
  final double progress;
  final VoidCallback? onTap;
  final Color levelColor;
  final Color bgColor;

  const LevelPathCard({
    super.key,
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.progress = 0,
    this.onTap,
    this.levelColor = AppColors.primary,
    this.bgColor = AppColors.background,
  });

  bool get isLocked => !isUnlocked && !isCompleted;
  bool get isActive => isUnlocked && !isCompleted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isLocked
              ? LinearGradient(
                  colors: [bgColor.withValues(alpha: 0.35), Colors.white.withValues(alpha: 0.5)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                )
              : isCompleted
                  ? LinearGradient(
                      colors: [AppColors.correctLight.withValues(alpha: 0.12), Colors.white],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [levelColor.withValues(alpha: 0.06), Colors.white],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isLocked
                ? levelColor.withValues(alpha: 0.08)
                : isCompleted
                    ? AppColors.correct.withValues(alpha: 0.25)
                    : levelColor.withValues(alpha: 0.25),
            width: isActive ? 2.5 : 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: levelColor.withValues(alpha: 0.12),
                    blurRadius: 18, offset: const Offset(0, 6),
                  ),
                ]
              : isCompleted
                  ? [
                      BoxShadow(
                        color: AppColors.correct.withValues(alpha: 0.06),
                        blurRadius: 8, offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
        ),
        child: Row(
          children: [
            _buildLevelNode(),
            const SizedBox(width: 14),
            Expanded(child: _buildContent()),
            if (isActive) _buildPlayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelNode() {
    return Container(
      width: 58, height: 58,
      decoration: BoxDecoration(
        gradient: isLocked
            ? LinearGradient(colors: [levelColor.withValues(alpha: 0.12), levelColor.withValues(alpha: 0.06)])
            : isCompleted
                ? LinearGradient(colors: [AppColors.correct, AppColors.correctLight])
                : LinearGradient(colors: [levelColor, levelColor.withValues(alpha: 0.7)]),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: levelColor.withValues(alpha: 0.25),
                  blurRadius: 12, offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check_circle_rounded, color: Colors.white, size: 30)
            : isLocked
                ? Icon(Icons.lock_rounded, color: levelColor.withValues(alpha: 0.35), size: 20)
                : Icon(AppIcons.fromEmoji(icon), color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: isLocked ? levelColor.withValues(alpha: 0.08) : levelColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Level $levelNumber',
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: isLocked ? levelColor.withValues(alpha: 0.5) : levelColor,
                ),
              ),
            ),
            const Spacer(),
            if (isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.correct.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_rounded, size: 10, color: AppColors.correct),
                    const SizedBox(width: 3),
                    const Text(
                      'Lencana +',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.correct),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700,
            color: isLocked ? levelColor.withValues(alpha: 0.6) : AppColors.textPrimary,
          ),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 11,
            color: isLocked ? levelColor.withValues(alpha: 0.4) : AppColors.textSecondary,
          ),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        if (isActive && progress > 0) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: levelColor.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(levelColor),
              minHeight: 6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlayButton() {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [levelColor, levelColor.withValues(alpha: 0.6)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: levelColor.withValues(alpha: 0.25),
            blurRadius: 10, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
    );
  }
}
