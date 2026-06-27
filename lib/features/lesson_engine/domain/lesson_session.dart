import 'lesson_step.dart';
import 'lesson_world.dart';

class LessonSession {
  final String id;
  final String title;
  final String worldId;
  final LessonWorld? world;
  final List<LessonStep> steps;
  final int currentStepIndex;
  final bool isCompleted;

  const LessonSession({
    required this.id,
    this.title = '',
    this.worldId = 'hutan_kata',
    this.world,
    required this.steps,
    this.currentStepIndex = 0,
    this.isCompleted = false,
  });

  LessonStep? get currentStep {
    if (currentStepIndex < 0 || currentStepIndex >= steps.length) return null;
    return steps[currentStepIndex];
  }

  bool get hasNext => currentStepIndex < steps.length - 1;
  bool get hasPrevious => currentStepIndex > 0;
  int get totalSteps => steps.length;
  int get completedSteps => currentStepIndex;

  LessonSession copyWith({
    String? id,
    String? title,
    String? worldId,
    LessonWorld? world,
    List<LessonStep>? steps,
    int? currentStepIndex,
    bool? isCompleted,
  }) {
    return LessonSession(
      id: id ?? this.id,
      title: title ?? this.title,
      worldId: worldId ?? this.worldId,
      world: world ?? this.world,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
