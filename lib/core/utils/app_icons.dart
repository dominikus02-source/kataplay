import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppIcons {
  AppIcons._();

  static const double sizeSm = 18;
  static const double sizeMd = 22;
  static const double sizeLg = 28;
  static const double sizeXl = 36;

  static IconData fromEmoji(String emoji) {
    switch (emoji) {
      case '🏠': return Icons.home_rounded;
      case '📚': return Icons.auto_stories_rounded;
      case '🏆': return Icons.emoji_events_rounded;
      case '👤': return Icons.person_rounded;
      case '⭐': return Icons.star_rounded;
      case '🌟': return Icons.auto_awesome_rounded;
      case '🔥': return Icons.local_fire_department_rounded;
      case '🎯': return Icons.flag_rounded;
      case '🚀': return Icons.rocket_launch_rounded;
      case '🎨': return Icons.palette_rounded;
      case '🎮': return Icons.sports_esports_rounded;
      case '🎉': return Icons.celebration_rounded;
      case '✨': return Icons.auto_awesome_rounded;
      case '💪': return Icons.fitness_center_rounded;
      case '😊': return Icons.emoji_emotions_rounded;
      case '✅': return Icons.check_circle_rounded;
      case '❌': return Icons.cancel_rounded;
      case '❓': return Icons.help_outline_rounded;
      case '👉': return Icons.arrow_forward_rounded;
      case '🏁': return Icons.flag_rounded;
      case '📊': return Icons.bar_chart_rounded;
      case '🔤': return Icons.abc_rounded;
      case '🔊': return Icons.volume_up_rounded;
      case '📦': return Icons.inventory_2_rounded;
      case '🏃': return Icons.directions_run_rounded;
      case '💬': return Icons.forum_rounded;
      case '📖': return Icons.auto_stories_rounded;
      case '💎': return Icons.diamond_rounded;
      case '🏅': return Icons.military_tech_rounded;
      default: return Icons.help_rounded;
    }
  }

  static Color colorFor(String emoji) {
    switch (emoji) {
      case '🏠': return AppColors.iconHome;
      case '📚': return AppColors.iconLearn;
      case '🏆': return AppColors.iconCollect;
      case '👤': return AppColors.iconProfile;
      case '⭐': case '🌟': return AppColors.iconStar;
      case '🔥': return AppColors.iconStreak;
      case '🎯': return AppColors.iconMission;
      case '🚀': return AppColors.iconLevel;
      case '✅': case '📊': return AppColors.iconCheck;
      case '🔤': return AppColors.levelColors[0];
      case '🔊': return AppColors.levelColors[1];
      case '📦': return AppColors.levelColors[2];
      case '🏃': return AppColors.levelColors[3];
      case '💬': return AppColors.levelColors[4];
      case '📖': return AppColors.levelColors[5];
      case '💎': return AppColors.iconReward;
      case '🏅': return AppColors.iconBadge;
      default: return AppColors.primary;
    }
  }

  // Build standard icon widgets
  static Widget home({double size = sizeMd}) => Icon(Icons.home_rounded, size: size, color: AppColors.iconHome);
  static Widget learn({double size = sizeMd}) => Icon(Icons.auto_stories_rounded, size: size, color: AppColors.iconLearn);
  static Widget collect({double size = sizeMd}) => Icon(Icons.collections_bookmark_rounded, size: size, color: AppColors.iconCollect);
  static Widget profile({double size = sizeMd}) => Icon(Icons.person_rounded, size: size, color: AppColors.iconProfile);
  static Widget star({double size = sizeMd}) => Icon(Icons.star_rounded, size: size, color: AppColors.iconStar);
  static Widget streak({double size = sizeMd}) => Icon(Icons.local_fire_department_rounded, size: size, color: AppColors.iconStreak);
  static Widget check({double size = sizeMd}) => Icon(Icons.check_circle_rounded, size: size, color: AppColors.iconCheck);
  static Widget lock({double size = sizeMd}) => Icon(Icons.lock_rounded, size: size, color: AppColors.iconLock);
  static Widget play({double size = sizeMd}) => Icon(Icons.play_circle_rounded, size: size, color: AppColors.iconPlay);
  static Widget trophy({double size = sizeMd}) => Icon(Icons.emoji_events_rounded, size: size, color: AppColors.iconCollect);
  static Widget xp({double size = sizeMd}) => Icon(Icons.star_rounded, size: size, color: AppColors.iconXp);
  static Widget level({double size = sizeMd}) => Icon(Icons.trending_up_rounded, size: size, color: AppColors.iconLevel);
  static Widget badge({double size = sizeMd}) => Icon(Icons.military_tech_rounded, size: size, color: AppColors.iconBadge);
  static Widget mission({double size = sizeMd}) => Icon(Icons.flag_rounded, size: size, color: AppColors.iconMission);
  static Widget reward({double size = sizeMd}) => Icon(Icons.card_giftcard_rounded, size: size, color: AppColors.iconReward);
  static Widget rocket({double size = sizeMd}) => Icon(Icons.rocket_launch_rounded, size: size, color: AppColors.iconLevel);
  static Widget celebration({double size = sizeMd}) => Icon(Icons.celebration_rounded, size: size, color: AppColors.iconReward);
  static Widget edit({double size = sizeMd}) => Icon(Icons.edit_rounded, size: size, color: AppColors.textLight);
  static Widget close({double size = sizeMd}) => Icon(Icons.close_rounded, size: size, color: AppColors.textPrimary);
  static Widget back({double size = sizeMd}) => Icon(Icons.arrow_back_rounded, size: size, color: AppColors.textPrimary);
  static Widget done({double size = sizeMd}) => Icon(Icons.check_circle_rounded, size: size, color: AppColors.correct);
  static Widget arrowForward({double size = sizeMd}) => Icon(Icons.arrow_forward_rounded, size: size, color: Colors.white);
}
