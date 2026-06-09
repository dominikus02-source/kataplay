import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/character/character_components.dart';
import '../data/models/question_model.dart';
import '../data/models/learning_session_model.dart';
import '../providers/learning_provider.dart';
import 'renderers/question_renderer.dart';

/// Learning Screen — Premium Duolingo/Lingokids style
/// Shows one question at a time with progress bar, lives, XP, character coach
class LearningScreen extends ConsumerStatefulWidget {
  final String islandId;
  final int levelNumber;
  final int difficulty;
  final String? sessionTitle;

  const LearningScreen({
    super.key,
    required this.islandId,
    this.levelNumber = 1,
    this.difficulty = 1,
    this.sessionTitle,
  });

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _feedbackController;
  late AnimationController _heartShakeController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _heartShakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Start the session after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learningSessionProvider.notifier).startSession(
            islandId: widget.islandId,
            levelNumber: widget.levelNumber,
            difficulty: widget.difficulty,
            sessionTitle: widget.sessionTitle,
          );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _feedbackController.dispose();
    _heartShakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(learningSessionProvider);

    return PopScope(
      canPop: sessionState.phase == LearningSessionPhase.completed,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmation(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: _buildBody(sessionState),
        ),
      ),
    );
  }

  Widget _buildBody(LearningSessionState state) {
    switch (state.phase) {
      case LearningSessionPhase.intro:
        return _IntroView(
          sessionState: state,
          onStart: () {
            ref.read(learningSessionProvider.notifier).startQuestions();
          },
        );

      case LearningSessionPhase.question:
        return _QuestionView(
          sessionState: state,
          onAnswer: (answerId) {
            ref.read(learningSessionProvider.notifier).submitAnswer(answerId);
            _feedbackController.forward(from: 0);
          },
          onTextAnswer: (answer) {
            ref.read(learningSessionProvider.notifier).submitTextAnswer(answer);
            _feedbackController.forward(from: 0);
          },
          onSequenceAnswer: (positions) {
            ref.read(learningSessionProvider.notifier).submitSequence(positions);
            _feedbackController.forward(from: 0);
          },
          onShowHint: () {
            ref.read(learningSessionProvider.notifier).showHint();
          },
        );

      case LearningSessionPhase.feedback:
        final lastCorrect = state.lastAnswerCorrect ?? false;
        if (lastCorrect) {
          // No confetti for single answer - only for session completion
        } else {
          _heartShakeController.forward(from: 0);
        }

        return _FeedbackView(
          sessionState: state,
          onContinue: () {
            ref.read(learningSessionProvider.notifier).nextQuestion();
          },
        );

      case LearningSessionPhase.completed:
        _confettiController.play();
        return _CompletionView(
          sessionState: state,
          confettiController: _confettiController,
          onRetry: () {
            ref.read(learningSessionProvider.notifier).retrySession();
          },
          onGoHome: () => context.goNamed('home'),
        );
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Keluar dari belajar?'),
        content: const Text(
          'Progres belajarmu tidak akan disimpan. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Lanjut Belajar'),
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
// TOP BAR — Progress, Lives, XP
// ============================================================

class _TopBar extends StatelessWidget {
  final LearningSessionState sessionState;

  const _TopBar({required this.sessionState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: () => _showExitConfirmation(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, size: 24),
            ),
          ),

          const SizedBox(width: 12),

          // Progress bar
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: sessionState.progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ).animate(target: sessionState.progress > 0 ? 1 : 0)
                          .fadeIn(duration: 300.ms),
                    ),
                    // Star markers at 25%, 50%, 75%
                    ..._buildStarMarkers(sessionState.questions.length),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Lives (hearts)
          _LivesDisplay(
            livesRemaining: sessionState.livesRemaining,
            maxLives: sessionState.maxLives,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStarMarkers(int totalQuestions) {
    if (totalQuestions == 0) return [];
    final markers = <Widget>[];
    for (final fraction in [0.25, 0.5, 0.75]) {
      markers.add(
        Positioned(
          left: fraction * (MediaQuery.of(context).size.width - 160),
          top: -1,
          child: const Text('⭐', style: TextStyle(fontSize: 10)),
        ),
      );
    }
    return markers;
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Keluar dari belajar?'),
        content: const Text(
          'Progres belajarmu tidak akan disimpan. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Lanjut Belajar'),
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

/// Animated hearts/lives display
class _LivesDisplay extends StatelessWidget {
  final int livesRemaining;
  final int maxLives;

  const _LivesDisplay({
    required this.livesRemaining,
    required this.maxLives,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: livesRemaining <= 1
            ? AppColors.error.withOpacity(0.1)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxLives, (index) {
          final isFilled = index < livesRemaining;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              isFilled ? '❤️' : '🩶',
              style: const TextStyle(fontSize: 18),
            ).animate(target: isFilled ? 0 : 1).scale(
                  begin: const Offset(1.3, 1.3),
                  end: const Offset(1, 1),
                  duration: 300.ms,
                ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// INTRO VIEW — Session start with character greeting
// ============================================================

class _IntroView extends StatelessWidget {
  final LearningSessionState sessionState;
  final VoidCallback onStart;

  const _IntroView({
    required this.sessionState,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final firstQuestion = sessionState.questions.isNotEmpty
        ? sessionState.questions.first
        : null;
    final character = firstQuestion?.effectiveCharacter ?? CharacterType.zelby;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character greeting
            CharacterIllustration(character: character, size: 100)
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 24),

            // Greeting bubble
            CharacterCoachBubble(
              character: character,
              message: CharacterMessages.getGreeting(character),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 32),

            // Session title
            Text(
              sessionState.sessionTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 8),

            Text(
              '${sessionState.questions.length} soal menanti!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 700.ms),

            const SizedBox(height: 40),

            // Start button
            PrimaryButton(
              label: 'Ayo Mulai!',
              icon: Icons.play_arrow_rounded,
              onPressed: onStart,
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// QUESTION VIEW — The main question display
// ============================================================

class _QuestionView extends StatelessWidget {
  final LearningSessionState sessionState;
  final Function(String) onAnswer;
  final Function(String) onTextAnswer;
  final Function(List<int>) onSequenceAnswer;
  final VoidCallback onShowHint;

  const _QuestionView({
    required this.sessionState,
    required this.onAnswer,
    required this.onTextAnswer,
    required this.onSequenceAnswer,
    required this.onShowHint,
  });

  @override
  Widget build(BuildContext context) {
    final question = sessionState.currentQuestion;
    if (question == null) {
      return const Center(
        child: Text('Tidak ada soal', style: TextStyle(fontSize: 18)),
      );
    }

    final character = question.effectiveCharacter;

    return Column(
      children: [
        // Top bar with progress & lives
        _TopBar(sessionState: sessionState),

        const SizedBox(height: 8),

        // XP indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.coinGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${sessionState.totalCoinsEarned}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.coinGold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${sessionState.totalXpEarned} XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Coach bubble (greeting/hint)
        if (sessionState.showHint && question.hint != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharacterCoachBubble(
              character: character,
              message: question.hint!,
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharacterCoachBubble(
              character: character,
              message: CharacterMessages.getGreeting(character),
              characterSize: 36,
            ),
          ),

        const SizedBox(height: 16),

        // Question content area (scrollable to prevent overflow)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Question card
                _QuestionCard(
                  question: question,
                  onAnswer: onAnswer,
                  onTextAnswer: onTextAnswer,
                  onSequenceAnswer: onSequenceAnswer,
                ),

                const SizedBox(height: 16),

                // Hint button (if hint available)
                if (question.hint != null && !sessionState.showHint)
                  TextButton.icon(
                    onPressed: onShowHint,
                    icon: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    label: Text(
                      'Butuh petunjuk?',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Question card that delegates to the appropriate renderer
class _QuestionCard extends StatelessWidget {
  final Question question;
  final Function(String) onAnswer;
  final Function(String) onTextAnswer;
  final Function(List<int>) onSequenceAnswer;

  const _QuestionCard({
    required this.question,
    required this.onAnswer,
    required this.onTextAnswer,
    required this.onSequenceAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instruction line (small, above question)
          if (question.instruction != null)
            Text(
              question.instruction!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

          const SizedBox(height: 8),

          // Emoji / visual (if present)
          if (question.emoji != null) ...[
            Center(
              child: Text(
                question.emoji!,
                style: const TextStyle(fontSize: 56),
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  ),
            ),
            const SizedBox(height: 12),
          ],

          // Question text
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  height: 1.3,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Question renderer — delegates to type-specific widget
          QuestionRenderer(
            question: question,
            onAnswer: onAnswer,
            onTextAnswer: onTextAnswer,
            onSequenceAnswer: onSequenceAnswer,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FEEDBACK VIEW — Correct / Wrong feedback
// ============================================================

class _FeedbackView extends StatelessWidget {
  final LearningSessionState sessionState;
  final VoidCallback onContinue;

  const _FeedbackView({
    required this.sessionState,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = sessionState.lastAnswerCorrect ?? false;
    final question = sessionState.currentQuestion;
    final character = question?.effectiveCharacter ?? CharacterType.zelby;
    final feedbackMsg = sessionState.feedbackMessage ?? (isCorrect ? 'Benar!' : 'Coba lagi!');

    final accentColor = isCorrect ? AppColors.success : AppColors.error;
    final bgColor = isCorrect
        ? AppColors.success.withOpacity(0.05)
        : AppColors.error.withOpacity(0.05);

    return Container(
      color: bgColor,
      child: Column(
        children: [
          // Top bar
          _TopBar(sessionState: sessionState),

          const Spacer(),

          // Feedback icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isCorrect ? '✅' : '💪',
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 24),

          // Feedback title
          Text(
            isCorrect ? 'Benar!' : 'Belum tepat!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: accentColor,
                ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 12),

          // Feedback message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              feedbackMsg,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 24),

          // Character coach bubble
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CharacterCoachBubble(
              character: character,
              message: isCorrect
                  ? CharacterMessages.getCorrectPraise(character)
                  : CharacterMessages.getWrongComfort(character),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.15, end: 0),

          // XP earned (only if correct)
          if (isCorrect && question != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.coinGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '+${question.coinReward}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.coinGold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('⭐', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '+${question.xpReward} XP',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],

          const Spacer(),

          // Continue button
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(
              label: 'Lanjut',
              icon: Icons.arrow_forward_rounded,
              onPressed: onContinue,
              backgroundColor: accentColor,
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
}

// ============================================================
// COMPLETION VIEW — Session finished with celebration
// ============================================================

class _CompletionView extends StatelessWidget {
  final LearningSessionState sessionState;
  final ConfettiController confettiController;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;

  const _CompletionView({
    required this.sessionState,
    required this.confettiController,
    required this.onRetry,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccessful = sessionState.isSuccessful;
    final character = sessionState.questions.isNotEmpty
        ? sessionState.questions.first.effectiveCharacter
        : CharacterType.zelby;

    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            colors: const [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
              AppColors.coinGold,
              AppColors.success,
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
                const SizedBox(height: 32),

                // Character celebration
                CharacterIllustration(character: character, size: 100)
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 24),

                // Title
                Text(
                  isSuccessful
                      ? (sessionState.isPerfect ? 'Sempurna! 🌟' : 'Bagus Sekali!')
                      : 'Jangan Menyerah!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: isSuccessful ? AppColors.primary : AppColors.secondary,
                      ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  isSuccessful
                      ? 'Kamu sudah menyelesaikan ${sessionState.correctCount} dari ${sessionState.totalQuestions} soal!'
                      : 'Coba lagi, kamu pasti bisa!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 32),

                // Stars earned
                _StarsDisplay(stars: sessionState.starsEarned)
                    .animate()
                    .fadeIn(delay: 600.ms),

                const SizedBox(height: 32),

                // Rewards card
                _CompletionRewardsCard(sessionState: sessionState)
                    .animate()
                    .slideY(begin: 0.3, end: 0, delay: 700.ms)
                    .fadeIn(),

                const SizedBox(height: 32),

                // Character message
                CharacterCoachBubble(
                  character: character,
                  message: isSuccessful
                      ? CharacterMessages.getCorrectPraise(character)
                      : CharacterMessages.getWrongComfort(character),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 32),

                // Action buttons
                PrimaryButton(
                  label: AppStrings.playAgain,
                  icon: Icons.replay_rounded,
                  onPressed: onRetry,
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

/// Stars display for completion screen
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

/// Rewards summary card on completion
class _CompletionRewardsCard extends StatelessWidget {
  final LearningSessionState sessionState;

  const _CompletionRewardsCard({required this.sessionState});

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
          Text(
            'Hadiah Kamu',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RewardItem(
                emoji: '✅',
                label: 'Benar',
                value: '${sessionState.correctCount}',
                color: AppColors.success,
              ),
              _RewardItem(
                emoji: '🪙',
                label: AppStrings.coins,
                value: '+${sessionState.totalCoinsEarned}',
                color: AppColors.coinGold,
              ),
              _RewardItem(
                emoji: '⭐',
                label: AppStrings.xp,
                value: '+${sessionState.totalXpEarned}',
                color: AppColors.primary,
              ),
            ],
          ),
          if (sessionState.isPerfect) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌟', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Sempurna! Tidak ada kesalahan!',
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
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
