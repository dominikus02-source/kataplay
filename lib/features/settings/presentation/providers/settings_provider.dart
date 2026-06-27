import 'package:flutter/foundation.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;
  bool get soundEnabled => _settings.soundEnabled;
  bool get musicEnabled => _settings.musicEnabled;
  bool get onboardingComplete => _settings.onboardingComplete;

  Future<void> load() async {
    _settings = await _repository.load();
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _settings = _settings.copyWith(soundEnabled: value);
    await _repository.save(_settings);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool value) async {
    _settings = _settings.copyWith(musicEnabled: value);
    await _repository.save(_settings);
    notifyListeners();
  }

  Future<void> markOnboardingComplete() async {
    _settings = _settings.copyWith(onboardingComplete: true);
    await _repository.save(_settings);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _settings = const AppSettings();
    await _repository.save(_settings);
    notifyListeners();
  }
}
