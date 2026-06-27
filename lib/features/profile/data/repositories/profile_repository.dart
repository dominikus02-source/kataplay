import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/storage_keys.dart';

class LocalProfile {
  final String guestId;
  final String name;
  final String avatarId;
  final String avatarPath;

  const LocalProfile({
    this.guestId = 'guest_local',
    this.name = '',
    this.avatarId = AppConstants.defaultAvatarId,
    this.avatarPath = AppConstants.defaultAvatarPath,
  });
}

class ProfileRepository {
  Future<Box> _getBox() async => await Hive.openBox('kataplay_data');

  Future<LocalProfile> load() async {
    final box = await _getBox();
    return LocalProfile(
      guestId: box.get(StorageKeys.profileGuestId) ??
          AppConstants.defaultGuestId,
      name: box.get(StorageKeys.childName) ?? '',
      avatarId: box.get(StorageKeys.selectedAvatarId) ??
          AppConstants.defaultAvatarId,
      avatarPath: box.get(StorageKeys.selectedAvatarPath) ??
          AppConstants.defaultAvatarPath,
    );
  }

  Future<void> save({
    String? name,
    String? avatarId,
    String? avatarPath,
  }) async {
    final box = await _getBox();
    if (name != null) await box.put(StorageKeys.childName, name);
    if (avatarId != null) {
      await box.put(StorageKeys.selectedAvatarId, avatarId);
    }
    if (avatarPath != null) {
      await box.put(StorageKeys.selectedAvatarPath, avatarPath);
    }
  }

  Future<void> clear() async {
    final box = await _getBox();
    await box.delete(StorageKeys.childName);
    await box.delete(StorageKeys.selectedAvatarId);
    await box.delete(StorageKeys.selectedAvatarPath);
  }
}
