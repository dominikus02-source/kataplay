import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/adventure/presentation/pulau_kata_screen.dart';
import '../../features/minigames/presentation/minigames_hub_screen.dart';
import '../../features/minigames/presentation/cocokkan_kata_screen.dart';
import '../../features/learning/presentation/learning_screen.dart';
import '../../features/rewards/presentation/collection_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

/// Central router configuration for KataPlay
/// All navigation must go through here
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // === AUTH FLOW ===
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // === MAIN APP (Bottom Navigation Shell) ===
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/pulau',
            name: 'pulau',
            builder: (context, state) => const PulauKataScreen(),
          ),
          GoRoute(
            path: '/main',
            name: 'main',
            builder: (context, state) => const MinigamesHubScreen(),
          ),
          GoRoute(
            path: '/koleksi',
            name: 'koleksi',
            builder: (context, state) => const CollectionScreen(),
          ),
          GoRoute(
            path: '/profil',
            name: 'profil',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // === GAME & REWARD SCREENS (full screen, no bottom nav) ===
      GoRoute(
        path: '/game/matching',
        name: 'game-matching',
        builder: (context, state) {
          final level = state.uri.queryParameters['level'];
          return CocokkanKataScreen(
            level: level != null ? int.tryParse(level) ?? 1 : 1,
          );
        },
      ),
      GoRoute(
        path: '/learning',
        name: 'learning',
        builder: (context, state) {
          final islandId = state.uri.queryParameters['island'] ?? 'awal';
          final level = state.uri.queryParameters['level'] ?? '1';
          final difficulty = state.uri.queryParameters['difficulty'] ?? '1';
          final title = state.uri.queryParameters['title'];
          return LearningScreen(
            islandId: islandId,
            levelNumber: int.tryParse(level) ?? 1,
            difficulty: int.tryParse(difficulty) ?? 1,
            sessionTitle: title,
          );
        },
      ),
      GoRoute(
        path: '/reward',
        name: 'reward',
        builder: (context, state) => const PlaceholderRewardScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🤔',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Coba kembali ke beranda ya!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed('home'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Placeholder reward screen (will be built in Phase 2)
class PlaceholderRewardScreen extends StatelessWidget {
  const PlaceholderRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hadiah')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Layar Reward & Celebration',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Hadir di update berikutnya!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
