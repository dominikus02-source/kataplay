import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/zelby_avatar.dart';

/// Reward Screen - Celebration view after completing a lesson/game
/// Matches reference design: sunburst background, confetti, character celebration,
/// "+100 Koin" badge, "Hebat Sekali!" title, green "Lanjut" button
class RewardScreen extends ConsumerStatefulWidget {
  final String title;
  final String message;
  final int coinsEarned;
  final int xpEarned;
  final int starsEarned;
  final VoidCallback? onContinue;
  final VoidCallback? onGoHome;

  const RewardScreen({
    super.key,
    this.title = 'Hebat Sekali!',
    this.message = 'Kamu berhasil menyelesaikan pelajaran!',
    this.coinsEarned = 100,
    this.xpEarned = 50,
    this.starsEarned = 3,
    this.onContinue,
    this.onGoHome,
  });

  @override
  ConsumerState<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends ConsumerState<RewardScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    // Trigger confetti after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sunburst gradient background
          _buildSunburstBackground(),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                AppColors.confettiPurple,
                AppColors.confettiPink,
                AppColors.confettiBlue,
                AppColors.confettiGreen,
                AppColors.confettiOrange,
                AppColors.confettiYellow,
              ],
              maxBlastForce: 20,
              minBlastForce: 5,
              particleDrag: 0.05,
              numberOfParticles: 40,
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Title "Hebat Sekali!"
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms).scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),

                    const SizedBox(height: 24),

                    // Reward badge (+100 Koin)
                    _RewardBadge(
                      coinsEarned: widget.coinsEarned,
                      pulseController: _pulseController,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 32),

                    // Character celebration
                    const ZelbyAvatar(size: 120, mood: 'celebrating')
                        .animate()
                        .scale(
                          begin: const Offset(0.3, 0.3),
                          end: const Offset(1, 1),
                          duration: 800.ms,
                          curve: Curves.elasticOut,
                        ),

                    const SizedBox(height: 24),

                    // Stars earned
                    _StarsDisplay(stars: widget.starsEarned)
                        .animate()
                        .fadeIn(delay: 600.ms),

                    const SizedBox(height: 20),

                    // XP earned
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            '+${widget.xpEarned} XP',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 40),

                    // Green "Lanjut" button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.onContinue ??
                            () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Lanjut',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunburstBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF176), // Light yellow top
            Color(0xFFFFEE58), // Yellow
            Color(0xFFFFD93D), // Sunny yellow
            Color(0xFF4CAF50), // Green bottom
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _SunburstPainter(),
        size: Size.infinite,
      ),
    );
  }
}

/// Sunburst rays painter for celebration background
class _SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);
    final rayCount = 16;
    final rayAngle = (2 * 3.14159) / rayCount;

    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rayCount; i++) {
      final angle = i * rayAngle;
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + (size.width * 1.5) * (angle + rayAngle * 0.3).cos(),
        center.dy + (size.width * 1.5) * (angle + rayAngle * 0.3).sin(),
      );
      path.lineTo(
        center.dx + (size.width * 1.5) * (angle - rayAngle * 0.3).cos(),
        center.dy + (size.width * 1.5) * (angle - rayAngle * 0.3).sin(),
      );
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reward badge showing coins earned
class _RewardBadge extends StatelessWidget {
  final int coinsEarned;
  final AnimationController pulseController;

  const _RewardBadge({
    required this.coinsEarned,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.05);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Coin icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.coinGold,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '+$coinsEarned Koin',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stars display for reward screen
class _StarsDisplay extends StatelessWidget {
  final int stars;

  const _StarsDisplay({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isFilled = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            isFilled ? '⭐' : '☆',
            style: TextStyle(
              fontSize: 48,
              color: isFilled ? AppColors.accent : AppColors.surfaceVariant,
            ),
          ).animate(target: isFilled ? 1 : 0).scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 400.ms,
                delay: (index * 200).ms,
                curve: Curves.elasticOut,
              ),
        );
      }),
    );
  }
}
