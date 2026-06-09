import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/zelby_avatar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../data/models/matching_game_model.dart';
import '../providers/matching_game_provider.dart';

/// Cocokkan Kata - Picture Match Game
/// Redesigned to match reference: vibrant card layout, mascot at top,
/// colorful 2x2 animal buttons, pink content area
class CocokkanKataScreen extends ConsumerStatefulWidget {
  final int level;

  const CocokkanKataScreen({super.key, this.level = 1});

  @override
  ConsumerState<CocokkanKataScreen> createState() => _CocokkanKataScreenState();
}

class _CocokkanKataScreenState extends ConsumerState<CocokkanKataScreen> {
  late ConfettiController _confettiController;

  // Card background colors for variety
  final List<Color> _cardColors = [
    AppColors.cardTeal,
    AppColors.cardBlue,
    AppColors.cardOrange,
    AppColors.cardGreen,
    AppColors.cardPurple,
    AppColors.buttonOrange,
    AppColors.pink,
    AppColors.primary,
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchingGameProvider.notifier).startGame(level: widget.level);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(matchingGameProvider);

    return PopScope(
      canPop: gameState.phase == GamePhase.completed,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmation(context);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF176), // Yellow top
                AppColors.pinkBg,  // Pink bottom
              ],
            ),
          ),
          child: SafeArea(
            child: _buildBody(gameState),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MatchingGameState gameState) {
    switch (gameState.phase) {
      case GamePhase.idle:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );

      case GamePhase.playing:
      case GamePhase.showingResult:
        return Column(
          children: [
            // Top bar
            _buildTopBar(gameState),
            const SizedBox(height: 8),
            // Game card area
            Expanded(
              child: _buildGameCard(gameState),
            ),
          ],
        );

      case GamePhase.completed:
        _confettiController.play();
        return _GameCompleteView(
          gameState: gameState,
          confettiController: _confettiController,
          onNextLevel: () {
            ref.read(matchingGameProvider.notifier).nextLevel();
          },
          onPlayAgain: () {
            ref.read(matchingGameProvider.notifier).restartGame();
          },
          onGoHome: () => context.goNamed('home'),
        );
    }
  }

  Widget _buildTopBar(MatchingGameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => _showExitConfirmation(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          // Level title
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEE58), // Yellow header
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${AppStrings.gameMatchingTitle} - Level ${gameState.currentLevel}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Timer
          if (gameState.phase == GamePhase.playing)
            _TimerDisplay(
              remaining: gameState.timeRemaining,
              total: gameState.timeLimit.inSeconds,
            ),
        ],
      ),
    );
  }

  Widget _buildGameCard(MatchingGameState gameState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mascot at top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.pinkBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              children: [
                // Zelby mascot
                const ZelbyAvatar(size: 64, mood: 'excited')
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .shake(hz: 2, rotation: 0.03, duration: 2000.ms),
                const SizedBox(height: 8),
                // Score bar
                _ScoreBar(gameState: gameState),
              ],
            ),
          ),

          // Game grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildVibrantGrid(gameState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVibrantGrid(MatchingGameState gameState) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gameState.gridColumns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: gameState.cards.length,
      itemBuilder: (context, index) {
        final card = gameState.cards[index];
        final colorIndex = index % _cardColors.length;
        return _VibrantCardWidget(
          card: card,
          backgroundColor: _cardColors[colorIndex],
          onTap: () => ref.read(matchingGameProvider.notifier).onCardTapped(card.id),
        );
      },
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Keluar dari permainan?'),
        content: const Text(
          'Progres permainanmu tidak akan disimpan. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Lanjut Bermain'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.goNamed('home');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TIMER DISPLAY
// ============================================================

class _TimerDisplay extends StatelessWidget {
  final int remaining;
  final int total;

  const _TimerDisplay({required this.remaining, required this.total});

  @override
  Widget build(BuildContext context) {
    final isLow = remaining <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLow ? AppColors.error.withOpacity(0.15) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLow ? Icons.timer_off_rounded : Icons.timer_rounded,
            size: 20,
            color: isLow ? AppColors.error : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '${remaining}s',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isLow ? AppColors.error : AppColors.primary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SCORE BAR
// ============================================================

class _ScoreBar extends StatelessWidget {
  final MatchingGameState gameState;

  const _ScoreBar({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ScoreItem(
            icon: '✅',
            label: 'Cocok',
            value: '${gameState.correctMatches}/${gameState.totalPairs}',
            color: AppColors.success,
          ),
          _ScoreItem(
            icon: '❌',
            label: 'Salah',
            value: '${gameState.wrongAttempts}',
            color: AppColors.error,
          ),
          _ScoreItem(
            icon: '🪙',
            label: 'Koin',
            value: '${gameState.coinsEarned}',
            color: AppColors.coinGold,
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _ScoreItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VIBRANT CARD WIDGET (replaces _MatchCardWidget)
// ============================================================

class _VibrantCardWidget extends StatefulWidget {
  final MatchCard card;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _VibrantCardWidget({
    required this.card,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<_VibrantCardWidget> createState() => _VibrantCardWidgetState();
}

class _VibrantCardWidgetState extends State<_VibrantCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(covariant _VibrantCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isRevealed && !oldWidget.card.isRevealed) {
      _controller.forward();
    } else if (!widget.card.isRevealed && oldWidget.card.isRevealed) {
      _controller.reverse();
    }
    if (widget.card.isMatched && !oldWidget.card.isMatched) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final isWord = card.type == CardType.word;

    return GestureDetector(
      onTap: card.isRevealed || card.isMatched ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: card.isRevealed || card.isMatched
                ? _scaleAnimation.value
                : 1.0,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: card.isMatched
                ? AppColors.success.withOpacity(0.2)
                : card.isRevealed
                    ? widget.backgroundColor
                    : widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: card.isMatched
                  ? AppColors.success
                  : Colors.white.withOpacity(0.3),
              width: card.isMatched ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: card.isMatched
                    ? AppColors.success.withOpacity(0.2)
                    : widget.backgroundColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: card.isRevealed || card.isMatched
                ? _buildRevealedContent(card, isWord)
                : _buildHiddenContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedContent(MatchCard card, bool isWord) {
    if (isWord) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          child: Text(
            card.display,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Text(
        card.display,
        style: const TextStyle(fontSize: 36),
      ).animate(target: card.isMatched ? 1.0 : 0.0).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 300.ms,
          );
    }
  }
}

// ============================================================
// GAME COMPLETE VIEW
// ============================================================

class _GameCompleteView extends StatelessWidget {
  final MatchingGameState gameState;
  final ConfettiController confettiController;
  final VoidCallback onNextLevel;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const _GameCompleteView({
    required this.gameState,
    required this.confettiController,
    required this.onNextLevel,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
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
            numberOfParticles: 30,
          ),
        ),

        // Content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Zelby celebration
                const ZelbyAvatar(size: 120, mood: 'celebrating')
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 32),

                // Title
                Text(
                  gameState.isPerfect ? 'Sempurna! 🌟' : 'Hebat Sekali!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: gameState.isPerfect ? AppColors.accent : AppColors.primary,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 8),

                Text(
                  gameState.isPerfect
                      ? 'Kamu sempurna! Tidak ada kesalahan!'
                      : 'Kamu berhasil mencocokkan semua kata!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 40),

                // Rewards card
                _RewardsCard(gameState: gameState)
                    .animate()
                    .slideY(begin: 0.3, end: 0, delay: 600.ms)
                    .fadeIn(),

                const SizedBox(height: 40),

                // Action buttons
                if (gameState.currentLevel < 3)
                  PrimaryButton(
                    label: 'Level ${gameState.currentLevel + 1}',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: onNextLevel,
                  ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 12),

                PrimaryButton(
                  label: AppStrings.playAgain,
                  icon: Icons.replay_rounded,
                  onPressed: onPlayAgain,
                  isSecondary: true,
                ).animate().fadeIn(delay: 900.ms),

                const SizedBox(height: 12),

                PrimaryButton(
                  label: AppStrings.backToHome,
                  onPressed: onGoHome,
                  isSecondary: true,
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// REWARDS CARD
// ============================================================

class _RewardsCard extends StatelessWidget {
  final MatchingGameState gameState;

  const _RewardsCard({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Hadiah Kamu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RewardItem(
                emoji: '🪙',
                label: AppStrings.coins,
                value: '+${gameState.coinsEarned}',
                color: AppColors.coinGold,
              ),
              _RewardItem(
                emoji: '📈',
                label: AppStrings.xp,
                value: '+${gameState.xpEarned}',
                color: AppColors.primary,
              ),
              _RewardItem(
                emoji: '✅',
                label: 'Cocok',
                value: '${gameState.correctMatches}',
                color: AppColors.success,
              ),
            ],
          ),
          if (gameState.isPerfect) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('⭐', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Perfect Score Bonus!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _RewardItem({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
