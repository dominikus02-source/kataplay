# PROMPT OPENCODE — TAHAP A FINAL: SELAMATKAN RUTE HILANG + INTEGRASI + CLEANUP

Sudah dikonfirmasi (lewat pengecekan independen) bahwa:
- `main.dart` sudah benar memanggil `app/router/router.dart` ✅
- Duplikat home/splash/profile sudah bersih, tersisa 1 masing-masing ✅
- `core/router/app_router.dart` sudah terhapus ✅

TAPI ada 2 masalah yang BELUM selesai dan HARUS dikerjakan sebelum cleanup
final dan sebelum lanjut ke Tahap B (polish visual):

============================================================
MASALAH #1 — RUTE YANG HILANG SAAT KONSOLIDASI (PRIORITAS TINGGI)
============================================================
Konfirmasi independen menemukan: `/progress`, `/setelan`, `/pulau`,
`/main` (minigames hub), `/game/matching` — SEMUA hilang dari router baru.
Lebih parah: untuk `pulau_kata_screen.dart`, `minigames_hub_screen.dart`,
dan `cocokkan_kata_screen.dart` — FILE-NYA SENDIRI SUDAH TIDAK ADA di
direktori manapun (bukan cuma rutenya yang hilang, filenya juga hilang).
Untuk `progress_screen.dart` juga sudah tidak ada filenya.
Untuk `settings_screen.dart` — filenya TIDAK ADA, tapi
`settings_provider.dart` dan `settings_repository.dart` MASIH ADA (orphan).

INI BERARTI: kemungkinan file-file screen tersebut terhapus saat proses
konsolidasi sebelumnya, TANPA verifikasi dulu apakah ada fitur yang hilang
permanen. Sebelum melakukan apapun:

1. Cek git history untuk memastikan apakah file-file ini benar pernah ada
   dan terhapus di commit mana:
   git log --all --diff-filter=D --summary | grep -i "pulau_kata\|minigames_hub\|cocokkan_kata\|progress_screen\|settings_screen"

2. Untuk SETIAP file yang terhapus, recover isinya dari commit sebelum
   terhapus (git show <commit>^:<path> > temp_recovered_file.dart) supaya
   bisa dilihat dulu apa isinya, JANGAN langsung restore mentah-mentah.

3. Untuk MASING-MASING fitur ini (Pulau Kata/adventure map, Minigames hub,
   Cocokkan Kata, Progress screen, Settings screen), putuskan:
   a. Apakah fitur ini MASIH RELEVAN dengan arah app sekarang (yang sudah
      punya learning_path + lesson_engine + lesson sebagai jalur belajar
      utama)? Atau apakah fitur ini sudah usang/digantikan fungsinya oleh
      sistem baru (misal: apakah "Progress screen" lama sudah digantikan
      oleh progress yang ditampilkan di home_screen baru atau di
      learning_path_screen)?
   b. JIKA masih relevan dan tidak ada penggantinya → restore file,
      perbaiki import yang sudah berubah (path provider, theme, dll
      mengikuti struktur baru), daftarkan ulang rutenya di
      `app/router/router.dart`, dan tambahkan kembali navigasi ke fitur
      ini dari home_screen.dart (cek dulu apakah home_screen.dart yang
      sekarang punya tombol/menu ke fitur-fitur ini, atau menu itu juga
      ikut terhapus).
   c. JIKA sudah digantikan fungsinya oleh sistem baru → JANGAN restore,
      tapi laporkan dengan jelas: "fitur X tidak direstore karena sudah
      digantikan oleh Y", dan hapus file orphan terkait (seperti
      settings_provider.dart, settings_repository.dart jika settings
      screen benar-benar tidak akan dikembalikan — KECUALI jika
      provider/repository ini masih dipakai screen lain, cek dulu dengan
      grep sebelum hapus).

4. Laporkan hasil keputusan untuk SETIAP fitur (Pulau Kata, Minigames Hub,
   Cocokkan Kata, Progress, Settings) dalam tabel: [Fitur] | [Direstore?] |
   [Alasan] | [Rute baru jika direstore].

============================================================
MASALAH #2 — INTEGRASI lesson_engine/ KE lesson_screen.dart BELUM DIKERJAKAN
============================================================
Dikonfirmasi: `lesson_screen.dart` saat ini HANYA menangani 7 jenis soal
lama (imageChoice, wordChoice, trueFalse, arrangeWord, fillBlank, matching,
readSentence) — TIDAK ada import atau pemanggilan apapun ke renderer dari
`lesson_engine/`. Artinya Option B (yang sudah disepakati) belum dieksekusi
sama sekali, masih di tahap rencana.

