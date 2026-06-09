import 'package:hive/hive.dart';

import '../../../../core/data/hive_boxes.dart';
import '../../../../core/error/app_exception.dart';

/// Repository for onboarding state management
class OnboardingRepository {
  final Box _onboardingBox;

  OnboardingRepository(this._onboardingBox);

  /// Check if user has completed onboarding
  bool isOnboardingComplete() {
    try {
      return _onboardingBox.get(HiveBoxes.completedKey, defaultValue: false) as bool;
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memuat status onboarding',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding({String? playerName, int? playerAge}) async {
    try {
      await _onboardingBox.put(HiveBoxes.completedKey, true);
      if (playerName != null) {
        await _onboardingBox.put(HiveBoxes.playerNameKey, playerName);
      }
      if (playerAge != null) {
        await _onboardingBox.put(HiveBoxes.playerAgeKey, playerAge);
      }
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal menyimpan status onboarding',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Get saved player name
  String getPlayerName() {
    try {
      return _onboardingBox.get(HiveBoxes.playerNameKey, defaultValue: 'Petualang') as String;
    } catch (e) {
      return 'Petualang';
    }
  }

  /// Get saved player age
  int getPlayerAge() {
    try {
      return _onboardingBox.get(HiveBoxes.playerAgeKey, defaultValue: 6) as int;
    } catch (e) {
      return 6;
    }
  }

  /// Reset onboarding (for testing or profile reset)
  Future<void> resetOnboarding() async {
    try {
      await _onboardingBox.delete(HiveBoxes.completedKey);
      await _onboardingBox.delete(HiveBoxes.playerNameKey);
      await _onboardingBox.delete(HiveBoxes.playerAgeKey);
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal mereset onboarding',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}
