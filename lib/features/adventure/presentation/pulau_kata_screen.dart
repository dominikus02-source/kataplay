import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Pulau Kata - World Map / Adventure Screen
/// Interactive map with unlockable islands powered by real progress data
class PulauKataScreen extends ConsumerWidget {
  const PulauKataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final islands = ref.watch(islandProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.pulauKataTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                AppStrings.pulauKataSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Island grid with real progress data
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: islands.length,
                  itemBuilder: (context, index) {
                    final island = islands[index];
                    return _IslandCard(
                      name: island.name,
                      isUnlocked: island.isUnlocked,
                      isCompleted: island.isCompleted,
                      progress: island.progress,
                      levelsCompleted: island.levelsCompleted,
                      totalLevels: island.totalLevels,
                      onTap: island.isUnlocked
                          ? () {
                              // Navigate to island content
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Pulau ${island.name} - ${island.levelsCompleted}/${island.totalLevels} level selesai',
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  final progress = ref.watch(userProgressProvider);
                  final islands = ref.watch(islandProgressProvider);
                  final completedIslands =
                      islands.where((i) => i.isCompleted).length;

                  return ZelbyAvatar(
                    size: 48,
                    mood: completedIslands > 0 ? 'excited' : 'thinking',
                    showSpeechBubble: true,
                    speechText: completedIslands > 0
                        ? '$completedIslands pulau sudah selesai! Lanutkan!'
                        : 'Selesaikan Pulau Awal dulu ya!',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IslandCard extends StatelessWidget {
  final String name;
  final bool isUnlocked;
  final bool isCompleted;
  final double progress;
  final int levelsCompleted;
  final int totalLevels;
  final VoidCallback? onTap;

  const _IslandCard({
    required this.name,
    required this.isUnlocked,
    this.isCompleted = false,
    this.progress = 0.0,
    this.levelsCompleted = 0,
    this.totalLevels = 5,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isUnlocked ? AppColors.primary : AppColors.islandLocked;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked ? color.withOpacity(0.3) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isUnlocked ? '🏝️' : '🔒',
              style: const TextStyle(fontSize: 42),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isUnlocked ? AppColors.textPrimary : Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            // Progress indicator for unlocked islands
            if (isUnlocked && !isCompleted) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$levelsCompleted/$totalLevels level',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ] else ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : (isUnlocked
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCompleted
                      ? AppStrings.completed
                      : (isUnlocked ? AppStrings.unlocked : AppStrings.locked),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? Colors.green
                        : (isUnlocked ? AppColors.primary : Colors.grey),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
