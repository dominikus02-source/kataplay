import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
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
                        'Zelby menantimu!',
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
                  child: StreakDisplay(days: 5), // TODO: from Riverpod state
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CoinDisplay(amount: 245), // TODO: from Riverpod state
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Daily Quest Card
            _DailyQuestCard(),

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
            const Center(
              child: ZelbyAvatar(
                size: 56,
                mood: 'curious',
                showSpeechBubble: true,
                speechText: 'Hari ini kita akan belajar 5 kata baru, yuk!',
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
}

class _DailyQuestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            ],
          ),
          const SizedBox(height: 14),
          const LinearProgressIndicator(
            value: 0.6,
            minHeight: 10,
            backgroundColor: Color(0xFFF5EDE3),
            color: Color(0xFF0B7A5C),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          const SizedBox(height: 10),
          Text(
            'Selesaikan 2 mini game hari ini',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '2/3 selesai',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
