import 'user_session.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import 'app_mode.dart';
import 'firebase_auth_service.dart';

class AuthService {
  UserSession _session = const UserSession();
  final ProfileRepository _profileRepo;
  final AppModeConfig _appMode;
  final FirebaseAuthService? _firebaseAuth;

  AuthService({
    required ProfileRepository profileRepo,
    required AppModeConfig appMode,
    FirebaseAuthService? firebaseAuth,
  })  : _profileRepo = profileRepo,
        _appMode = appMode,
        _firebaseAuth = firebaseAuth;

  UserSession get currentSession => _session;
  bool get isLoggedIn => _session.isAuthenticated;
  bool get isGuest => _session.isGuest;

  Future<void> initFromLocalProfile() async {
    final profile = await _profileRepo.load();
    _session = UserSession(
      id: profile.guestId,
      name: profile.name.isNotEmpty ? profile.name : 'Alby',
      avatarId: profile.avatarId,
      avatarPath: profile.avatarPath,
      mode: UserMode.guest,
    );
  }

  Future<void> initFromHost(String userId, String name, {String? avatarId, String? avatarPath}) async {
    _session = UserSession(
      id: userId,
      name: name,
      avatarId: avatarId ?? 'avatar_2',
      avatarPath: avatarPath ?? 'assets/characters/alby_happy.png',
      mode: UserMode.guest,
    );
  }

  Future<void> updateSession({
    String? name,
    String? avatarId,
    String? avatarPath,
  }) async {
    _session = _session.copyWith(
      name: name,
      avatarId: avatarId,
      avatarPath: avatarPath,
    );
    await _profileRepo.save(
      name: _session.name,
      avatarId: _session.avatarId,
      avatarPath: _session.avatarPath,
    );
  }

  Future<void> resetSession() async {
    await _profileRepo.clear();
    _session = const UserSession();
  }

  bool get canSync => _appMode.isEmbedded && _appMode.hasHostUser && isGuest;

  Future<void> syncProgressToCloud({
    required int xp,
    required int streak,
    required Set<String> completedLessonIds,
    required Set<String> collectedBadges,
    required int currentLevelIndex,
    required String selectedAvatarId,
  }) async {
    if (_firebaseAuth == null || _session.id.isEmpty) return;
    await _firebaseAuth.saveProgressToFirestore(
      userId: _session.id,
      xp: xp,
      streak: streak,
      completedLessonIds: completedLessonIds,
      collectedBadges: collectedBadges,
      currentLevelIndex: currentLevelIndex,
      selectedAvatarId: selectedAvatarId,
    );
  }
}
