import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Pulau Kata - World Map / Adventure Screen
/// Interactive simple map with unlockable islands
class PulauKataScreen extends StatelessWidget {
  const PulauKataScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Simple grid of islands (MVP visual)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: AppConstants.totalIslands,
                  itemBuilder: (context, index) {
                    final isUnlocked = index < 3; // First 3 islands unlocked for MVP
                    final isCompleted = index == 0;

                    return _IslandCard(
                      name: AppConstants.islandNames[index],
                      isUnlocked: isUnlocked,
                      isCompleted: isCompleted,
                      onTap: isUnlocked
                          ? () {
                              // TODO: Navigate to specific island content
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Pulau ${AppConstants.islandNames[index]} - coming soon!'),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              const ZelbyAvatar(
                size: 48,
                mood: 'thinking',
                showSpeechBubble: true,
                speechText: 'Selesaikan Pulau Awal dulu ya!',
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
  final VoidCallback? onTap;

  const _IslandCard({
    required this.name,
    required this.isUnlocked,
    this.isCompleted = false,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.withOpacity(0.1)
                    : (isUnlocked ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade200),
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
        ),
      ),
    );
  }
}
