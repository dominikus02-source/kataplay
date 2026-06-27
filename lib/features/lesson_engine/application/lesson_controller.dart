import 'dart:math';
import 'lesson_state.dart';
import '../domain/lesson_step.dart';
import '../domain/lesson_type.dart';
import '../domain/lesson_result.dart';
import '../data/lesson_repository.dart';
import '../../curriculum/data/curriculum_repository.dart';

class LessonController {
  final LessonRepository _repository;
  LessonState _state = const LessonState();
  final List<LessonControllerListener> _listeners = [];
  final Random _rng = Random();

  LessonController({LessonRepository? repository})
      : _repository = repository ?? LessonRepository();

  LessonState get state => _state;

  void addListener(LessonControllerListener listener) {
    _listeners.add(listener);
  }

  void removeListener(LessonControllerListener listener) {
    _listeners.remove(listener);
  }

  void _notify() {
    for (final listener in _listeners) {
      listener.onLessonStateChanged(_state);
    }
  }

  Future<void> loadLessonById(
    String lessonId,
    CurriculumRepository curriculumRepo,
  ) async {
    _updateState(_state.copyWith(status: LessonStatus.loading));
    try {
      final lesson = await curriculumRepo.findLessonById(lessonId);
      final assetPath = lesson?.assetPath;
      List<LessonStep> steps;
      if (assetPath != null && assetPath.isNotEmpty) {
        steps = await _repository.loadCustomPack(assetPath);
      } else {
        steps = await _repository.loadSampleLessonPack();
      }
      if (steps.isEmpty) {
        steps = _buildFallbackSteps();
      }
      _updateState(_state.copyWith(
        steps: steps,
        totalSteps: steps.length,
        currentStepIndex: 0,
        status: LessonStatus.ready,
        selectedAnswers: [],
        score: 0,
        stepResults: [],
        heartsRemaining: 5,
        xpEarnedSoFar: 0,
        isCorrect: false,
        feedbackMessage: null,
      ));
    } catch (e) {
      final fallback = _buildFallbackSteps();
      _updateState(_state.copyWith(
        steps: fallback,
        totalSteps: fallback.length,
        currentStepIndex: 0,
        status: LessonStatus.ready,
        errorMessage: null,
      ));
    }
  }

  Future<void> loadLessonPack({String? assetPath}) async {
    _updateState(_state.copyWith(status: LessonStatus.loading));

    try {
      List<LessonStep> steps;
      if (assetPath != null) {
        steps = await _repository.loadCustomPack(assetPath);
      } else {
        steps = await _repository.loadSampleLessonPack();
      }

      if (steps.isEmpty) {
        steps = _buildFallbackSteps();
      }

      _updateState(_state.copyWith(
        steps: steps,
        totalSteps: steps.length,
        currentStepIndex: 0,
        status: LessonStatus.ready,
        selectedAnswers: [],
        score: 0,
        stepResults: [],
        heartsRemaining: 5,
        xpEarnedSoFar: 0,
        isCorrect: false,
        feedbackMessage: null,
      ));
    } catch (e) {
      final fallback = _buildFallbackSteps();
      _updateState(_state.copyWith(
        steps: fallback,
        totalSteps: fallback.length,
        currentStepIndex: 0,
        status: LessonStatus.ready,
        errorMessage: null,
      ));
    }
  }

  List<LessonStep> _buildFallbackSteps() {
    return [
      const LessonStep(
        id: 'fb_1',
        type: LessonType.wordChoice,
        prompt: 'Huruf apa ini?',
        instruction: 'Pilih huruf yang benar',
        choices: ['E', 'U', 'A', 'I'],
        correctAnswer: ['A'],
        hint: 'A seperti ayam',
        difficulty: 1,
        xpReward: 10,
      ),
      const LessonStep(
        id: 'fb_2',
        type: LessonType.wordChoice,
        prompt: 'Pilih huruf yang tepat!',
        instruction: 'Cari huruf yang sesuai',
        choices: ['B', 'D', 'P', 'T'],
        correctAnswer: ['B'],
        hint: 'B seperti bola',
        difficulty: 1,
        xpReward: 10,
      ),
      const LessonStep(
        id: 'fb_3',
        type: LessonType.wordChoice,
        prompt: 'Huruf apa ini?',
        instruction: 'Pilih jawaban yang benar',
        choices: ['C', 'K', 'S', 'R'],
        correctAnswer: ['C'],
        hint: 'C seperti cacing',
        difficulty: 1,
        xpReward: 10,
      ),
      const LessonStep(
        id: 'fb_4',
        type: LessonType.pictureChoice,
        prompt: 'Pilih kata yang tepat!',
        instruction: 'Cocokkan dengan gambar',
        choices: ['apel', 'bola', 'cicak', 'domba'],
        correctAnswer: ['apel'],
        hint: 'A untuk apel',
        difficulty: 1,
        xpReward: 10,
      ),
      const LessonStep(
        id: 'fb_5',
        type: LessonType.wordChoice,
        prompt: 'Pilih huruf yang benar!',
        instruction: 'Cari huruf berikut',
        choices: ['M', 'N', 'W', 'V'],
        correctAnswer: ['M'],
        hint: 'M seperti mata',
        difficulty: 1,
        xpReward: 10,
      ),
    ];
  }

