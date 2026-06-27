import '../../domain/avatar_item.dart';

class AvatarRepository {
  AvatarRepository._();

  static final List<AvatarItem> _allAvatars = [
    ..._avatars,
  ];

  static List<AvatarItem> getAll() => List.unmodifiable(_allAvatars);

  static List<AvatarItem> getByCategory(AvatarCategory category) {
    if (category == AvatarCategory.all) return getAll();
    return _allAvatars.where((a) => a.category == category).toList();
  }

  static AvatarItem? getById(String id) {
    try {
      return _allAvatars.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  static const _avatarsBase = 'assets/Avatar';

  static final List<AvatarItem> _avatars = [
    AvatarItem(
      id: 'avatar_2',
      name: 'Avatar 2',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/2.png',
    ),
    AvatarItem(
      id: 'avatar_3',
      name: 'Avatar 3',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/3.png',
    ),
    AvatarItem(
      id: 'avatar_4',
      name: 'Avatar 4',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/4.png',
    ),
    AvatarItem(
      id: 'avatar_5',
      name: 'Avatar 5',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/5.png',
    ),
    AvatarItem(
      id: 'avatar_6',
      name: 'Avatar 6',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/6.png',
    ),
    AvatarItem(
      id: 'avatar_7',
      name: 'Avatar 7',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/7.png',
    ),
    AvatarItem(
      id: 'avatar_8',
      name: 'Avatar 8',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/8.png',
    ),
    AvatarItem(
      id: 'avatar_9',
      name: 'Avatar 9',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/9.png',
    ),
    AvatarItem(
      id: 'avatar_10',
      name: 'Avatar 10',
      category: AvatarCategory.avatar,
      assetPath: '$_avatarsBase/10.png',
    ),
  ];
}
