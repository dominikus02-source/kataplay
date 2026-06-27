# QA Report — Tahap B

## Bagian 1: Tabel Verifikasi 18 Jenis Soal (Nama Benar)

Enum source: `lib/features/lesson/domain/lesson.dart` (18 values)

| # | Nama Enum | Handler | Renderer/Widget | Data di `level_content.dart` | Data di `sample_lesson_pack.json` | Status |
|---|-----------|---------|-----------------|------------------------------|-----------------------------------|--------|
| 1 | `imageChoice` | Non-engine (legacy) | `_buildAnswerArea()` → `AnswerOptionCard` | ✅ 40+ soal (level 1–8) | ❌ | ✅ Berfungsi |
| 2 | `pictureChoice` | Engine | `PictureChoiceRenderer` | ❌ 0 soal | ✅ 1 soal (pc_001) | ⚠️ Tidak ada data produksi |
| 3 | `wordChoice` | Non-engine (legacy) | `_buildAnswerArea()` → `AnswerOptionCard` | ✅ 15+ soal | ✅ 2 soal (wc_001, wc_002) | ✅ Berfungsi |
| 4 | `trueFalse` | Non-engine (legacy) | `_buildAnswerArea()` → `AnswerOptionCard` | ✅ 10+ soal | ✅ 2 soal (tf_001, tf_002) | ✅ Berfungsi |
| 5 | `arrangeWord` | Non-engine (legacy) | `ArrangeWordsQuestion` widget | ✅ 6 soal | ❌ | ✅ Berfungsi |
| 6 | `wordOrder` | Engine | `WordOrderRenderer` | ❌ 0 soal | ✅ 2 soal (wo_001, wo_002) | ⚠️ Tidak ada data produksi |
| 7 | `fillBlank` | Non-engine (legacy) | `_buildAnswerArea()` → `AnswerOptionCard` | ✅ 10+ soal | ✅ 1 soal (fb_001) | ✅ Berfungsi |
| 8 | `matching` | Non-engine (legacy) | `_buildAnswerArea()` custom match UI | ✅ 4 soal | ❌ | ✅ Berfungsi |
| 9 | `matchPair` | Engine | `MatchPairRenderer` | ❌ 0 soal | ✅ 1 soal (mp_001) | ⚠️ Tidak ada data produksi |
| 10 | `readSentence` | Non-engine (legacy) | `_buildAnswerArea()` → `buildSentenceQuestion()` | ✅ 8 soal | ❌ | ✅ Berfungsi |
| 11 | `listenChoose` | Engine | `ListenChooseRenderer` | ❌ 0 soal | ✅ 1 soal (lc_001) | ⚠️ Tidak ada data produksi |
| 12 | `missingWord` | Engine | `MissingWordRenderer` | ❌ 0 soal | ✅ 1 soal (mw_001) | ⚠️ Tidak ada data produksi |
| 13 | `sentenceChoice` | Engine | `SentenceChoiceRenderer` | ❌ 0 soal | ✅ 1 soal (sc_001) | ⚠️ Tidak ada data produksi |
| 14 | `storyReading` | Engine | `StoryReadingRenderer` | ❌ 0 soal | ✅ 1 soal (sr_001) | ⚠️ Tidak ada data produksi |
| 15 | `storyComprehension` | Engine | `StoryComprehensionRenderer` | ❌ 0 soal | ✅ 2 soal (scq_001, scq_002) | ⚠️ Tidak ada data produksi |
| 16 | `readingComprehension` | Engine | `ReadingComprehensionRenderer` | ❌ 0 soal | ✅ 1 soal (rc_001) | ⚠️ Tidak ada data produksi |
| 17 | `recordVoice` | Engine | `RecordVoiceRenderer` | ❌ 0 soal | ✅ 1 soal (rv_001) | ⚠️ Tidak ada data produksi + butuh mic permission |
| 18 | `speakingPractice` | Engine | `SpeakingPracticeRenderer` | ❌ 0 soal | ✅ 1 soal (sp_001) | ⚠️ Tidak ada data produksi + butuh mic permission |

### Gaps Ditemukan

1. **11 dari 18 jenis soal TIDAK PUNYA data di `level_content.dart`** — semua tipe engine (pictureChoice, wordOrder, matchPair, listenChoose, missingWord, sentenceChoice, storyReading, storyComprehension, readingComprehension, recordVoice, speakingPractice) hanya punya data di file JSON sample, BUKAN di level_content.dart yang digunakan oleh `LessonScreen`.

2. **Sample JSON tidak terdaftar sebagai asset** — `lib/features/lesson_engine/data/sample_lessons/sample_lesson_pack.json` tidak ada di `pubspec.yaml` → `JsonLessonLoader.loadFromAsset()` akan gagal runtime.

3. **Dua enum LessonType berbeda** — `lesson.dart` (18 values) vs `lesson_engine/domain/lesson_type.dart` (16 values). Ada 2 tipe ekstra di engine (`storySequence`, `paragraphChoice`) yang tidak ada di `lesson.dart` dan hanya placeholder "belum tersedia". Sebaliknya, `lesson.dart` punya `imageChoice`, `matching`, `readSentence`, `arrangeWord` yang tidak ada di engine enum.

4. **Belum ada QA manual device** — app berhasil build (`flutter build macos` sukses) dan launch, tetapi tidak bisa diverifikasi interaktif (shake/haptic/transition/60fps) karena environment CLI.

## Bagian 2: QA End-to-End (Terbatas)

### Apa yang sudah diverifikasi:

| Aspek | Hasil | Metode |
|-------|-------|--------|
| `flutter analyze lib/` | ✅ 0 errors, 0 warnings | static analysis |
| `flutter test` | ✅ 20/20 passed | unit/widget test |
| `flutter build macos --debug` | ✅ Build success | compilation |
| App launch (macOS) | ✅ App runs without crash | process launch |
| Non-engine types (7) | ✅ Data exists, code paths traced | code reading |
| Engine types (11) | ⚠️ No production data, but renderers exist | code reading |
| Shake wrapper integration | ✅ Verified in lesson_screen.dart:392 | code reading |
| Haptic feedback | ✅ 3 types implemented | code reading |
| QuestionTransitionWrapper | ✅ Wraps _buildQuestionCard | code reading |

### Belum diverifikasi (butuh device fisik/emulator):

- Apakah shake animation benar terlihat saat jawaban salah
- Apakah haptic feedback benar terasa
- Apakah transisi antar soal smooth (60fps)
- Apakah recordVoice/speakingPractice handle mic permission denial gracefully
- Apakah confetti muncul saat skor sempurna
- Apakah animated stars dan XP counter berfungsi

## Bagian 3: Performance Profiling

`flutter run --profile` dan DevTools tidak bisa dijalankan di lingkungan CLI non-interaktif tanpa GUI. Belum ada data FPS.

## Kesimpulan

**App build dan launch berhasil.** 7 tipe soal legacy berfungsi penuh dengan data produksi. 11 tipe engine memiliki renderer siap pakai tetapi BELUM punya data di `level_content.dart`. Sample JSON ada tapi tidak ter-register sebagai asset.

### Rekomendasi Prioritas

1. **Segera**: Daftarkan sample lesson JSON di `pubspec.yaml` assets agar bisa di-load runtime
2. **Segera**: Tambahkan data untuk 11 tipe engine ke `level_content.dart` atau buat lesson content factory
3. **Nanti**: QA manual di device/emulator untuk shake, haptic, transition
4. **Nanti**: Performance profiling di device
