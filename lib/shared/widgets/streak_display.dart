import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Shows current learning streak with fire emoji.
class StreakDisplay extends StatelessWidget {
  final int days;
  final double size;

  const StreakDisplay({
    super.key,
    required this.days,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final isHot = days >= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isHot ? AppColors.streakOrange.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔥',
            style: TextStyle(fontSize: size * 0.75),
          ),
          const SizedBox(width: 6),
          Text(
            '$days hari',
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w800,
              color: isHot ? AppColors.streakOrange : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
