import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Zelby - Maskot utama KataPlay
/// Tarsier Indonesia yang lucu, penasaran, dan ceria
/// 
/// moods supported: happy, curious, excited, proud, thinking, sleeping
class ZelbyAvatar extends StatelessWidget {
  final double size;
  final String mood;
  final bool showSpeechBubble;
  final String? speechText;

  const ZelbyAvatar({
    super.key,
    this.size = 80,
    this.mood = 'happy',
    this.showSpeechBubble = false,
    this.speechText,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = _getEmojiForMood(mood);
    final bgColor = _getBgColorForMood(mood);

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.55),
        ),
      ),
    );

    if (!showSpeechBubble || speechText == null) {
      return avatar;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            speechText!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        avatar,
      ],
    );
  }

  String _getEmojiForMood(String mood) {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'curious':
        return '🤔';
      case 'excited':
        return '🤩';
      case 'proud':
        return '😎';
      case 'thinking':
        return '🧐';
      case 'sleeping':
        return '😴';
      case 'celebrating':
        return '🥳';
      default:
        return '🐵';
    }
  }

  Color _getBgColorForMood(String mood) {
    switch (mood) {
      case 'excited':
      case 'celebrating':
        return AppColors.accent.withOpacity(0.3);
      case 'proud':
        return AppColors.secondary.withOpacity(0.25);
      default:
        return AppColors.primary.withOpacity(0.15);
    }
  }
}
