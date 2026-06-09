import 'package:hive/hive.dart';

import '../../../../core/data/hive_boxes.dart';
import '../../../../core/error/app_exception.dart';
import '../../../rewards/data/models/sticker_model.dart';

/// Repository for managing sticker collection
class StickerRepository {
  final Box _userProgressBox;

  StickerRepository(this._userProgressBox);

  /// Get all stickers with their unlock status
  List<Sticker> getAllStickers() {
    try {
      final data = _userProgressBox.get(HiveBoxes.stickersKey);
      final allStickers = Sticker.allStickers;

      if (data == null) {
        // Initialize with some starter stickers unlocked
        final initial = <Sticker>[
          allStickers[0].copyWith(isUnlocked: true, unlockedAt: DateTime.now(), source: 'starter'),
          allStickers[6].copyWith(isUnlocked: true, unlockedAt: DateTime.now(), source: 'starter'),
          allStickers[18].copyWith(isUnlocked: true, unlockedAt: DateTime.now(), source: 'starter'),
        ];
        _saveStickers(initial);
        return _mergeStickers(allStickers, initial);
      }

      if (data is List) {
        final unlockedStickers = data
            .map((e) => Sticker.fromMap(e as Map<String, dynamic>))
            .toList();
        return _mergeStickers(allStickers, unlockedStickers);
      }

      return allStickers;
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal memuat koleksi stiker',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Unlock a sticker
  Future<void> unlockSticker(String stickerId, {String source = 'game'}) async {
    try {
      final stickers = getUnlockedStickers();
      final allStickers = Sticker.allStickers;
      final sticker = allStickers.firstWhere(
        (s) => s.id == stickerId,
        orElse: () => throw DataNotFoundException(message: 'Stiker tidak ditemukan'),
      );

      if (stickers.any((s) => s.id == stickerId)) return; // Already unlocked

      stickers.add(sticker.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
        source: source,
      ));

      await _saveStickers(stickers);
    } catch (e, st) {
      throw StorageException(
        message: 'Gagal membuka stiker',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Get count of unlocked stickers
  int getUnlockedCount() {
    return getUnlockedStickers().length;
  }

  /// Get total sticker count
  int get totalCount => Sticker.allStickers.length;

  /// Get only unlocked stickers
  List<Sticker> getUnlockedStickers() {
    try {
      final data = _userProgressBox.get(HiveBoxes.stickersKey);
      if (data == null) return [];
      if (data is List) {
        return data
            .map((e) => Sticker.fromMap(e as Map<String, dynamic>))
            .where((s) => s.isUnlocked)
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveStickers(List<Sticker> stickers) async {
    await _userProgressBox.put(
      HiveBoxes.stickersKey,
      stickers.map((s) => s.toMap()).toList(),
    );
  }

  /// Merge all stickers with unlocked status
  List<Sticker> _mergeStickers(List<Sticker> all, List<Sticker> unlocked) {
    final unlockedMap = {for (var s in unlocked) s.id: s};
    return all.map((s) {
      final unlockedVersion = unlockedMap[s.id];
      if (unlockedVersion != null && unlockedVersion.isUnlocked) {
        return unlockedVersion;
      }
      return s;
    }).toList();
  }
}
