import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Hub for all Mini Games
/// Currently shows 3 planned games (MVP implements "Cocokkan Kata" first)
class MinigamesHubScreen extends StatelessWidget {
  const MinigamesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.playMiniGames),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih permainan seru untuk hari ini!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),

              _GameCard(
                title: AppStrings.gameMatchingTitle,
                description: AppStrings.gameMatchingDesc,
                emoji: '🧩',
                isAvailable: true,
                onTap: () => context.goNamed('game-matching'),
              ),
              const SizedBox(height: 16),
              _GameCard(
                title: AppStrings.gameArrangeTitle,
                description: AppStrings.gameArrangeDesc,
                emoji: '🔤',
                isAvailable: false,
              ),
              const SizedBox(height: 16),
              _GameCard(
                title: AppStrings.gameListenTitle,
                description: AppStrings.gameListenDesc,
                emoji: '👂',
                isAvailable: false,
              ),

              const Spacer(),

              const Center(
                child: ZelbyAvatar(
                  size: 64,
                  mood: 'excited',
                  showSpeechBubble: true,
                  speechText: 'Cocokkan Kata paling seru loh!',
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
  final bool isAvailable;
  final VoidCallback? onTap;

  const _GameCard({
    required this.title,
    required this.description,
    required this.emoji,
    this.isAvailable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAvailable ? onTap : null,
      borderRadius: BorderRadius.circular(24),
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.6,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 42)),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isAvailable)
                const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0B7A5C))
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Segera', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