Kerjakan sekarang:
1. Identifikasi 7 jenis soal TAMBAHAN yang hanya ada di lesson_engine/
   (pictureChoice, listenChoose, missingWord, sentenceChoice, storyReading,
   storyComprehension, readingComprehension, recordVoice, speakingPractice,
   wordOrder — sesuaikan dengan daftar aktual di lesson_engine/domain).
2. Untuk SETIAP jenis soal tambahan ini, integrasikan renderer-nya supaya
   bisa dipanggil dari dalam `lesson_screen.dart`, DENGAN tetap memakai
   wrapper visual premium yang sudah ada (kartu jawaban dengan animasi
   benar/salah, question_transition_wrapper, segmented_progress_bar, dst)
   — JANGAN biarkan jenis soal baru ini tampil dengan UI polos dari
   lesson_engine/ yang lama. Bungkus konten/logic renderer-nya dengan
   shell visual premium dari features/lesson/.
3. Pastikan data model soal (LessonType enum atau sejenisnya) diperluas
   untuk mencakup semua 14 jenis, dan progressProvider (Hive-backed) tetap
   menjadi satu-satunya sumber kebenaran progress untuk SEMUA jenis soal
   ini (termasuk yang berasal dari lesson_engine).
4. Setelah integrasi, putuskan: apakah route `/lesson-engine` dan screen
   `lesson_engine_screen.dart` masih perlu dipertahankan terpisah (sebagai
   entry point lain), atau sekarang semua soal bisa lewat `/lesson` saja
   dengan lesson_screen.dart yang sudah diperluas? Jika yang kedua,
   redirect `/lesson-engine` ke `/lesson` atau hapus rute itu, dan
   pertimbangkan apakah file lesson_engine_screen.dart (bukan renderer-nya,
   tapi screen wrapper-nya) jadi tidak diperlukan lagi.
5. Cek juga `lesson_completion_screen.dart` (di lesson_engine/) — setelah
   integrasi, screen ini harus REDUNDANT karena semua soal sekarang
   bermuara ke `result_screen.dart` premium. Hapus jika benar redundant,
   pastikan dulu tidak ada flow yang masih mengarah ke sana.

============================================================
MASALAH #3 — CLEANUP DEAD CODE (BARU SETELAH #1 DAN #2 SELESAI)
============================================================
- Hapus `lib/features/profile/presentation/providers/progress_provider.dart`
  HANYA jika dikonfirmasi tidak ada import-nya di manapun (grep dulu).
- Untuk `settings_provider.dart`/`settings_repository.dart`: ikuti keputusan
  dari MASALAH #1 poin 3 (hapus hanya jika settings screen benar tidak
  direstore DAN tidak dipakai file lain).
- Hapus direktori `lib/core/theme/` dan `lib/theme/` jika benar-benar kosong
  (`find lib/core/theme lib/theme -type f` harus return nothing).

============================================================
VERIFIKASI AKHIR (WAJIB, SAMA SEPERTI SEBELUMNYA)
============================================================
1. `flutter analyze` — laporkan jumlah error/warning sebelum & sesudah.
2. `flutter test` — laporkan pass/fail sebelum & sesudah, tambahkan test
   baru untuk minimal 2 jenis soal hasil integrasi lesson_engine.
3. `git status`, `git diff --stat`, `git log -1` — tampilkan bukti konkret.
4. Konfirmasi push ke remote (`git status` menunjukkan "up to date with
   origin/main") — jika belum bisa push, JELASKAN SECARA EKSPLISIT.
5. Jalankan app dari awal, deskripsikan flow lengkap: Splash → Onboarding
   → Home (apakah SEMUA menu/tombol di Home, termasuk ke fitur yang
   direstore di Masalah #1, berfungsi tanpa error?) → masuk ke salah satu
   dari 14 jenis soal (sebutkan jenis mana yang ditest) → Result Screen
   premium muncul di akhir.
6. Laporkan tabel akhir: SEMUA rute yang terdaftar di router final,
   beserta screen file yang dipanggil masing-masing — supaya bisa
   dipastikan tidak ada rute yang "menggantung" (terdaftar tapi screennya
   error/belum lengkap) atau fitur yang hilang tanpa sengaja.

============================================================
ATURAN
============================================================
- JANGAN hapus file apapun di Masalah #1 sebelum keputusan restore/tidak
  benar-benar diputuskan dan dilaporkan.
- JANGAN klaim "selesai" tanpa bukti command yang dijalankan saat itu juga.
- Jika ragu sebuah fitur masih relevan atau tidak, LAPORKAN dan TANYAKAN,
  jangan menghapus secara sepihak.
