import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Pulau Kata - World Map / Adventure Screen
/// Premium design with island cards matching reference style
class PulauKataScreen extends ConsumerWidget {
  const PulauKataScreen({super.key});

  // Island icons matching reference design
  static const List<String> _islandIcons = [
    '🏠', // Desa Huruf
    '🌸', // Kebun Kata
    '🌲', // Hutan Kalimat
    '📖', // Lembah Cerita
    '⛰️', // Gunung Bahasa
    '🏙️', // Kota Pengetahuan
  ];

  static const List<String> _islandEmojis = [
    '🐝', // Bee for Desa Huruf
    '🐝', // Bee for Kebun Kata
    '🦊', // Fox for Hutan Kalimat
    '🐰', // Rabbit for Lembah Cerita
    '🦅', // Eagle for Gunung Bahasa
    '🚀', // Rocket for Kota Pengetahuan
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final islands = ref.watch(islandProgressProvider);
    final userProgress = ref.watch(userProgressProvider);

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
                    'Pulau Kata',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Coins display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.coinGold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          '${userProgress.coins}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.coinGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Pilih dunia belajarmu dan mulai petualangan!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 20),

              // Island cards
              ...islands.asMap().entries.map((entry) {
                final index = entry.key;
                final island = entry.value;
                return _IslandCard(
                  name: island.name,
                  levelLabel: AppConstants.islandLabels[index],
                  icon: _islandIcons[index % _islandIcons.length],
                  emoji: _islandEmojis[index % _islandEmojis.length],
                  isUnlocked: island.isUnlocked,
                  isCompleted: island.isCompleted,
                  progress: island.progress,
                  levelsCompleted: island.levelsCompleted,
                  totalLevels: island.totalLevels,
                  onTap: island.isUnlocked
                      ? () {
                          context.goNamed('learning', queryParameters: {
                            'island': '${island.id}',
                            'level': '${island.levelsCompleted + 1}',
                            'difficulty': '${(island.levelsCompleted ~/ 2) + 1}',
                            'title': island.name,
                          });
                        }
                      : null,
                ).animate().fadeIn(delay: (index * 80).ms).slideX(
                      begin: 0.1,
                      end: 0,
                      duration: 300.ms,
                    );
              }),

              const SizedBox(height: 20),

              // Zelby encouragement
              Center(
                child: Consumer(
                  builder: (context, ref, _) {
                    final islands = ref.watch(islandProgressProvider);
                    final completedIslands =
                        islands.where((i) => i.isCompleted).length;
                    return ZelbyAvatar(
                      size: 48,
                      mood: completedIslands > 0 ? 'excited' : 'thinking',
                      showSpeechBubble: true,
                      speechText: completedIslands > 0
                          ? '$completedIslands dunia sudah selesai! Lanjutkan!'
                          : 'Selesaikan Desa Huruf dulu ya!',
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

/// Island card matching reference design
class _IslandCard extends StatelessWidget {
  final String name;
  final String levelLabel;
  final String icon;
  final String emoji;
  final bool isUnlocked;
  final bool isCompleted;
  final double progress;
  final int levelsCompleted;
  final int totalLevels;
  final VoidCallback? onTap;

  const _IslandCard({
    required this.name,
    required this.levelLabel,
    required this.icon,
    required this.emoji,
    required this.isUnlocked,
    this.isCompleted = false,
    this.progress = 0.0,
    this.levelsCompleted = 0,
    this.totalLevels = 5,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon with background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.successLight
                    : isUnlocked
                        ? AppColors.primaryBg
                        : Colors.grey[100]!,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: isUnlocked
                        ? Text(icon, style: const TextStyle(fontSize: 28))
                        : Text(icon, style: TextStyle(fontSize: 28, color: Colors.grey[400])),
                  ),
                  if (!isUnlocked)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  // Small emoji companion
                  if (isUnlocked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Text(emoji, style: const TextStyle(fontSize: 14)),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isUnlocked ? AppColors.textPrimary : Colors.grey[500],
                          ),
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.successLight
                              : isUnlocked
                                  ? AppColors.primaryBg
                                  : Colors.grey[100]!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle_rounded
                                  : isUnlocked
                                      ? Icons.play_circle_rounded
                                      : Icons.lock_rounded,
                              size: 14,
                              color: isCompleted
                                  ? AppColors.success
                                  : isUnlocked
                                      ? AppColors.primary
                                      : Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCompleted
                                  ? 'Selesai'
                                  : isUnlocked
                                      ? 'Berjalan'
                                      : 'Terkunci',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isCompleted
                                    ? AppColors.success
                                    : isUnlocked
                                        ? AppColors.primary
                                        : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    levelLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            color: isCompleted
                                ? AppColors.success
                                : isUnlocked
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$levelsCompleted/$totalLevels',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isUnlocked
                              ? AppColors.textSecondary
                              : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
