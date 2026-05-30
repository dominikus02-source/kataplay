import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/adventure/presentation/pulau_kata_screen.dart';
import '../../features/minigames/presentation/minigames_hub_screen.dart';
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
        builder: (context, state) => const PlaceholderGameScreen(title: 'Cocokkan Kata'),
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
        child: Text(
          'Halaman tidak ditemukan\n${state.error}',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
});

// Temporary placeholder screens until we build the real ones
class PlaceholderGameScreen extends StatelessWidget {
  final String title;
  const PlaceholderGameScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n\n(Mini game akan dibangun di Phase 4)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class PlaceholderRewardScreen extends StatelessWidget {
  const PlaceholderRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '🎉 Layar Reward & Celebration\n\n(Phase 5)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
