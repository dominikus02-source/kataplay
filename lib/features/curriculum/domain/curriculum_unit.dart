import 'curriculum_lesson.dart';

class CurriculumUnit {
  final String id;
  final String stageId;
  final String title;
  final String subtitle;
  final int order;
  final List<CurriculumLesson> lessons;

  const CurriculumUnit({
    required this.id,
    required this.stageId,
    required this.title,
    this.subtitle = '',
    required this.order,
    this.lessons = const [],
  });

  int get lessonCount => lessons.length;
  int get totalXp => lessons.fold(0, (sum, l) => sum + l.xpReward);

  factory CurriculumUnit.fromJson(Map<String, dynamic> json,
      {required String stageId}) {
    final lessonsJson = json['lessons'] as List<dynamic>? ?? [];
    final unitId = json['id'] as String? ?? '';
    return CurriculumUnit(
      id: unitId,
      stageId: stageId,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      lessons: lessonsJson
          .map((l) => CurriculumLesson.fromJson(l as Map<String, dynamic>,
              unitId: unitId))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'order': order,
        'lessons': lessons.map((l) => l.toJson()).toList(),
      };
}
