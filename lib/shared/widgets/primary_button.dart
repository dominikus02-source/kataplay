import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Large, friendly primary button for kids.
/// Minimum touch target 56px, rounded 28px.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: isSecondary
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: backgroundColor ?? AppColors.primary,
              side: BorderSide(color: backgroundColor ?? AppColors.primary, width: 2),
            )
          : (backgroundColor != null
              ? ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                )
              : null),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 22),
                  const SizedBox(width: 10),
                ],
                Text(label),
              ],
            ),
    );

    return SizedBox(
      width: width,
      height: 56,
      child: button,
    );
  }
}
