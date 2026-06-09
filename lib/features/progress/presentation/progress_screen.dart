import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

/// Progress Screen - "Progress Belajar"
/// Matches reference design: purple progress card with rocket/dinosaur,
/// stats grid, learning worlds list with progress bars
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);
    final islands = ref.watch(islandProgressProvider);

    final completedLessons = islands.fold<int>(
      0, (sum, island) => sum + island.levelsCompleted,
    );
    final totalLessons = islands.fold<int>(
      0, (sum, island) => sum + island.totalLevels,
    );
    final completedWorlds = islands.where((i) => i.isCompleted).length;
    final totalWorlds = islands.length;

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
                    'Progress Belajar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.emoji_events_rounded,
                      color: AppColors.accent, size: 28),
                ],
              ),

              const SizedBox(height: 20),

              // Main progress card (purple)
              _MainProgressCard(
                completedLessons: completedLessons,
                totalLessons: totalLessons,
                playerName: userProgress.playerName,
                streakDays: userProgress.streakDays,
              ),

              const SizedBox(height: 24),

              // Stats grid (2x2)
              _StatsGrid(
                completedWorlds: completedWorlds,
                totalWorlds: totalWorlds,
                completedLessons: completedLessons,
                totalLessons: totalLessons,
                streakDays: userProgress.streakDays,
              ),

              const SizedBox(height: 28),

              // Learning Worlds section
              Row(
                children: [
                  const Text(
                    'Dunia Belajar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.emoji_events_rounded,
                      color: AppColors.accent, size: 20),
                ],
              ),

              const SizedBox(height: 12),

              // World cards
              ...islands.asMap().entries.map((entry) {
                final index = entry.key;
                final island = entry.value;
                return _WorldCard(
                  island: island,
                  worldIndex: index,
                ).animate().fadeIn(delay: (index * 100).ms).slideX(
                      begin: 0.1,
                      end: 0,
                      duration: 300.ms,
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main progress card with purple background, rocket, and dinosaur
class _MainProgressCard extends StatelessWidget {
  final int completedLessons;
  final int totalLessons;
  final String playerName;
  final int streakDays;

  const _MainProgressCard({
    required this.completedLessons,
    required this.totalLessons,
    required this.playerName,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rocket icon + sparkles
              Row(
                children: [
                  const Text('🚀', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 8),
                  const Text('✨', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),

              // Encouraging text
              const Text(
                'Hebat, lanjutkan!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$completedLessons dari $totalLessons pelajaran selesai',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 16),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 12,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Today's target
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      'Target hari ini: 15 menit belajar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
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
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🦕', style: TextStyle(fontSize: 56)),
                ...List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '⭐',
                      style: TextStyle(fontSize: 12 + i * 2),
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

/// Stats grid - 2x2 cards
class _StatsGrid extends StatelessWidget {
  final int completedWorlds;
  final int totalWorlds;
  final int completedLessons;
  final int totalLessons;
  final int streakDays;

  const _StatsGrid({
    required this.completedWorlds,
    required this.totalWorlds,
    required this.completedLessons,
    required this.totalLessons,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _StatCard(
          icon: '🌍',
          iconBgColor: const Color(0xFFE8F5E9),
          value: '$totalWorlds',
          valueColor: AppColors.success,
          label: 'Dunia',
          subtitle: 'Total dunia',
        ),
        _StatCard(
          icon: '📚',
          iconBgColor: AppColors.primaryBg,
          value: '$totalLessons',
          valueColor: AppColors.primary,
          label: 'Pelajaran',
          subtitle: 'Total pelajaran',
        ),
        _StatCard(
          icon: '✅',
          iconBgColor: const Color(0xFFE3F2FD),
          value: '$completedLessons',
          valueColor: Colors.blue,
          label: 'Selesai',
          subtitle: 'Pelajaran selesai',
        ),
        _StatCard(
          icon: '🔥',
          iconBgColor: const Color(0xFFFFEBEE),
          value: '$streakDays',
          valueColor: AppColors.error,
          label: 'Streak',
          subtitle: 'Hari berturut-turut',
        ),
      ],
    );
  }
}

/// Individual stat card
class _StatCard extends StatelessWidget {
  final String icon;
  final Color iconBgColor;
  final String value;
  final Color valueColor;
  final String label;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconBgColor,
    required this.value,
    required this.valueColor,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// World card for each learning world
class _WorldCard extends StatelessWidget {
  final dynamic island;
  final int worldIndex;

  const _WorldCard({
    required this.island,
    required this.worldIndex,
  });

  static const _worldData = [
    {'icon': '🏠', 'emoji': '🐝', 'level': 'TK A'},
    {'icon': '🌸', 'emoji': '🐝', 'level': 'TK B'},
    {'icon': '🌲', 'emoji': '🦊', 'level': 'SD 1'},
    {'icon': '📖', 'emoji': '🐰', 'level': 'SD 2'},
    {'icon': '⛰️', 'emoji': '🦅', 'level': 'SD 3'},
    {'icon': '🏙️', 'emoji': '🚀', 'level': 'SD 4'},
  ];

  @override
  Widget build(BuildContext context) {
    final data = _worldData[worldIndex % _worldData.length];
    final progress = island.totalLevels > 0
        ? island.levelsCompleted / island.totalLevels
        : 0.0;
    final isLocked = !island.isUnlocked;
    final isCompleted = island.isCompleted;

    return Container(
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
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey[100]
                  : isCompleted
                      ? AppColors.successLight
                      : AppColors.primaryBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: isLocked
                  ? Text(data['icon']!, style: const TextStyle(fontSize: 24))
                  : Text(data['icon']!, style: const TextStyle(fontSize: 24)),
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
                        island.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isLocked ? Colors.grey[500] : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.successLight
                            : isLocked
                                ? Colors.grey[100]
                                : AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle_rounded
                                : isLocked
                                    ? Icons.lock_rounded
                                    : Icons.play_circle_rounded,
                            size: 14,
                            color: isCompleted
                                ? AppColors.success
                                : isLocked
                                    ? Colors.grey[400]
                                    : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted
                                ? 'Selesai'
                                : isLocked
                                    ? 'Terkunci'
                                    : 'Berjalan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isCompleted
                                  ? AppColors.success
                                  : isLocked
                                      ? Colors.grey[500]
                                      : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Level label
                Text(
                  data['level']!,
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
                              : isLocked
                                  ? Colors.grey[300]!
                                  : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${island.levelsCompleted}/${island.totalLevels}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLocked ? Colors.grey[400] : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
