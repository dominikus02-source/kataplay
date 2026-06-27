enum AvatarCategory {
  all,
  avatar,
}

class AvatarItem {
  final String id;
  final String name;
  final AvatarCategory category;
  final String assetPath;

  const AvatarItem({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
  });
}
