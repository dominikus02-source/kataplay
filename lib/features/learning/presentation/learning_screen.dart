import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/character/character_components.dart';
import '../data/models/question_model.dart';
import '../data/models/learning_session_model.dart';
import '../providers/learning_provider.dart';
import 'renderers/question_renderer.dart';

/// Learning Screen — Bright iOS Modern Theme for Kids
/// Soft lavender-white backgrounds, vibrant accents, clean rounded UI
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
  late AnimationController _heartShakeController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
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
        backgroundColor: AppColors.learningBg,
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
          onSelectAnswer: (answerId) {
            ref.read(learningSessionProvider.notifier).selectAnswer(answerId);
          },
          onCheckAnswer: () {
            ref.read(learningSessionProvider.notifier).checkAnswer();
          },
          onTextAnswer: (answer) {
            ref.read(learningSessionProvider.notifier).submitTextAnswer(answer);
          },
          onSequenceAnswer: (positions) {
            ref.read(learningSessionProvider.notifier).submitSequence(positions);
          },
          onShowHint: () {
            ref.read(learningSessionProvider.notifier).showHint();
          },
        );

      case LearningSessionPhase.feedback:
        final lastCorrect = state.lastAnswerCorrect ?? false;
        if (!lastCorrect) {
          _heartShakeController.forward(from: 0);
        }

        return _FeedbackView(
          sessionState: state,
          onContinue: () {
            ref.read(learningSessionProvider.notifier).nextQuestion();
          },
        );

      case LearningSessionPhase.combo:
        return _ComboCelebrationView(
          sessionState: state,
          onContinue: () {
            ref.read(learningSessionProvider.notifier).skipComboCelebration();
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Keluar dari belajar?',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.learningTextPrimary,
          ),
        ),
        content: Text(
          'Progres belajarmu tidak akan disimpan. Yakin ingin keluar?',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.learningTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Lanjut Belajar',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                color: AppColors.learningCheckBtn,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.goNamed('home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.learningWrong,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BRIGHT TOP BAR — Close, KOMBO progress, Lives
// ============================================================

class _BrightTopBar extends StatelessWidget {
  final LearningSessionState sessionState;

  const _BrightTopBar({required this.sessionState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Close button (X)
          GestureDetector(
            onTap: () => _showExitConfirmation(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.learningSurface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.learningTextSecondary,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // KOMBO progress bar with vibrant fill
          Expanded(
            child: Column(
              children: [
                // Combo indicator
                if (sessionState.comboCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'KOMBO',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.learningCombo,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'x${sessionState.comboCount}',
                          style: GoogleFonts.fredoka(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.learningCombo,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Progress bar
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.learningComboBg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Stack(
                      children: [
                        // Vibrant purple progress fill
                        FractionallySizedBox(
                          widthFactor: sessionState.progress.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.learningCheckBtn, Color(0xFFB388FF)],
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Lives (hearts)
          _BrightLivesDisplay(
            livesRemaining: sessionState.livesRemaining,
            maxLives: sessionState.maxLives,
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Keluar dari belajar?',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.learningTextPrimary,
          ),
        ),
        content: Text(
          'Progres belajarmu tidak akan disimpan.',
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: AppColors.learningTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Lanjut',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                color: AppColors.learningCheckBtn,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.goNamed('home');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.learningWrong),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Animated hearts/lives display — bright theme
class _BrightLivesDisplay extends StatelessWidget {
  final int livesRemaining;
  final int maxLives;

  const _BrightLivesDisplay({
    required this.livesRemaining,
    required this.maxLives,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: livesRemaining <= 1
            ? AppColors.learningFeedbackWrongBg
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxLives, (index) {
          final isFilled = index < livesRemaining;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Icon(
              isFilled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFilled
                  ? (livesRemaining <= 1 ? AppColors.learningWrong : Colors.redAccent)
                  : AppColors.learningBorder,
              size: 18,
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

            // Greeting bubble — bright speech bubble
            _BrightSpeechBubble(
              character: character,
              message: CharacterMessages.getGreeting(character),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 32),

            // Session title
            Text(
              sessionState.sessionTitle,
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.learningTextPrimary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 8),

            Text(
              '${sessionState.questions.length} soal menanti!',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.learningTextSecondary,
              ),
            ).animate().fadeIn(delay: 700.ms),

            const SizedBox(height: 40),

            // Start button — brand purple style
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.learningCheckBtn,
                  elevation: 4,
                  shadowColor: AppColors.learningCheckBtn.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'AYO MULAI!',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
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
  final Function(String) onSelectAnswer;
  final VoidCallback onCheckAnswer;
  final Function(String) onTextAnswer;
  final Function(List<int>) onSequenceAnswer;
  final VoidCallback onShowHint;

  const _QuestionView({
    required this.sessionState,
    required this.onSelectAnswer,
    required this.onCheckAnswer,
    required this.onTextAnswer,
    required this.onSequenceAnswer,
    required this.onShowHint,
  });

  @override
  Widget build(BuildContext context) {
    final question = sessionState.currentQuestion;
    if (question == null) {
      return Center(
        child: Text(
          'Tidak ada soal',
          style: GoogleFonts.nunito(
            fontSize: 18,
            color: AppColors.learningTextSecondary,
          ),
        ),
      );
    }

    final character = question.effectiveCharacter;

    return Column(
      children: [
        // Top bar with KOMBO progress & lives
        _BrightTopBar(sessionState: sessionState),

        const SizedBox(height: 12),

        // Instruction line
        if (question.instruction != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              question.instruction!,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.learningTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        const SizedBox(height: 12),

        // Character + Speech bubble (question text)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _QuestionSpeechBubble(
            character: character,
            question: question,
            showHint: sessionState.showHint,
          ),
        ),

        const SizedBox(height: 12),

        // Question content area (renderers)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
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

                // Question renderer — delegates to type-specific widget
                QuestionRenderer(
                  question: question,
                  selectedAnswerId: sessionState.selectedAnswerId,
                  onAnswer: onSelectAnswer,
                  onTextAnswer: onTextAnswer,
                  onSequenceAnswer: onSequenceAnswer,
                ),

                const SizedBox(height: 12),

                // Hint button (if hint available and not yet shown)
                if (question.hint != null && !sessionState.showHint)
                  TextButton.icon(
                    onPressed: onShowHint,
                    icon: const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.learningCombo,
                      size: 20,
                    ),
                    label: Text(
                      'Butuh petunjuk?',
                      style: GoogleFonts.nunito(
                        color: AppColors.learningCombo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Bottom action button — PERIKSA
        _BottomActionButton(
          hasSelection: sessionState.hasSelectedAnswer,
          onCheck: onCheckAnswer,
          questionType: question.questionType,
        ),
      ],
    );
  }
}

/// Character + speech bubble for question text — bright iOS style
class _QuestionSpeechBubble extends StatelessWidget {
  final CharacterType character;
  final Question question;
  final bool showHint;

  const _QuestionSpeechBubble({
    required this.character,
    required this.question,
    this.showHint = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = showHint && question.hint != null
        ? question.hint!
        : question.questionText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Character on the left
        CharacterIllustration(character: character, size: 56),

        const SizedBox(width: 10),

        // Speech bubble on the right — bright white with shadow
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.learningBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              displayText,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.learningTextPrimary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom action button — PERIKSA (check) when answer selected, disabled otherwise
class _BottomActionButton extends StatelessWidget {
  final bool hasSelection;
  final VoidCallback onCheck;
  final QuestionType questionType;

  const _BottomActionButton({
    required this.hasSelection,
    required this.onCheck,
    required this.questionType,
  });

  /// Some question types don't use the PERIKSA button (they auto-submit)
  bool get usesCheckButton =>
      questionType == QuestionType.multipleChoice ||
      questionType == QuestionType.trueFalse ||
      questionType == QuestionType.matchWordImage ||
      questionType == QuestionType.pickCorrectImage ||
      questionType == QuestionType.listenAndChoose ||
      questionType == QuestionType.pickInitialLetter ||
      questionType == QuestionType.dragAndDrop;

  @override
  Widget build(BuildContext context) {
    if (!usesCheckButton) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: hasSelection ? onCheck : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasSelection
                ? AppColors.learningCheckBtn
                : AppColors.learningCheckBtnDisabled,
            disabledBackgroundColor: AppColors.learningCheckBtnDisabled,
            elevation: hasSelection ? 4 : 0,
            shadowColor: hasSelection
                ? AppColors.learningCheckBtn.withOpacity(0.3)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'PERIKSA',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: hasSelection ? Colors.white : AppColors.learningTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FEEDBACK VIEW — Bright iOS-style bottom bar
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
    final feedbackMsg = sessionState.feedbackMessage ?? (isCorrect ? 'Benar!' : 'Coba lagi!');

    final barBgColor = isCorrect
        ? AppColors.learningFeedbackBg
        : AppColors.learningFeedbackWrongBg;
    final accentColor = isCorrect ? AppColors.learningCorrect : AppColors.learningWrong;

    return Column(
      children: [
        // Top bar
        _BrightTopBar(sessionState: sessionState),

        // Main area stays the same (question still visible)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (question != null)
                  QuestionRenderer(
                    question: question,
                    selectedAnswerId: sessionState.selectedAnswerId,
                    isAnswered: true,
                    isCorrect: isCorrect,
                    onAnswer: (_) {},
                    onTextAnswer: (_) {},
                    onSequenceAnswer: (_) {},
                  ),
              ],
            ),
          ),
        ),

        // Feedback bar at bottom — bright iOS style
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: BoxDecoration(
            color: barBgColor,
            border: Border(
              top: BorderSide(
                color: accentColor.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feedback title line
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isCorrect ? _getPraiseText() : 'Belum tepat!',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ],
              ),

              // Feedback message
              const SizedBox(height: 4),
              Text(
                feedbackMsg,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.learningTextSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // LANJUTKAN button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.learningCheckBtn,
                    elevation: 3,
                    shadowColor: AppColors.learningCheckBtn.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'LANJUTKAN',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPraiseText() {
    final praises = ['Hebat!', 'Keren!', 'Luar biasa!', 'Mantap!', 'Bagus sekali!'];
    final now = DateTime.now().millisecondsSinceEpoch;
    return praises[now % praises.length];
  }
}

// ============================================================
// COMBO CELEBRATION VIEW — Milestone streak celebration
// ============================================================

class _ComboCelebrationView extends StatelessWidget {
  final LearningSessionState sessionState;
  final VoidCallback onContinue;

  const _ComboCelebrationView({
    required this.sessionState,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final character = sessionState.questions.isNotEmpty
        ? sessionState.questions.first.effectiveCharacter
        : CharacterType.zelby;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

            // Combo title
            Text(
              'Kamu menciptakan kombo!',
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.learningCheckBtn,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 8),

            Text(
              '${sessionState.comboCount} jawaban benar berturut-turut! Lanjut!',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.learningTextSecondary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 32),

            // Stats cards row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ComboStatCard(
                  title: 'TOTAL XP',
                  value: '${sessionState.totalXpEarned}',
                  icon: Icons.bolt_rounded,
                  color: AppColors.learningCombo,
                ),
                _ComboStatCard(
                  title: 'KOMBO',
                  value: 'x${sessionState.comboCount}',
                  icon: Icons.track_changes_rounded,
                  color: AppColors.learningCheckBtn,
                ),
                _ComboStatCard(
                  title: 'CEPAT',
                  value: _formatDuration(sessionState.elapsed),
                  icon: Icons.timer_rounded,
                  color: AppColors.teal,
                ),
              ],
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 40),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.learningCheckBtn,
                  elevation: 4,
                  shadowColor: AppColors.learningCheckBtn.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Klaim XP',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 700.ms),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _ComboStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ComboStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.learningTextSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.learningTextPrimary,
            ),
          ),
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
              AppColors.learningCorrect,
              AppColors.learningCheckBtn,
              AppColors.learningCombo,
              AppColors.coinGold,
              AppColors.pink,
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
                      ? (sessionState.isPerfect ? 'Sempurna!' : 'Bagus Sekali!')
                      : 'Jangan Menyerah!',
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: isSuccessful ? AppColors.learningCorrect : AppColors.learningCombo,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  isSuccessful
                      ? 'Kamu sudah menyelesaikan ${sessionState.correctCount} dari ${sessionState.totalQuestions} soal!'
                      : 'Coba lagi, kamu pasti bisa!',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.learningTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 32),

                // Stars earned
                _BrightStarsDisplay(stars: sessionState.starsEarned)
                    .animate()
                    .fadeIn(delay: 600.ms),

                const SizedBox(height: 32),

                // Stats cards row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ComboStatCard(
                      title: 'BENAR',
                      value: '${sessionState.correctCount}',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.learningCorrect,
                    ),
                    _ComboStatCard(
                      title: 'KOMBO',
                      value: 'x${sessionState.maxCombo}',
                      icon: Icons.track_changes_rounded,
                      color: AppColors.learningCheckBtn,
                    ),
                    _ComboStatCard(
                      title: 'XP',
                      value: '${sessionState.totalXpEarned}',
                      icon: Icons.bolt_rounded,
                      color: AppColors.learningCombo,
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Rewards row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.learningBorder, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BrightRewardItem(
                        icon: Icons.monetization_on_rounded,
                        value: '+${sessionState.totalCoinsEarned}',
                        label: 'Koin',
                        color: AppColors.coinGold,
                      ),
                      _BrightRewardItem(
                        icon: Icons.star_rounded,
                        value: '+${sessionState.totalXpEarned}',
                        label: 'XP',
                        color: AppColors.learningCombo,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 32),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.learningCheckBtn,
                      elevation: 4,
                      shadowColor: AppColors.learningCheckBtn.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppStrings.playAgain,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: onGoHome,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.learningBorder, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Ke Beranda',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.learningTextSecondary,
                      ),
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

// ============================================================
// SHARED BRIGHT COMPONENTS
// ============================================================

/// Bright speech bubble component
class _BrightSpeechBubble extends StatelessWidget {
  final CharacterType character;
  final String message;

  const _BrightSpeechBubble({
    required this.character,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(character.colorValue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Character name badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              character.displayName,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.learningTextPrimary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stars display — bright theme
class _BrightStarsDisplay extends StatelessWidget {
  final int stars;

  const _BrightStarsDisplay({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isFilled = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isFilled ? AppColors.coinGold : AppColors.learningBorder,
            size: 48,
          ),
        );
      }),
    );
  }
}

/// Reward item — bright theme
class _BrightRewardItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _BrightRewardItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.learningTextPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.learningTextSecondary,
          ),
        ),
      ],
    );
  }
}
