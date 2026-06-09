import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Profile Screen - "Profilku"
/// Matches reference design: avatar with crown, XP progress bar,
/// stats cards, badges section, daily mission card
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);
    final stickers = ref.watch(stickerCollectionProvider);
    final islands = ref.watch(islandProgressProvider);
    final unlockedStickers = stickers.where((s) => s.isUnlocked).length;
    final completedIslands = islands.where((i) => i.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Profilku',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('⭐', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  // Settings gear
                  GestureDetector(
                    onTap: () => context.goNamed('setelan'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Profile card
              _ProfileCard(
                playerName: userProgress.playerName,
                level: userProgress.level,
                xp: userProgress.xp,
                maxXp: 100,
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // Stats grid (4 cards)
              _ProfileStatsGrid(
                totalXp: userProgress.xp,
                worldsCompleted: completedIslands,
                streakDays: userProgress.streakDays,
                level: userProgress.level,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 28),

              // Badges section
              _BadgesSection(
                stickers: stickers,
                unlockedCount: unlockedStickers,
                totalCount: stickers.length,
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 24),

              // Daily Mission card
              _DailyMissionCard().animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile card with avatar, name, level, XP progress
class _ProfileCard extends StatelessWidget {
  final String playerName;
  final int level;
  final int xp;
  final int maxXp;

  const _ProfileCard({
    required this.playerName,
    required this.level,
    required this.xp,
    required this.maxXp,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxXp > 0 ? (xp % maxXp) / maxXp : 0.0;
    final currentXp = xp % maxXp;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8DEFF), // Light purple bg
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with crown
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'P',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Crown
                      Positioned(
                        top: -12,
                        right: -4,
                        child: const Text('👑', style: TextStyle(fontSize: 20)),
                      ),
                      // Edit button
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Petualang Baru',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit_rounded,
                              size: 16,
                              color: AppColors.primary.withOpacity(0.6),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Level $level',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // XP Progress
              Row(
                children: [
                  Text(
                    '$currentXp / $maxXp XP',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 14),

              // Motivational message
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🚀', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Ayo lanjutkan belajar dan kumpulkan bintang! ⭐',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Dinosaur character on the right
          Positioned(
            right: 0,
            top: 0,
            child: const Text('🦕', style: TextStyle(fontSize: 52)),
          ),
        ],
      ),
    );
  }
}

/// Stats grid - 4 cards in 2x2
class _ProfileStatsGrid extends StatelessWidget {
  final int totalXp;
  final int worldsCompleted;
  final int streakDays;
  final int level;

  const _ProfileStatsGrid({
    required this.totalXp,
    required this.worldsCompleted,
    required this.streakDays,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        _StatCard(
          emoji: '⭐',
          bgEmojiColor: const Color(0xFFFFF9E6),
          value: '$totalXp',
          valueColor: Colors.orange,
          label: 'Total XP',
        ),
        _StatCard(
          emoji: '🏁',
          bgEmojiColor: const Color(0xFFE8F5E9),
          value: '$worldsCompleted',
          valueColor: AppColors.success,
          label: 'Dunia Selesai',
        ),
        _StatCard(
          emoji: '🔥',
          bgEmojiColor: const Color(0xFFFFEBEE),
          value: '$streakDays',
          valueColor: AppColors.error,
          label: 'Hari Streak',
        ),
        _StatCard(
          emoji: '🎮',
          bgEmojiColor: AppColors.primaryBg,
          value: '$level',
          valueColor: AppColors.primary,
          label: 'Level Saat Ini',
        ),
      ],
    );
  }
}

/// Stat card
class _StatCard extends StatelessWidget {
  final String emoji;
  final Color bgEmojiColor;
  final String value;
  final Color valueColor;
  final String label;

  const _StatCard({
    required this.emoji,
    required this.bgEmojiColor,
    required this.value,
    required this.valueColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgEmojiColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badges section
class _BadgesSection extends StatelessWidget {
  final List stickers;
  final int unlockedCount;
  final int totalCount;

  const _BadgesSection({
    required this.stickers,
    required this.unlockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    // Define badge templates (matching reference)
    final badgeTemplates = [
      {'name': 'Kolektor Sejati', 'icon': '💎', 'desc': 'Kumpulkan 5 badge', 'unlocked': true},
      {'name': 'Sempurna', 'icon': '⭐', 'desc': 'Jawab semua benar', 'unlocked': true},
      {'name': 'Penemu Rahasia', 'icon': '🔍', 'desc': 'Temukan easter egg', 'unlocked': false},
      {'name': 'Rajin Belajar', 'icon': '🔥', 'desc': 'Streak 7 hari', 'unlocked': false},
      {'name': 'Cepat & Hebat', 'icon': '🚀', 'desc': 'Selesaikan level cepat', 'unlocked': false},
      {'name': 'Juara Hebat', 'icon': '👑', 'desc': 'Capai level tinggi', 'unlocked': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            const Text(
              'Badge',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Navigate to full badge list
              },
              child: const Text(
                'Lihat semua >',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
          children: badgeTemplates.map((badge) {
            final isUnlocked = badge['unlocked'] as bool;
            return _BadgeCard(
              name: badge['name'] as String,
              icon: badge['icon'] as String,
              desc: badge['desc'] as String,
              isUnlocked: isUnlocked,
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Badge card
class _BadgeCard extends StatelessWidget {
  final String name;
  final String icon;
  final String desc;
  final bool isUnlocked;

  const _BadgeCard({
    required this.name,
    required this.icon,
    required this.desc,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.primaryBg
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: TextStyle(
                      fontSize: 20,
                      color: isUnlocked ? null : Colors.grey[400],
                    ),
                  ),
                ),
              ),
              if (!isUnlocked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
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
              if (isUnlocked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isUnlocked ? AppColors.textPrimary : Colors.grey[400],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Daily Mission card
class _DailyMissionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Treasure chest + flower
          Column(
            children: const [
              Text('🧰', style: TextStyle(fontSize: 28)),
              SizedBox(height: 2),
              Text('🌺', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Misi Hari Ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selesaikan 1 dunia belajar untuk dapat badge baru.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 12),
                // Start Mission button
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => context.goNamed('pulau'),
                    icon: const Text('⭐', style: TextStyle(fontSize: 14)),
                    label: const Text(
                      'Mulai Misi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
