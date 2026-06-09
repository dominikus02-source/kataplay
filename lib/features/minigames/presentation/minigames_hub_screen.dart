import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Hub for all Mini Games - Arena Kata
/// Premium design with vibrant game cards
class MinigamesHubScreen extends ConsumerWidget {
  const MinigamesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Arena Kata',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🎮', style: TextStyle(fontSize: 22)),
                  const Spacer(),
                  Consumer(
                    builder: (context, ref, _) {
                      final progress = ref.watch(userProgressProvider);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.coinGold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${progress.coins}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: AppColors.coinGold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Pilih permainan seru untuk hari ini!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 24),

              // Game cards
              _GameCard(
                title: AppStrings.gameMatchingTitle,
                description: AppStrings.gameMatchingDesc,
                emoji: '🧩',
                color: AppColors.cardTeal,
                isAvailable: true,
                onTap: () => context.goNamed('game-matching'),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 14),

              _GameCard(
                title: AppStrings.gameArrangeTitle,
                description: AppStrings.gameArrangeDesc,
                emoji: '🔤',
                color: AppColors.cardPurple,
                isAvailable: false,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 14),

              _GameCard(
                title: AppStrings.gameListenTitle,
                description: AppStrings.gameListenDesc,
                emoji: '👂',
                color: AppColors.cardOrange,
                isAvailable: false,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // Zelby encouragement
              Center(
                child: Consumer(
                  builder: (context, ref, _) {
                    final progress = ref.watch(userProgressProvider);
                    return ZelbyAvatar(
                      size: 56,
                      mood: 'excited',
                      showSpeechBubble: true,
                      speechText: progress.totalGamesPlayed > 0
                          ? 'Sudah ${progress.totalGamesPlayed} game dimainkan!'
                          : 'Cocokkan Kata paling seru loh!',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final bool isAvailable;
  final VoidCallback? onTap;

  const _GameCard({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    this.isAvailable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAvailable ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isAvailable ? color.withOpacity(0.5) : Colors.grey[400]!,
            width: 2,
          ),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Emoji icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (isAvailable)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Segera',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
