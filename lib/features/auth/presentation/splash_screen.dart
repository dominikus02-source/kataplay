import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Splash Screen with Zelby animation
/// Now checks onboarding state to navigate correctly
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Auto navigate after 2.2 seconds
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        _navigate();
      }
    });
  }

  void _navigate() {
    final isOnboardingComplete = ref.read(onboardingCompleteProvider);
    if (isOnboardingComplete) {
      // Record daily play when app opens
      ref.read(userProgressProvider.notifier).recordDailyPlay();
      context.goNamed('home');
    } else {
      context.goNamed('onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B7A5C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ZelbyAvatar(size: 140, mood: 'excited')
                .animate()
                .scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .then()
                .shake(duration: 400.ms, hz: 3),

            const SizedBox(height: 32),

            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 8),

            Text(
              AppStrings.tagline,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 60),

            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ).animate().fadeIn(delay: 900.ms),
          ],
        ),
      ),
    );
  }
}
