class CurriculumLesson {
  final String id;
  final String unitId;
  final String title;
  final String subtitle;
  final int order;
  final int estimatedMinutes;
  final int xpReward;
  final int requiredCompletedLessons;
  final bool isReview;
  final String lessonType;
  final int questionCount;
  final String? assetPath;
  final String? characterHint;

  const CurriculumLesson({
    required this.id,
    required this.unitId,
    required this.title,
    this.subtitle = '',
    required this.order,
    this.estimatedMinutes = 5,
    this.xpReward = 50,
    this.requiredCompletedLessons = 0,
    this.isReview = false,
    this.lessonType = 'wordChoice',
    this.questionCount = 5,
    this.assetPath,
    this.characterHint,
  });

  factory CurriculumLesson.fromJson(Map<String, dynamic> json,
      {required String unitId}) {
    return CurriculumLesson(
      id: json['id'] as String? ?? '',
      unitId: unitId,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
      xpReward: json['xpReward'] as int? ?? 50,
      requiredCompletedLessons:
          json['requiredCompletedLessons'] as int? ?? 0,
      isReview: json['isReview'] as bool? ?? false,
      lessonType: json['lessonType'] as String? ?? 'wordChoice',
      questionCount: json['questionCount'] as int? ?? 5,
      assetPath: json['assetPath'] as String?,
      characterHint: json['characterHint'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'order': order,
        'estimatedMinutes': estimatedMinutes,
        'xpReward': xpReward,
        'requiredCompletedLessons': requiredCompletedLessons,
        'isReview': isReview,
        'lessonType': lessonType,
        'questionCount': questionCount,
        if (assetPath != null) 'assetPath': assetPath,
        if (characterHint != null) 'characterHint': characterHint,
      };
}
