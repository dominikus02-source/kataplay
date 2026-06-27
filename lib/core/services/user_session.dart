enum UserMode { guest, authenticated }

class UserSession {
  final String id;
  final String name;
  final String avatarId;
  final String avatarPath;
  final UserMode mode;

  const UserSession({
    this.id = 'guest_local',
    this.name = 'Alby',
    this.avatarId = 'avatar_2',
    this.avatarPath = 'assets/characters/alby_happy.png',
    this.mode = UserMode.guest,
  });

  bool get isGuest => mode == UserMode.guest;
  bool get isAuthenticated => mode == UserMode.authenticated;

  UserSession copyWith({
    String? id,
    String? name,
    String? avatarId,
    String? avatarPath,
    UserMode? mode,
  }) {
    return UserSession(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
      avatarPath: avatarPath ?? this.avatarPath,
      mode: mode ?? this.mode,
    );
  }
}