  void startLesson() {
    _updateState(_state.copyWith(status: LessonStatus.playing));
  }

  void selectAnswer(String answer) {
    if (_state.status != LessonStatus.playing) return;
    final current = _state.selectedAnswers;
    if (current.contains(answer)) {
      _updateState(_state.copyWith(
        selectedAnswers: current.where((a) => a != answer).toList(),
      ));
    } else {
      _updateState(_state.copyWith(
        selectedAnswers: [...current, answer],
      ));
    }
  }

  void selectSingleAnswer(String answer) {
    if (_state.status != LessonStatus.playing) return;
    _updateState(_state.copyWith(selectedAnswers: [answer]));
  }

  void clearSelection() {
    _updateState(_state.copyWith(selectedAnswers: []));
  }

  void checkAnswer() {
    final step = _state.currentStep;
    if (step == null || _state.status != LessonStatus.playing) return;

    final isCorrect = _checkStepCorrect(step, _state.selectedAnswers);

    _updateState(_state.copyWith(
      status: LessonStatus.feedback,
      isCorrect: isCorrect,
      feedbackMessage: isCorrect ? _randomCorrectMessage() : _randomWrongMessage(),
    ));
  }

  bool _checkStepCorrect(LessonStep step, List<String> answers) {
    if (step.hasMatchPairs) {
      return step.isValidAnswer(answers);
    }
    if (step.type.name == 'wordOrder') {
      return step.isValidAnswer(answers);
    }
    if (answers.length == 1) {
      return step.isCorrectAnswer(answers.first);
    }
    return step.isValidAnswer(answers);
  }

  void nextStep() {
    if (!_state.hasNext) {
      _completeLesson();
      return;
    }

    final stepResult = StepResult(
      step: _state.currentStep!,
      selectedAnswers: _state.selectedAnswers,
      isCorrect: _state.isCorrect,
      xpEarned: _state.isCorrect ? _state.currentStep!.xpReward : 0,
    );

    _updateState(_state.copyWith(
      currentStepIndex: _state.currentStepIndex + 1,
      status: LessonStatus.playing,
      selectedAnswers: [],
      isCorrect: false,
      feedbackMessage: null,
      score: _state.isCorrect ? _state.score + 1 : _state.score,
      stepResults: [..._state.stepResults, stepResult],
      xpEarnedSoFar: _state.xpEarnedSoFar +
          (_state.isCorrect ? _state.currentStep!.xpReward : 0),
    ));
  }

  void _completeLesson() {
    final finalStepResult = StepResult(
      step: _state.currentStep!,
      selectedAnswers: _state.selectedAnswers,
      isCorrect: _state.isCorrect,
      xpEarned: _state.isCorrect ? _state.currentStep!.xpReward : 0,
    );

    final allResults = [..._state.stepResults, finalStepResult];
    final finalScore = _state.isCorrect ? _state.score + 1 : _state.score;
    final finalXp = _state.xpEarnedSoFar +
        (_state.isCorrect ? _state.currentStep!.xpReward : 0);

    _updateState(_state.copyWith(
      status: LessonStatus.completed,
      score: finalScore,
      stepResults: allResults,
      xpEarnedSoFar: finalXp,
    ));
  }

  void reset() {
    _updateState(_state.copyWith(
      currentStepIndex: 0,
      status: LessonStatus.ready,
      selectedAnswers: [],
      isCorrect: false,
      score: 0,
      stepResults: [],
      feedbackMessage: null,
      heartsRemaining: 5,
      xpEarnedSoFar: 0,
    ));
  }

  void retry() {
    if (_state.status != LessonStatus.feedback) return;
    _updateState(_state.copyWith(
      status: LessonStatus.playing,
      selectedAnswers: [],
      feedbackMessage: null,
      isCorrect: false,
    ));
  }

  void loseHeart() {
    if (_state.heartsRemaining <= 1) {
      _updateState(_state.copyWith(
        heartsRemaining: 0,
        status: LessonStatus.completed,
      ));
      return;
    }
    _updateState(_state.copyWith(
      heartsRemaining: _state.heartsRemaining - 1,
    ));
  }

  void _updateState(LessonState newState) {
    _state = newState;
    _notify();
  }

  String _randomCorrectMessage() {
    const messages = ['Hebat!', 'Benar!', 'Pintar!', 'Mantap!', 'Keren!'];
    return messages[_rng.nextInt(messages.length)];
  }

  String _randomWrongMessage() {
    const messages = [
      'Coba lagi ya!',
      'Hampir!',
      'Ayo coba lagi!',
      'Kamu pasti bisa!',
    ];
    return messages[_rng.nextInt(messages.length)];
  }
}

abstract class LessonControllerListener {
  void onLessonStateChanged(LessonState state);
}
