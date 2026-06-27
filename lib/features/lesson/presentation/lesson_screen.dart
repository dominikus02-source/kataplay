import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../utils/constants.dart';
import '../../../core/providers/providers.dart';
import '../domain/lesson.dart';
import '../data/level_content.dart';
import '../domain/brain_types.dart';
import '../domain/kataplay_brain.dart';
import 'widgets/lesson_scaffold.dart';
import 'widgets/character_prompt.dart';
import 'widgets/arrange_words_question.dart';
import 'widgets/segmented_progress_bar.dart';
import 'widgets/answer_option_card.dart';
import 'widgets/streak_indicator.dart';
import 'widgets/question_transition_wrapper.dart';
import 'widgets/shimmer_loading.dart';
import 'widgets/shake_wrapper.dart';
import '../../lesson_engine/domain/lesson_step.dart' as engine;
import '../../lesson_engine/domain/lesson_type.dart' as engine;
import '../../lesson_engine/application/lesson_state.dart' as engine;
import '../../lesson_engine/presentation/renderers/listen_choose_renderer.dart';
import '../../lesson_engine/presentation/renderers/missing_word_renderer.dart';
import '../../lesson_engine/presentation/renderers/sentence_choice_renderer.dart';
import '../../lesson_engine/presentation/renderers/story_reading_renderer.dart';
import '../../lesson_engine/presentation/renderers/story_comprehension_renderer.dart';
import '../../lesson_engine/presentation/renderers/record_voice_renderer.dart';
import '../../lesson_engine/presentation/renderers/speaking_practice_renderer.dart';
import '../../lesson_engine/presentation/renderers/picture_choice_renderer.dart';
import '../../lesson_engine/presentation/renderers/word_order_renderer.dart';
import '../../lesson_engine/presentation/renderers/match_pair_renderer.dart';
import '../../lesson_engine/presentation/renderers/reading_comprehension_renderer.dart';
import '../../lesson_engine/presentation/renderers/true_false_renderer.dart';
import '../../lesson_engine/presentation/renderers/fill_blank_renderer.dart';
import '../../lesson_engine/presentation/renderers/word_choice_renderer.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen>
    with SingleTickerProviderStateMixin {
  final KataPlayBrain _brain = const KataPlayBrain();
  List<LessonQuestion> _questions = [];
  List<BrainQuestionPayload> _brainQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _showFeedback = false;
  bool _isCorrect = false;
  String _character = 'zelby';
  String? _lessonId;
  String _focusLabel = 'Mode Adaptif';
  int _sessionAdaptiveSeed = 0;
  String? _revealedHint;
  String? _feedbackMessageOverride;
  String? _feedbackSubtitleOverride;
  String _feedbackMood = 'happy';
  int _questionAttempts = 0;
  late AnimationController _feedbackController;
  final GlobalKey<ArrangeWordsQuestionState> _arrangeKey = GlobalKey();
  bool _arrangeReady = false;

  int _streak = 0;
  bool _showStreak = false;
  int _currentQuestionKey = 0;
  int _feedbackShakeKey = 0;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: AppDimensions.durationSlow,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_questions.isEmpty) {
      final args =
          GoRouterState.of(context).extra as Map<String, dynamic>?;
      final levelIndex = args?['levelIndex'] as int? ?? 0;

      final levels = LevelContent.allLevels;
      if (levelIndex < levels.length) {
        final level = levels[levelIndex];
        final lessonIndex =
            level.lessons.indexWhere((l) => !_isLessonCompleted(l.id));
        final targetIndex = lessonIndex >= 0 ? lessonIndex : 0;
        final lesson = level.lessons[targetIndex];
        final session = _brain.buildSession(
          level: level,
          lesson: lesson,
          progress: ref.read(progressProvider).progress,
        );
        _brainQuestions = List.from(session.questions);
        _questions = _brainQuestions.map((q) => q.source).toList();
        _lessonId = lesson.id;
        _character = lesson.character;
        _focusLabel = session.focusLabel;
        _sessionAdaptiveSeed = session.adaptiveSeed;
      }
    }
  }

  bool get _isLastQuestion => _currentIndex >= _questions.length - 1;
  bool get _isArrangeType => _questions.isNotEmpty && _questions[_currentIndex].type == LessonType.arrangeWord;
  bool get _isNonChoiceType {
    if (_questions.isEmpty) return false;
    final t = _questions[_currentIndex].type;
    return t == LessonType.storyReading ||
        t == LessonType.recordVoice ||
        t == LessonType.speakingPractice;
  }
  BrainQuestionPayload get _activeBrainQuestion => _brainQuestions[_currentIndex];

  bool _isLessonCompleted(String id) {
    return ref.read(progressProvider).isLessonCompleted(id);
  }

  bool _isEngineType(LessonType type) {
    switch (type) {
      case LessonType.imageChoice:
      case LessonType.wordChoice:
      case LessonType.trueFalse:
      case LessonType.arrangeWord:
      case LessonType.fillBlank:
      case LessonType.matching:
      case LessonType.readSentence:
        return false;
      default:
        return true;
    }
  }

  engine.LessonType _mapToEngineType(LessonType type) {
    switch (type) {
      case LessonType.pictureChoice: return engine.LessonType.pictureChoice;
      case LessonType.wordChoice: return engine.LessonType.wordChoice;
      case LessonType.listenChoose: return engine.LessonType.listenChoose;
      case LessonType.wordOrder: return engine.LessonType.wordOrder;
      case LessonType.missingWord: return engine.LessonType.missingWord;
      case LessonType.sentenceChoice: return engine.LessonType.sentenceChoice;
      case LessonType.matchPair: return engine.LessonType.matchPair;
      case LessonType.storyReading: return engine.LessonType.storyReading;
      case LessonType.storyComprehension: return engine.LessonType.storyComprehension;
      case LessonType.readingComprehension: return engine.LessonType.readingComprehension;
      case LessonType.recordVoice: return engine.LessonType.recordVoice;
      case LessonType.speakingPractice: return engine.LessonType.speakingPractice;
      case LessonType.trueFalse: return engine.LessonType.trueFalse;
      case LessonType.fillBlank: return engine.LessonType.fillBlank;
      default: return engine.LessonType.wordChoice;
    }
  }

  engine.LessonStep _toEngineStep(LessonQuestion question) {
    final brainQ = _activeBrainQuestion;
    return engine.LessonStep(
      id: 'q_$_currentIndex',
      type: _mapToEngineType(question.type),
      prompt: brainQ.prompt,
      instruction: question.instruction,
      choices: brainQ.options,
      correctAnswer: [question.correctAnswer],
      imageAsset: question.imageAsset,
      hint: question.hint,
      matchPairs: question.matchLeft != null && question.matchRight != null
          ? {question.matchLeft!: question.matchRight!}
          : null,
      xpReward: 10,
    );
  }

  engine.LessonState _buildEngineState({bool showFeedback = false}) {
    return engine.LessonState(
      status: showFeedback ? engine.LessonStatus.feedback : engine.LessonStatus.playing,
      selectedAnswers: _selectedAnswer != null
          ? [_activeBrainQuestion.options[_selectedAnswer!]]
          : [],
      isCorrect: _isCorrect,
      currentStepIndex: _currentIndex,
      totalSteps: _questions.length,
    );
  }

  void _selectAnswer(int index) {
    if (_showFeedback || _questions.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedAnswer = index);
  }

  void _checkAnswer() {
    if (_questions.isEmpty) return;

    if (_isArrangeType) {
      final state = _arrangeKey.currentState;
      if (state == null || !state.isReady) return;
      state.check();
      final isCorrect = state.isCorrect ?? false;
      final attempts = isCorrect ? _questionAttempts : _questionAttempts + 1;
      final feedback = _brain.evaluate(
        session: BrainLessonSession(
          lessonId: _lessonId ?? '',
          title: '',
          character: _character,
          openingLine: '',
          focusLabel: _focusLabel,
          adaptiveSeed: _sessionAdaptiveSeed,
          questions: _brainQuestions,
        ),
        questionIndex: _currentIndex,
        isCorrect: isCorrect,
        attempts: attempts,
      );
      setState(() {
        _showFeedback = true;
        _feedbackShakeKey++;
        _isCorrect = isCorrect;
        _questionAttempts = attempts;
        _feedbackMessageOverride = feedback.message;
        _feedbackSubtitleOverride = feedback.subtitle;
        _feedbackMood = feedback.mood;
        _revealedHint = feedback.revealedHint ?? _revealedHint;
        _updateStreak(isCorrect);
      });
      _feedbackController.forward(from: 0);
      if (isCorrect) {
        _onCorrectSound();
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.mediumImpact();
      }
      return;
    }

    if (_isNonChoiceType) {
      final attempts = _questionAttempts + 1;
      final feedback = _brain.evaluate(
        session: BrainLessonSession(
          lessonId: _lessonId ?? '',
          title: '',
          character: _character,
          openingLine: '',
          focusLabel: _focusLabel,
          adaptiveSeed: _sessionAdaptiveSeed,
          questions: _brainQuestions,
        ),
        questionIndex: _currentIndex,
        isCorrect: true,
        attempts: attempts,
      );
      setState(() {
        _showFeedback = true;
        _feedbackShakeKey++;
        _isCorrect = true;
        _score++;
        _questionAttempts = attempts;
        _feedbackMessageOverride = feedback.message;
        _feedbackSubtitleOverride = feedback.subtitle;
        _feedbackMood = feedback.mood;
        _updateStreak(true);
      });
      _feedbackController.forward(from: 0);
      _onCorrectSound();
      HapticFeedback.lightImpact();
      return;
    }

    if (_selectedAnswer == null) return;

    final isCorrect = _questions[_currentIndex].correctAnswer ==
        _activeBrainQuestion.options[_selectedAnswer!];
    final attempts = isCorrect ? _questionAttempts : _questionAttempts + 1;
    final feedback = _brain.evaluate(
      session: BrainLessonSession(
        lessonId: _lessonId ?? '',
        title: '',
        character: _character,
        openingLine: '',
        focusLabel: _focusLabel,
        adaptiveSeed: _sessionAdaptiveSeed,
        questions: _brainQuestions,
      ),
      questionIndex: _currentIndex,
      isCorrect: isCorrect,
      attempts: attempts,
    );
    setState(() {
      _showFeedback = true;
      _feedbackShakeKey++;
      _isCorrect = isCorrect;
      if (isCorrect) _score++;
      _questionAttempts = attempts;
      _feedbackMessageOverride = feedback.message;
      _feedbackSubtitleOverride = feedback.subtitle;
      _feedbackMood = feedback.mood;
      _revealedHint = feedback.revealedHint ?? _revealedHint;
      _updateStreak(isCorrect);
    });
    _feedbackController.forward(from: 0);
    if (isCorrect) {
      _onCorrectSound();
      HapticFeedback.lightImpact();
    } else {
      _onWrongSound();
      HapticFeedback.mediumImpact();
    }
  }

  void _updateStreak(bool isCorrect) {
    if (isCorrect) {
      _streak++;
      if (_streak >= 3) {
        setState(() => _showStreak = true);
      }
    } else {
      setState(() => _streak = 0);
    }
  }

  void _onCorrectSound() {}
  void _onWrongSound() {}

  void _nextQuestion() {
    _feedbackController.reset();
    setState(() {
      _selectedAnswer = null;
      _showFeedback = false;
      _isCorrect = false;
      _arrangeReady = false;
      _questionAttempts = 0;
      _revealedHint = null;
      _feedbackMessageOverride = null;
      _feedbackSubtitleOverride = null;
      _feedbackMood = 'happy';
      _currentQuestionKey++;
    });
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _finishLesson();
    }
  }

  void _retryQuestion() {
    if (_isArrangeType) {
      _arrangeKey.currentState?.reset();
    }
    _feedbackController.reset();
    setState(() {
      _selectedAnswer = null;
      _showFeedback = false;
      _isCorrect = false;
      _arrangeReady = false;
      _feedbackMessageOverride = null;
      _feedbackSubtitleOverride = null;
      _feedbackMood = 'thinking';
      _currentQuestionKey++;
    });
  }

  void _finishLesson() {
    final xpEarned =
        _score * AppConstants.xpPerQuestion + AppConstants.xpPerLesson;
    if (_lessonId != null) {
      ref.read(progressProvider.notifier).completeLesson(_lessonId!, xpEarned);
    }

    context.go('/result', extra: {
      'score': _score,
      'total': _questions.length,
      'xpEarned': xpEarned,
      'character': _character,
    });
  }

  String _getCharacterMood() {
    if (!_showFeedback) {
      if (_questions.isNotEmpty &&
          _questions[_currentIndex].type == LessonType.readSentence) {
        return _character == 'hazel' ? 'reading' : 'idle';
      }
      if (_revealedHint != null) {
        return _character == 'hazel' ? 'thinking' : 'thinking';
      }
      return 'idle';
    }
    return _feedbackMood;
  }

  String _getInstructionText() {
    if (_questions.isEmpty) return '';
    final q = _questions[_currentIndex];
    if (_activeBrainQuestion.prompt.isNotEmpty) return _activeBrainQuestion.prompt;
    if (q.instruction.isNotEmpty) return q.instruction;
    switch (q.type) {
      case LessonType.imageChoice: return 'Pilih yang tepat!';
      case LessonType.pictureChoice: return 'Pilih gambar yang tepat!';
      case LessonType.wordChoice: return 'Pilih kata yang benar!';
      case LessonType.trueFalse: return 'Benar atau salah?';
      case LessonType.arrangeWord: return 'Susun kata!';
      case LessonType.wordOrder: return 'Urutkan kata!';
      case LessonType.fillBlank: return 'Lengkapi huruf!';
      case LessonType.matching: return 'Cocokkan!';
      case LessonType.matchPair: return 'Pasangkan!';
      case LessonType.readSentence: return 'Baca baik-baik!';
      case LessonType.readingComprehension: return 'Baca dan jawab!';
      case LessonType.listenChoose: return 'Dengar dan pilih!';
      case LessonType.missingWord: return 'Isi huruf yang hilang!';
      case LessonType.sentenceChoice: return 'Pilih kalimat yang tepat!';
      case LessonType.storyReading: return 'Baca ceritanya!';
      case LessonType.storyComprehension: return 'Jawab tentang cerita!';
      case LessonType.recordVoice: return 'Rekam suaramu!';
      case LessonType.speakingPractice: return 'Ucapkan dengan lantang!';
    }
  }

  String _getFeedbackMessage() {
    if (_feedbackMessageOverride != null) return _feedbackMessageOverride!;
    if (_isCorrect) {
      final messages = {
        'zelby': ['Hebat!', 'Keren!', 'Mantap!', 'Pintar!'],
        'hazel': ['Luar biasa!', 'Bagus!', 'Wah!', 'Jago!'],
        'alby': ['Yes!', 'Top!', 'Mantul!', 'Kereen!'],
      };
      final charMessages = messages[_character] ?? messages['zelby']!;
      return charMessages[_currentIndex % charMessages.length];
    }
    final messages = {
      'zelby': ['Coba lagi, ya!', 'Hampir!', 'Kamu bisa!'],
      'hazel': ['Ayo coba lagi!', 'Semangat!'],
      'alby': ['Yuk ulang!', 'Sekali lagi!'],
    };
    final charMessages = messages[_character] ?? messages['zelby']!;
    return charMessages[_currentIndex % charMessages.length];
  }

  String _getBottomLabel() {
    if (!_showFeedback) return 'Periksa';
    if (_isCorrect) return _isLastQuestion ? 'Selesai!' : 'Lanjut';
    return 'Coba Lagi';
  }

  bool _getBottomDisabled() {
    if (_showFeedback) return false;
    if (_isArrangeType) return !_arrangeReady;
    return _selectedAnswer == null;
  }

  bool _getBottomDanger() => _showFeedback && !_isCorrect;

  void _onBottomAction() {
    if (!_showFeedback) {
      _checkAnswer();
    } else if (_isCorrect) {
      _nextQuestion();
    } else {
      _retryQuestion();
    }
  }

  Color get _accentColor => AppColors.characterColor(_character);

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _CloseConfirmDialog(character: _character),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || _brainQuestions.isEmpty) {
      return _buildLoading();
    }

    final question = _questions[_currentIndex];

    return LessonScaffold(
      topBar: _buildTopBar(),
      body: _buildBody(context, question),
      bottomAction: _buildBottomAction(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _onWillPop().then((leave) {
                  if (leave) context.pop();
                }),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF6B7280),
                    size: 22,
                  ),
                ),
              ),
              Expanded(
                child: SegmentedProgressBar(
                  totalSegments: _questions.length,
                  currentIndex: _currentIndex,
                  completedCount: _showFeedback && _isCorrect
                      ? _currentIndex + 1
                      : _currentIndex,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _accentColor.withValues(alpha: 0.12),
                      _accentColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _accentColor.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          if (_showStreak && _streak >= 3)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 50),
              child: StreakIndicator(
                streak: _streak,
                visible: _showStreak,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, LessonQuestion question) {
    return LayoutBuilder(
      builder: (context, bodyConstraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: bodyConstraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              CharacterPrompt(
                character: _character,
                message: _getInstructionText(),
                mood: _getCharacterMood(),
              ),
              const SizedBox(height: 16),
              QuestionTransitionWrapper(
                index: _currentQuestionKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildQuestionCard(question),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: AppDimensions.appMaxWidth,
                child: Material(
                  type: MaterialType.transparency,
                  child: const LessonSkeleton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(LessonQuestion question) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.06),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showFeedback)
              ShakeWrapper(
              triggerCount: _feedbackShakeKey,
              isShake: !_isCorrect,
              child: _showFeedback
                  ? _buildFeedbackInside()
                  : const SizedBox.shrink(),
            )
            else ...[
              if (_revealedHint != null) ...[
                _buildSmartHintCard(),
                const SizedBox(height: 16),
              ],
              _buildQuestionDisplay(question),
              const SizedBox(height: 16),
              _buildAnswerArea(question),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackInside() {
    final isCorrect = _isCorrect;
    final feedbackColor = isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final feedbackIcon = isCorrect ? Icons.check_circle_rounded : Icons.refresh_rounded;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [feedbackColor, isCorrect ? const Color(0xFF34D399) : feedbackColor.withValues(alpha: 0.6)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: feedbackColor.withValues(alpha: 0.2),
                  blurRadius: 12, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(feedbackIcon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            _getFeedbackMessage(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: feedbackColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isCorrect ? 'Jawabanmu benar!' : 'Coba lagi, ya!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: feedbackColor.withValues(alpha: 0.7),
              height: 1.3,
            ),
          ),
          if (_feedbackSubtitleOverride != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: feedbackColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _feedbackSubtitleOverride!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: feedbackColor.withValues(alpha: 0.85),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmartHintCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFFF8E1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFD97706),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Petunjuk Pintar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD97706),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _revealedHint!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionDisplay(LessonQuestion question) {
    if (_isEngineType(question.type)) {
      return const SizedBox.shrink();
    }
    switch (question.type) {
      case LessonType.imageChoice:
        return _buildImageDisplay(question);
      case LessonType.wordChoice:
        return _buildWordDisplay(question);
      case LessonType.trueFalse:
        return _buildQuestionText(question);
      case LessonType.arrangeWord:
        return _buildArrangePrompt(question);
      case LessonType.fillBlank:
        return _buildFillBlankPrompt(question);
      case LessonType.matching:
        return _buildMatchingDisplay(question);
      case LessonType.readSentence:
        return _buildReadingDisplay(question);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildToyTile(String text, {double size = 80, Color? color}) {
    final tileColor = color ?? _accentColor;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tileColor.withValues(alpha: 0.08), tileColor.withValues(alpha: 0.02)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tileColor.withValues(alpha: 0.12),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: tileColor.withValues(alpha: 0.06),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: text.length <= 2
            ? Text(
                text,
                style: TextStyle(
                  fontSize: size > 60 ? 36 : 24,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F2937),
                  height: 1.1,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  text,
                  fit: BoxFit.contain,
                  errorBuilder: (_, e, s) => Text(
                    text.split('/').last.split('.').first,
                    style: TextStyle(
                      fontSize: size > 60 ? 36 : 24,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1F2937),
                      height: 1.1,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildAssetTile(String assetPath, {double size = 80, Color? color}) {
    final tileColor = color ?? _accentColor;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tileColor.withValues(alpha: 0.08), tileColor.withValues(alpha: 0.02)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tileColor.withValues(alpha: 0.12),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: tileColor.withValues(alpha: 0.06),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, e, s) => Center(
            child: Text(
              assetPath.split('/').last.split('.').first,
              style: TextStyle(
                fontSize: size > 60 ? 20 : 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1F2937),
                height: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(LessonQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          if (question.imageAsset != null)
            _buildAssetTile(question.imageAsset!, size: 100)
          else
            _buildToyTile(question.imageText ?? question.correctAnswer, size: 100),
          if (question.hint != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF58CC02).withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 13, color: const Color(0xFF58CC02)),
                  const SizedBox(width: 6),
                  Text(
                    question.hint!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF58CC02),
                      fontWeight: FontWeight.w600,
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

  Widget _buildWordDisplay(LessonQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          if (question.imageAsset != null)
            _buildAssetTile(question.imageAsset!, size: 100)
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF58CC02).withValues(alpha: 0.06)),
              ),
              child: Text(
                question.imageText ?? '',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                  height: 1.1,
                ),
              ),
            ),
          if (question.hint != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF58CC02).withValues(alpha: 0.1)),
              ),
              child: Text(
                question.hint!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF58CC02),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionText(LessonQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        question.hint ?? question.instruction,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F2937),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildArrangePrompt(LessonQuestion question) {
    if (question.wordParts == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF58CC02).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 16, color: const Color(0xFF58CC02)),
                const SizedBox(width: 6),
                Text(
                  'Tekan untuk menyusun',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF58CC02).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFillBlankPrompt(LessonQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF58CC02).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF58CC02).withValues(alpha: 0.06)),
            ),
            child: Text(
              question.instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
                height: 1.4,
              ),
              maxLines: 3, overflow: TextOverflow.ellipsis,
            ),
          ),
          if (question.hint != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.1)),
              ),
              child: Text(
                question.hint!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchingDisplay(LessonQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (question.matchLeft != null)
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accentColor.withValues(alpha: 0.08), _accentColor.withValues(alpha: 0.02)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _accentColor.withValues(alpha: 0.12), width: 1.5),
              ),
              child: Center(
                child: Text(
                  question.matchLeft!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _accentColor),
                ),
              ),
            ),
          if (question.matchLeft != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02).withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_rounded, color: const Color(0xFF58CC02), size: 16),
              ),
            ),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFF6B6B).withValues(alpha: 0.08), const Color(0xFFFF6B6B).withValues(alpha: 0.02)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFF6B6B).withValues(alpha: 0.12), width: 1.5),
            ),
            child: Center(
              child: Text(
                question.imageText ?? '?',
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingDisplay(LessonQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                _accentColor.withValues(alpha: 0.05),
                const Color(0xFFFFFFFF),
              ],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _accentColor.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: Icon(Icons.format_quote_rounded, size: 18, color: _accentColor.withValues(alpha: 0.5)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                question.sentence ?? question.instruction,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  height: 1.6,
                ),
                maxLines: 6, overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerArea(LessonQuestion question) {
    if (_isEngineType(question.type)) {
      return _buildEngineAnswerArea(question);
    }
    switch (question.type) {
      case LessonType.imageChoice:
      case LessonType.wordChoice:
        return _buildGameOptions(question);
      case LessonType.trueFalse:
        return _buildTrueFalseOptions(question);
      case LessonType.fillBlank:
        return _buildGameOptions(question);
      case LessonType.arrangeWord:
        return _buildArrangeWordArea(question);
      case LessonType.matching:
        return _buildGameOptions(question);
      case LessonType.readSentence:
        return _buildGameOptions(question);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEngineAnswerArea(LessonQuestion question) {
    final step = _toEngineStep(question);
    final state = _buildEngineState();
    final engineType = step.type;

    switch (engineType) {
      case engine.LessonType.wordChoice:
        return WordChoiceRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.pictureChoice:
        return PictureChoiceRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.trueFalse:
        return TrueFalseRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.fillBlank:
        return FillBlankRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.listenChoose:
        return ListenChooseRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.missingWord:
        return MissingWordRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.sentenceChoice:
        return SentenceChoiceRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.wordOrder:
        return WordOrderRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.matchPair:
        return MatchPairRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.storyReading:
        return StoryReadingRenderer(
          step: step, state: state,
          onContinue: _onEngineContinue,
        );
      case engine.LessonType.storyComprehension:
        return StoryComprehensionRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.readingComprehension:
        return ReadingComprehensionRenderer(
          step: step, state: state,
          onSelect: _onEngineSelect,
        );
      case engine.LessonType.recordVoice:
        return RecordVoiceRenderer(
          step: step, state: state,
          onRecord: _onEngineRecord,
        );
      case engine.LessonType.speakingPractice:
        return SpeakingPracticeRenderer(
          step: step, state: state,
          onRecord: _onEngineRecord,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _onEngineSelect(String answer) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedAnswer = _activeBrainQuestion.options.indexOf(answer);
      _showFeedback = false;
    });
  }

  void _onEngineContinue() {
    setState(() => _selectedAnswer = 0);
  }

  void _onEngineRecord() {
    setState(() => _selectedAnswer = 0);
  }

  Widget _buildGameOptions(LessonQuestion question) {
    final options = _activeBrainQuestion.options;
    if (options.isEmpty) return const SizedBox();

    bool isOptionCorrect(String text) => text == question.correctAnswer;

    return Column(
      children: List.generate(options.length, (index) {
        final text = options[index];
        final isSelected = _selectedAnswer == index;
        final showState = _showFeedback;
        final isOptCorrect = showState && isOptionCorrect(text);
        final isOptWrong = showState && isSelected && !isOptCorrect;

        AnswerState state;
        if (_showFeedback) {
          if (isOptCorrect) {
            state = AnswerState.correct;
          } else if (isOptWrong) {
            state = AnswerState.incorrect;
          } else {
            state = AnswerState.default_;
          }
        } else if (isSelected) {
          state = AnswerState.selected;
        } else {
          state = AnswerState.default_;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnswerOptionCard(
            text: text,
            index: index,
            state: state,
            onTap: _showFeedback ? null : () => _selectAnswer(index),
          ),
        );
      }),
    );
  }

  Widget _buildTrueFalseOptions(LessonQuestion question) {
    final options = _activeBrainQuestion.options;
    final benarText = options.isNotEmpty ? options[0] : 'Benar';
    final salahText = options.length > 1 ? options[1] : 'Salah';

    bool isOptionCorrect(String text) => text == question.correctAnswer;

    return Row(
      children: [
        Expanded(
          child: _buildAnswerCard(0, benarText, question, isOptionCorrect),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnswerCard(1, salahText, question, isOptionCorrect),
        ),
      ],
    );
  }

  Widget _buildAnswerCard(int index, String text, LessonQuestion question, bool Function(String) isCorrect) {
    final isSelected = _selectedAnswer == index;
    final showState = _showFeedback;
    final isOptCorrect = showState && isCorrect(text);
    final isOptWrong = showState && isSelected && !isOptCorrect;

    AnswerState state;
    if (_showFeedback) {
      if (isOptCorrect) {
        state = AnswerState.correct;
      } else if (isOptWrong) {
        state = AnswerState.incorrect;
      } else {
        state = AnswerState.default_;
      }
    } else if (isSelected) {
      state = AnswerState.selected;
    } else {
      state = AnswerState.default_;
    }

    return AnswerOptionCard(
      text: text,
      index: index,
      state: state,
      onTap: _showFeedback ? null : () => _selectAnswer(index),
    );
  }

  Widget _buildArrangeWordArea(LessonQuestion question) {
    if (question.wordParts == null || question.wordParts!.isEmpty) {
      return const SizedBox();
    }
    return ArrangeWordsQuestion(
      key: _arrangeKey,
      wordParts: question.wordParts!,
      correctAnswer: question.correctAnswer,
      accentColor: _accentColor,
      onReadyChanged: (ready) {
        if (mounted && _arrangeReady != ready) {
          setState(() => _arrangeReady = ready);
        }
      },
    );
  }

  Widget _buildBottomAction() {
    final label = _getBottomLabel();
    final disabled = _getBottomDisabled();
    final isDanger = _getBottomDanger();
    final showArrow = _showFeedback && _isCorrect && !_isLastQuestion;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: disabled
                ? const Color(0xFFD1D5DB)
                : isDanger
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF6366F1),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color: (isDanger
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF6366F1))
                          .withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: disabled ? null : _onBottomAction,
              borderRadius: BorderRadius.circular(100),
              splashColor: Colors.white.withValues(alpha: 0.15),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Row(
                    key: ValueKey('$label-$showArrow'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: disabled
                              ? const Color(0xFF9CA3AF)
                              : Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (showArrow) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseConfirmDialog extends StatelessWidget {
  final String character;

  const _CloseConfirmDialog({required this.character});

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.characterColor(character);

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeOutCubic,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOut,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.12),
                      accentColor.withValues(alpha: 0.04),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Yakin ingin keluar?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Progress soal ini tidak akan disimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6B7280),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
