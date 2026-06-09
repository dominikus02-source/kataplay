import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Home Screen - Beranda
/// Premium design matching reference: mascot greeting, 3 action buttons,
/// soft pastel background with decorative elements
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);
    final quests = ref.watch(dailyQuestProvider);
    final questNotifier = ref.read(dailyQuestProvider.notifier);
    final completedCount = questNotifier.completedCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: coins + streak
              _buildTopStats(context, userProgress),

              const SizedBox(height: 20),

              // Mascot with greeting bubble
              _buildMascotGreeting(context, userProgress),

              const SizedBox(height: 28),

              // 3 Main Action Buttons
              _buildActionButtons(context, completedCount, quests.length),

              const SizedBox(height: 28),

              // Daily Quest Card
              _buildDailyQuestCard(context, quests, completedCount),

              const SizedBox(height: 24),

              // Zelby encouragement
              Center(
                child: ZelbyAvatar(
                  size: 48,
                  mood: userProgress.streakDays >= 3 ? 'excited' : 'curious',
                  showSpeechBubble: true,
                  speechText: _getEncouragement(userProgress),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopStats(BuildContext context, dynamic userProgress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Streak
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.streakOrange.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text(
                '${userProgress.streakDays}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.streakOrange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Coins
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.coinGold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🪙', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text(
                '${userProgress.coins}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.coinGold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMascotGreeting(BuildContext context, dynamic userProgress) {
    final greeting = _getGreeting();
    final playerName = userProgress.playerName;

    return Center(
      child: Column(
        children: [
          // Zelby mascot
          const ZelbyAvatar(size: 100, mood: 'happy')
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 12),

          // Greeting bubble
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.tealDark,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$greeting, $playerName!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mau belajar apa hari ini?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15, end: 0),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, int completedQuests, int totalQuests) {
    return Row(
      children: [
        // Daily Quest
        Expanded(
          child: _ActionButton(
            icon: Icons.star_rounded,
            iconColor: AppColors.secondary,
            iconBgColor: Colors.white,
            label: 'Daily Quest',
            subtitle: '$completedQuests/$totalQuests selesai',
            bgColor: AppColors.teal,
            borderColor: AppColors.tealDark,
            onTap: () {
              // Scroll to quest card or show quest detail
            },
          ),
        ),
        const SizedBox(width: 12),
        // Arena Kata
        Expanded(
          child: _ActionButton(
            icon: Icons.emoji_events_rounded,
            iconColor: AppColors.primary,
            iconBgColor: Colors.white,
            label: 'Arena Kata',
            subtitle: 'Tantangan',
            bgColor: AppColors.teal,
            borderColor: AppColors.tealDark,
            onTap: () => context.goNamed('main'),
          ),
        ),
        const SizedBox(width: 12),
        // Pulau Kata
        Expanded(
          child: _ActionButton(
            icon: Icons.landscape_rounded,
            iconColor: Colors.blue,
            iconBgColor: Colors.white,
            label: 'Pulau Kata',
            subtitle: 'Petualangan',
            bgColor: AppColors.teal,
            borderColor: AppColors.tealDark,
            onTap: () => context.goNamed('pulau'),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildDailyQuestCard(BuildContext context, List quests, int completedCount) {
    if (quests.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              const Text(
                'Daily Quest',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: completedCount == quests.length
                      ? AppColors.successLight
                      : AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount/${quests.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: completedCount == quests.length
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: quests.isEmpty ? 0 : completedCount / quests.length,
              minHeight: 10,
              backgroundColor: AppColors.surfaceVariant,
              color: completedCount == quests.length
                  ? AppColors.success
                  : AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          // Show first 2 quests
          ...quests.take(2).map((quest) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      quest.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: quest.isCompleted
                          ? AppColors.success
                          : Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        quest.description,
                        style: TextStyle(
                          fontSize: 13,
                          decoration: quest.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: quest.isCompleted
                              ? Colors.grey
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  String _getEncouragement(dynamic userProgress) {
    if (!userProgress.hasPlayedToday) {
      return 'Hari ini kita akan belajar 5 kata baru, yuk!';
    }
    if (userProgress.streakDays >= 7) {
      return 'Streak ${userProgress.streakDays} hari! Kamu luar biasa!';
    }
    if (userProgress.streakDays >= 3) {
      return 'Streak ${userProgress.streakDays} hari! Terus semangat ya!';
    }
    return 'Ayo main game untuk tambah streak-mu!';
  }
}

/// Action button matching reference design - teal rounded rectangle
/// with circular icon above and label below
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String subtitle;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.subtitle,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            // Label
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
