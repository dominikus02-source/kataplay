import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/kata_decorations.dart';
import '../../../../core/providers/providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: Center(
                  child: SizedBox(
                    width: AppDimensions.appMaxWidth,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        children: [
                          SoftBlob(top: -50, right: -50, size: 200, color: AppColors.secondary, opacity: 0.04),
                          SoftBlob(bottom: 100, left: -40, size: 140, color: AppColors.primary, opacity: 0.03),
                          SparkleDot(top: 80, right: 40, size: 8, color: AppColors.primary, opacity: 0.12),
                          SparkleDot(bottom: 180, left: 30, size: 6, color: AppColors.tertiary, opacity: 0.1),
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child:                                   TextButton(
                                    onPressed: () {
                                    final hasName = ref.read(progressProvider).childName.isNotEmpty;
                                    final onboardingDone = ref.read(settingsProvider).onboardingComplete;
                                    context.go(hasName || onboardingDone ? '/home' : '/onboarding');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        'Lewati',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary.withValues(alpha: 0.6)),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                _buildIllustration(),
                                const SizedBox(height: 32),
                                _buildTitle(),
                                const SizedBox(height: 12),
                                _buildSubtitle(),
                                const SizedBox(height: 40),
                                _buildActions(context, ref),
                                Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.02)],
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.safety_check_rounded, size: 70, color: AppColors.primary),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Masuk ke KataPlay',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Masuk untuk menyimpan progress\n di semua perangkat.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          PrimaryButton(
            label: 'Lanjut sebagai Tamu',
            onPressed: () {
              final hasName = ref.read(progressProvider).childName.isNotEmpty;
              final onboardingDone = ref.read(settingsProvider).onboardingComplete;
              final route = hasName || onboardingDone ? '/home' : '/onboarding';
              context.go(route);
            },
            icon: Icons.arrow_forward_rounded,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textLight.withValues(alpha: 0.25)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.person_add_alt_1_rounded, size: 14, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Masuk dengan Akun',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Segera hadir',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
