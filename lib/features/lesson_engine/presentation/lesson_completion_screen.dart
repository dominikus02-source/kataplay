import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../domain/lesson_result.dart';

class LessonCompletionContent extends StatelessWidget {
  final LessonResult result;
  final VoidCallback onContinue;

  const LessonCompletionContent({
    super.key,
    required this.result,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                _buildStars(),
                const SizedBox(height: 32),
                _buildCelebrationMessage(),
                const SizedBox(height: 32),
                _buildStatsCard(),
                const SizedBox(height: 40),
                _buildXpRow(),
                const SizedBox(height: 48),
                _buildContinueButton(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < result.stars;
        return Padding(
          padding: EdgeInsets.only(left: i > 0 ? 12 : 0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300 + (i * 200)),
            curve: Curves.elasticOut,
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? AppColors.gold : AppColors.goldBg,
              boxShadow: filled
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: filled ? AppColors.goldDark : AppColors.textSecondary,
              size: 40,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCelebrationMessage() {
    final messages = [
      'Luar biasa!',
      'Kerja bagus!',
      'Kamu hebat!',
      'Pertahankan!',
    ];
    final message = result.isPerfect
        ? 'Sempurna!'
        : messages[result.stars.clamp(0, messages.length - 1)];

    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDimensions.cardShadow(AppColors.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.check_circle_rounded,
            value: '${result.correctSteps}/${result.totalSteps}',
            label: 'Benar',
            color: AppColors.correct,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.cardBorder,
          ),
          _buildStatItem(
            icon: Icons.auto_awesome_rounded,
            value: '${result.totalXpEarned}',
            label: 'XP',
            color: AppColors.goldDark,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.cardBorder,
          ),
          _buildStatItem(
            icon: Icons.star_rounded,
            value: '${result.stars}/3',
            label: 'Bintang',
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildXpRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.goldBg, AppColors.goldLight.withValues(alpha: 0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.goldDark, size: 28),
          const SizedBox(width: 8),
          const Text(
            '+',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.goldDark,
            ),
          ),
          Text(
            '${result.totalXpEarned}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.goldDark,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'XP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
        child: const Text(
          'Lanjut',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
