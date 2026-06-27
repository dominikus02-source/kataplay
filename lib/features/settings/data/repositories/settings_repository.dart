import 'package:hive/hive.dart';
import '../../../../core/constants/storage_keys.dart';

class AppSettings {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool onboardingComplete;

  const AppSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.onboardingComplete = false,
  });

  AppSettings copyWith({bool? soundEnabled, bool? musicEnabled, bool? onboardingComplete}) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

class SettingsRepository {
  Future<Box> _getBox() async => await Hive.openBox('kataplay_data');

  Future<AppSettings> load() async {
    final box = await _getBox();
    return AppSettings(
      soundEnabled: box.get(StorageKeys.settingSound) ?? true,
      musicEnabled: box.get(StorageKeys.settingMusic) ?? true,
      onboardingComplete:
          box.get(StorageKeys.settingOnboardingComplete) ?? false,
    );
  }

  Future<void> save(AppSettings settings) async {
    final box = await _getBox();
    await box.put(StorageKeys.settingSound, settings.soundEnabled);
    await box.put(StorageKeys.settingMusic, settings.musicEnabled);
    await box.put(
        StorageKeys.settingOnboardingComplete, settings.onboardingComplete);
  }

  Future<void> markOnboardingComplete() async {
    final box = await _getBox();
    await box.put(StorageKeys.settingOnboardingComplete, true);
  }

  Future<bool> isOnboardingComplete() async {
    final box = await _getBox();
    return box.get(StorageKeys.settingOnboardingComplete) ?? false;
  }

  Future<void> update({bool? soundEnabled, bool? musicEnabled}) async {
    final current = await load();
    await save(current.copyWith(
        soundEnabled: soundEnabled, musicEnabled: musicEnabled));
  }
}
