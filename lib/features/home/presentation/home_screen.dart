import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../data/models/user_progress_model.dart';
import '../../../shared/widgets/zelby_avatar.dart';
import '../../../shared/widgets/coin_display.dart';
import '../../../shared/widgets/streak_display.dart';
import '../../../shared/widgets/primary_button.dart';

/// Home Screen - Beranda
/// Shows greeting, streak, coins, daily quest, and entry points to Pulau & Games
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);
    final greeting = _getGreeting();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Zelby + Greeting
            Row(
              children: [
                const ZelbyAvatar(size: 72, mood: 'happy'),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        '${userProgress.playerName} menantimu!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Stats Row: Streak + Coins
            Row(
              children: [
                Expanded(
                  child: StreakDisplay(days: userProgress.streakDays),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CoinDisplay(amount: userProgress.coins),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Daily Quest Card
            const _DailyQuestCard(),

            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Apa yang ingin kamu lakukan hari ini?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            PrimaryButton(
              label: AppStrings.exploreWorld,
              icon: Icons.explore_rounded,
              onPressed: () => context.goNamed('pulau'),
            ),

            const SizedBox(height: 14),

            PrimaryButton(
              label: AppStrings.playMiniGames,
              icon: Icons.sports_esports_rounded,
              onPressed: () => context.goNamed('main'),
              isSecondary: true,
            ),

            const SizedBox(height: 40),

            // Zelby encouragement
            Center(
              child: ZelbyAvatar(
                size: 56,
                mood: userProgress.streakDays >= 3 ? 'excited' : 'curious',
                showSpeechBubble: true,
                speechText: _getEncouragement(userProgress),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return AppStrings.goodMorning;
    if (hour < 15) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  String _getEncouragement(UserProgress userProgress) {
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

class _DailyQuestCard extends ConsumerWidget {
  const _DailyQuestCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(dailyQuestProvider);
    final questNotifier = ref.read(dailyQuestProvider.notifier);
    final progress = questNotifier.overallProgress;
    final completedCount = questNotifier.completedCount;

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
              const Icon(Icons.flag_rounded, color: Color(0xFF0B7A5C)),
              const SizedBox(width: 10),
              Text(
                AppStrings.dailyQuest,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                '$completedCount/${quests.length} selesai',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: completedCount == quests.length
                          ? Colors.green
                          : Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFF5EDE3),
            color: completedCount == quests.length
                ? Colors.green
                : const Color(0xFF0B7A5C),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          const SizedBox(height: 14),
          // Show first 2 quests
          if (quests.isNotEmpty)
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
                            ? Colors.green
                            : Colors.grey[400],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          quest.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    );
  }
}
