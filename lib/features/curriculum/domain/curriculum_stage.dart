import 'curriculum_unit.dart';

class CurriculumStage {
  final String id;
  final String title;
  final String subtitle;
  final String gradeBand;
  final int order;
  final int themeColor;
  final String icon;
  final List<CurriculumUnit> units;

  const CurriculumStage({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.gradeBand,
    required this.order,
    this.themeColor = 0xFF58CC02,
    this.icon = '📖',
    this.units = const [],
  });

  int get unitCount => units.length;
  int get lessonCount => units.fold(0, (sum, u) => sum + u.lessonCount);
  int get totalXp => units.fold(0, (sum, u) => sum + u.totalXp);

  factory CurriculumStage.fromJson(Map<String, dynamic> json) {
    final unitsJson = json['units'] as List<dynamic>? ?? [];
    final stageId = json['id'] as String? ?? '';
    return CurriculumStage(
      id: stageId,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      gradeBand: json['gradeBand'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      themeColor: _parseColor(json['themeColor']),
      icon: json['icon'] as String? ?? '📖',
      units: unitsJson
          .map((u) => CurriculumUnit.fromJson(u as Map<String, dynamic>,
              stageId: stageId))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'gradeBand': gradeBand,
        'order': order,
        'themeColor': '0x${themeColor.toRadixString(16).padLeft(8, '0')}',
        'icon': icon,
        'units': units.map((u) => u.toJson()).toList(),
      };

  static int _parseColor(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      final hex = value.replaceFirst('0x', '').replaceFirst('#', '');
      return int.tryParse('0x$hex') ?? 0xFF58CC02;
    }
    return 0xFF58CC02;
  }
}
