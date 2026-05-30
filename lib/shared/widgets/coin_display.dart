import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Displays current coins with nice gold styling.
class CoinDisplay extends StatelessWidget {
  final int amount;
  final double size;

  const CoinDisplay({
    super.key,
    required this.amount,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
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
            '🪙',
            style: TextStyle(fontSize: size * 0.8),
          ),
          const SizedBox(width: 6),
          Text(
            amount.toString(),
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
