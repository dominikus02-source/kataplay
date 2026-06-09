import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';
import '../../rewards/data/models/sticker_model.dart';

/// Koleksi - Stickers, achievements, unlocked content
/// Now powered by real sticker data from providers
class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stickers = ref.watch(stickerCollectionProvider);
    final unlockedCount = stickers.where((s) => s.isUnlocked).length;
    final totalCount = stickers.length;

    // Group stickers by category
    final categories = <String, List<Sticker>>{};
    for (final sticker in stickers) {
      categories.putIfAbsent(sticker.category, () => []).add(sticker);
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navCollection)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ZelbyAvatar(
                mood: unlockedCount >= 10 ? 'proud' : 'happy',
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                'Koleksi Stiker & Pencapaianmu',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '$unlockedCount dari $totalCount stiker terkumpul',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: unlockedCount >= totalCount / 2
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: totalCount > 0 ? unlockedCount / totalCount : 0,
                minHeight: 8,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 24),

              // Sticker grid grouped by category
              Expanded(
                child: ListView(
                  children: categories.entries.map((entry) {
                    final category = entry.key;
                    final categoryStickers = entry.value;
                    final categoryLabels = {
                      'hewan': 'Hewan',
                      'buah': 'Buah',
                      'alfabet': 'Alfabet',
                      'karakter': 'Karakter',
                      'warna': 'Warna',
                      'makanan': 'Makanan',
                    };

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            categoryLabels[category] ?? category,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: categoryStickers.map<Widget>((sticker) {
                            final isUnlocked = sticker.isUnlocked;
                            return Tooltip(
                              message: isUnlocked ? sticker.name : '???',
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? AppColors.primary.withOpacity(0.3)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: isUnlocked
                                      ? Text(
                                          sticker.emoji,
                                          style: const TextStyle(fontSize: 28),
                                        )
                                      : const Text(
                                          '?',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
