import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/character_assets.dart';
import '../../../../core/providers/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isCelebrating = false;
  bool _isButtonPressed = false;

  Future<void> _onStartPressed() async {
    setState(() {
      _isButtonPressed = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _isCelebrating = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    await ref.read(settingsProvider.notifier).markOnboardingComplete();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: AppColors.scaffoldOuter,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.background,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: SizedBox(
                          width: AppDimensions.appMaxWidth,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              24,
                              MediaQuery.of(context).padding.top + 12,
                              24,
                              bottomPadding > 0 ? bottomPadding + 16 : 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLogo(),
                                const SizedBox(height: 28),
                                _buildHeadline(),
                                const SizedBox(height: 16),
                                _buildZelbyIllustration(),
                                const SizedBox(height: 12),
                                _buildTagline(),
                                const SizedBox(height: 28),
                                _buildButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Kata',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            decoration: TextDecoration.none,
          ),
        ),
        Text(
          'Play',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -0.5,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _buildHeadline() {
    return Column(
      children: [
        Text(
          'Bahasa Indonesia',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.1,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'untuk anak',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            height: 1.3,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _buildZelbyIllustration() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: Container(
        key: _isCelebrating
            ? const ValueKey('zelby_celebrate')
            : const ValueKey('zelby_reading'),
        height: 300,
        alignment: Alignment.center,
        child: Image.asset(
          _isCelebrating
              ? CharacterAssets.zelbyCelebrate
              : CharacterAssets.zelbyReading,
          height: 300,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.smart_toy_rounded,
            size: 100,
            color: AppColors.zelbyColor.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      'Petualangan Bahasa Indonesia',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.3,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _buildButton() {
    return AnimatedScale(
      scale: _isButtonPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320),
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: _isButtonPressed ? 0.2 : 0.3),
              blurRadius: _isButtonPressed ? 12 : 16,
              offset: Offset(0, _isButtonPressed ? 4 : 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isButtonPressed ? null : _onStartPressed,
            borderRadius: BorderRadius.circular(28),
            splashColor: Colors.white.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isButtonPressed
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mulai Pembelajaran',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.3,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
