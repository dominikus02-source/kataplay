class LessonWorld {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String colorHex;
  final bool isUnlocked;

  const LessonWorld({
    required this.id,
    required this.name,
    required this.description,
    this.icon = '🌍',
    this.colorHex = 'FF58CC02',
    this.isUnlocked = true,
  });

  factory LessonWorld.fromJson(Map<String, dynamic> json) {
    return LessonWorld(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '🌍',
      colorHex: json['color'] as String? ?? 'FF58CC02',
      isUnlocked: json['isUnlocked'] as bool? ?? true,
    );
  }
}
