import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Beautiful 4-slide onboarding with Zelby
/// Now saves onboarding completion to Hive
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      mood: 'happy',
      emoji: '👋',
    ),
    _OnboardingPageData(
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      mood: 'excited',
      emoji: '🎮',
    ),
    _OnboardingPageData(
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      mood: 'curious',
      emoji: '❤️',
    ),
    _OnboardingPageData(
      title: AppStrings.onboarding4Title,
      description: AppStrings.onboarding4Desc,
      mood: 'celebrating',
      emoji: '🚀',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    // Save onboarding completion to Hive
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.completeOnboarding(
      playerName: 'Petualang',
      playerAge: 6,
    );

    // Update the onboarding state provider
    ref.read(onboardingCompleteProvider.notifier).state = true;

    if (mounted) {
      context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text(AppStrings.skip),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ZelbyAvatar(
                          size: 160,
                          mood: p.mood,
                        ),
                        const SizedBox(height: 40),

                        Text(
                          p.title,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          p.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: WormEffect(
                      dotColor: Colors.grey.shade300,
                      activeDotColor: const Color(0xFF0B7A5C),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10,
                    ),
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: _currentPage == _pages.length - 1
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    onPressed: _nextPage,
                    icon: _currentPage == _pages.length - 1
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final String mood;
  final String emoji;

  _OnboardingPageData({
    required this.title,
    required this.description,
    required this.mood,
    required this.emoji,
  });
}
