import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Profile Screen + entry to Parent Dashboard
/// Now powered by real user progress data
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
      appBar: AppBar(title: const Text(AppStrings.myProfile)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ZelbyAvatar(size: 100, mood: 'happy'),
              const SizedBox(height: 16),
              Text(
                '${userProgress.playerName} (${userProgress.playerAge} tahun)',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Bergabung sejak ${_formatDate(userProgress.joinDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    emoji: '📈',
                    label: 'Level',
                    value: '${userProgress.level}',
                  ),
                  _StatItem(
                    emoji: '🎮',
                    label: 'Game',
                    value: '${userProgress.totalGamesPlayed}',
                  ),
                  _StatItem(
                    emoji: '🏷️',
                    label: 'Stiker',
                    value: '$unlockedStickers',
                  ),
                  _StatItem(
                    emoji: '🏝️',
                    label: 'Pulau',
                    value: '$completedIslands',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              _ProfileMenuItem(
                icon: Icons.shield_rounded,
                label: AppStrings.parentDashboard,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur orang tua akan hadir segera')),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ProfileMenuItem(
                icon: Icons.settings_rounded,
                label: AppStrings.settings,
                onTap: () {},
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Keluar',
                onPressed: () => context.goNamed('splash'),
                isSecondary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}

class _StatItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatItem({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0B7A5C),
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0B7A5C)),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white,
      onTap: onTap,
    );
  }
}
