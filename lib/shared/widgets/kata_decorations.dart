import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class SoftBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const SoftBlob({
    super.key,
    this.size = 80,
    this.color = AppColors.primary,
    this.opacity = 0.06,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class SparkleDot extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const SparkleDot({
    super.key,
    this.size = 6,
    this.color = AppColors.gold,
    this.opacity = 0.25,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final Widget? trailing;

  const SectionLabel({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final sectionColor = color ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: sectionColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 15, color: sectionColor),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}
