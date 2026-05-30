import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Koleksi - Stickers, achievements, unlocked content
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navCollection)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ZelbyAvatar(mood: 'proud', size: 80),
              const SizedBox(height: 24),
              Text(
                'Koleksi Stiker & Pencapaianmu',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Kumpulkan semua stiker dengan menyelesaikan pulau dan mini game!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              const Text('🦎  🐒  🐦  🐢  🌴  🍉', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              Text(
                '3 dari 24 stiker terkumpul',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              const Text(
                'Fitur lengkap hadir di update berikutnya ✨',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
