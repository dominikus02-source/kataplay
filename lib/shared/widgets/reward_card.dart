import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class RewardCard extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;
  final String? assetPath;
  final String title;
  final String subtitle;
  final bool isCollected;

  const RewardCard({
    super.key,
    this.icon,
    this.iconColor = AppColors.primary,
    this.assetPath,
    required this.title,
    this.subtitle = '',
    this.isCollected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isCollected ? iconColor.withValues(alpha: 0.2) : AppColors.textLight.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCollected
                          ? iconColor.withValues(alpha: 0.08)
                          : AppColors.textLight.withValues(alpha: 0.08),
                      border: isCollected
                          ? Border.all(color: iconColor.withValues(alpha: 0.12), width: 1)
                          : null,
                    ),
                    child: Opacity(
                      opacity: isCollected ? 1.0 : 0.65,
                      child: ClipOval(child: _buildIcon()),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700,
                      color: isCollected ? AppColors.textPrimary : AppColors.textLight,
                      height: 1.2,
                    ),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (subtitle.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isCollected
                            ? iconColor.withValues(alpha: 0.08)
                            : AppColors.textLight.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: isCollected
                            ? Border.all(color: iconColor.withValues(alpha: 0.15), width: 0.5)
                            : null,
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 8, fontWeight: FontWeight.w600,
                          color: isCollected
                              ? iconColor
                              : AppColors.textLight.withValues(alpha: 0.7),
                          height: 1.2,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            if (isCollected)
              Positioned(
                top: 6, right: 6,
                child: Container(
                  width: 18, height: 18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.correct, AppColors.correctLight],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.correct.withValues(alpha: 0.3), blurRadius: 4),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                ),
              ),
            if (!isCollected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
          color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4),
                        ],
                      ),
                      child: Icon(Icons.lock_rounded, size: 14, color: AppColors.iconLock),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: 50, height: 50,
        fit: BoxFit.contain,
        errorBuilder: (_, e, s) => icon != null
            ? Icon(icon, size: 24, color: isCollected ? iconColor : AppColors.textLight.withValues(alpha: 0.6))
            : const SizedBox.shrink(),
      );
    }
    return Icon(
      icon,
      size: 24,
      color: isCollected ? iconColor : AppColors.textLight.withValues(alpha: 0.6),
    );
  }
}
