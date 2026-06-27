# PROMPT UNTUK OPENCODE — KONSOLIDASI & PERBAIKAN ARSITEKTUR KATAPLAY

PENTING: Kerjakan TAHAP A terlebih dahulu secara LENGKAP dan TUNTAS.
JANGAN lanjut ke TAHAP B sebelum TAHAP A selesai dan sudah di-verifikasi jalan
di real device/emulator. Laporkan hasil TAHAP A sebelum melanjutkan.

============================================================
LATAR BELAKANG MASALAH
============================================================
Repo ini (branch `main`) memiliki MINIMAL 4 sistem lesson/quiz yang dibangun
terpisah dan tidak saling terhubung:

1. `lib/features/learning/` — LearningScreen versi lama
2. `lib/features/lesson/` — LessonScreen + ResultScreen (sudah di-upgrade
   dengan animasi premium: animated_stars, confetti_particles, dll)
3. `lib/features/lesson_engine/` — sistem terpisah dengan 11 jenis renderer
   (fill_blank, match_pair, story_reading, dst) + folder `core/agents/`
4. `lib/features/learning_path/` — sistem unit/stage terpisah lagi

Juga ditemukan DUA entry point app yang berbeda:
- `lib/main.dart` → memanggil `core/router/app_router.dart` (`appRouterProvider`)
  → mengarah ke `features/learning/` (LAMA)
- `lib/app/app.dart` → memanggil `app/router/router.dart` (`routerProvider`)
  → mengarah ke `features/lesson/` (BARU, yang sudah dipercantik)

Akibatnya: kemungkinan besar upgrade visual yang sudah dikerjakan di
`features/lesson/result_screen.dart` TIDAK PERNAH MUNCUL saat app benar-benar
di-run, karena `main.dart` (entry point asli) memanggil jalur yang berbeda.

Juga ditemukan file duplikat lain:
- Dua `home_screen.dart` (`home/presentation/` dan `home/presentation/screens/`)
- Dua `splash_screen.dart` (`auth/presentation/` dan `onboarding/presentation/screens/`)
- Dua `profile_screen.dart` (`profile/presentation/` dan `profile/presentation/screens/`)
- Dua `app_colors.dart` (`app/theme/` dan `core/theme/`)

============================================================
TAHAP A — AUDIT, KONFIRMASI, DAN KONSOLIDASI (WAJIB DULUAN)
============================================================

### A.1 — Audit & Pemetaan
Sebelum mengubah apapun, lakukan dan laporkan:
1. Jalankan `flutter run` (atau build APK debug) dan screenshot/catat
   SECARA PASTI screen mana yang benar-benar muncul untuk flow:
   Splash → Onboarding → Home → masuk ke lesson/quiz → Result/Completion
2. Untuk setiap screen yang muncul, sebutkan path file persisnya
   (contoh: "Home yang muncul adalah lib/features/home/presentation/screens/home_screen.dart")
3. Cek apakah `lib/app/app.dart` dan `lib/app/router/router.dart` benar-benar
   dipakai di mana saja (grep semua import ke file ini). Jika TIDAK ada yang
   mengimpor/memanggilnya dari `main.dart`, maka itu adalah DEAD CODE.
4. Cek apakah `features/lesson_engine/` (dengan 11 renderer + agents) sedang
   dipakai di route aktif manapun, atau juga dead code.
5. Cek apakah `features/learning_path/` dipakai di route aktif.
6. Buat TABEL RINGKASAN: [Sistem] | [Path] | [Dipanggil dari main.dart?] |
   [Status: AKTIF/DEAD CODE] | [Kelengkapan fitur: lengkap/setengah jadi]

### A.2 — Keputusan Konsolidasi (ikuti aturan ini, jangan menebak sendiri)
Setelah audit, host/decision rule yang HARUS diikuti:

- JIKA `features/lesson/` (yang sudah ada animasi premium: animated_stars,
  confetti_particles, segmented_progress_bar, streak_indicator, dll) adalah
  yang PALING LENGKAP fiturnya dibanding `features/learning/` →
  JADIKAN `features/lesson/` SEBAGAI SATU-SATUNYA SISTEM AKTIF.
  Ubah `lib/main.dart` agar memanggil router yang mengarah ke `features/lesson/`
  (gabungkan logic routing dari `app/router/router.dart` ke dalam
  `core/router/app_router.dart`, JANGAN biarkan dua file router terpisah).

- JIKA `features/lesson_engine/` punya logic/fitur penting yang TIDAK ada
  di `features/lesson/` (misalnya 11 jenis renderer soal yang lebih variatif:
  fill_blank, match_pair, listen_choose, story_reading, dst, sedangkan
  `features/lesson/` cuma punya sedikit jenis soal) → JANGAN dihapus dulu.
  Laporkan dulu perbandingan fitur antara `features/lesson/` dan
  `features/lesson_engine/`, supaya bisa diputuskan: apakah renderer-renderer
  ini perlu DIPINDAHKAN/DIINTEGRASIKAN ke dalam `features/lesson/`
  (karena itu yang sudah punya visual premium), sebelum yang lama dihapus.

- Untuk file-file duplikat sederhana (home_screen, splash_screen, profile_screen,
  app_colors) — pilih versi yang DIPANGGIL oleh main.dart sebagai yang AKTIF,
  hapus duplikatnya SETELAH memastikan tidak ada fitur unik yang hilang.

### A.3 — Eksekusi Konsolidasi
1. Satukan jadi SATU router saja, SATU entry point saja, SATU app theme/colors file.
2. Hapus folder/file yang sudah dikonfirmasi sebagai dead code TANPA fitur unik.
3. Jika ada fitur unik di sistem yang akan dihapus (misal: jenis-jenis renderer
   soal di `lesson_engine/`), migrasikan dulu ke sistem yang akan dipertahankan.
4. Update SEMUA import yang masih mengarah ke path lama.
5. Jalankan `flutter analyze` — pastikan 0 error dan 0 warning baru akibat
   penghapusan/migrasi ini.
6. Jalankan `flutter test` — pastikan semua test masih pass. Jika ada test
   yang mengetes file yang dihapus, hapus juga test-nya (dengan catatan di
   laporan akhir).
7. Build APK debug dan VERIFIKASI ULANG dengan menjalankan full flow:
   Splash → Onboarding → Home → pilih lesson → jawab soal → lihat Result Screen
   — dan PASTIKAN yang muncul adalah versi dengan animasi premium
   (stars dengan glow, confetti saat perfect score, gradient text, dll).

### A.4 — Laporan Wajib Sebelum Lanjut ke Tahap B
Setelah Tahap A selesai, laporkan dalam format ini:
- Sistem mana yang dipertahankan sebagai satu-satunya jalur aktif
- File/folder apa saja yang dihapus
- Fitur apa saja (jika ada) yang dimigrasikan dari sistem lama ke sistem baru
- Konfirmasi: screenshot/deskripsi hasil run app yang menunjukkan Result Screen
  versi premium BENAR-BENAR muncul saat app dijalankan dari awal (bukan dari
  widget test terisolasi)
- Status `flutter analyze` dan `flutter test` setelah konsolidasi

============================================================
TAHAP B — LANJUTAN UPGRADE LEARNING/QUIZ SCREEN
(HANYA DIKERJAKAN SETELAH TAHAP A DIKONFIRMASI SELESAI DAN BENAR)
============================================================

Setelah satu jalur sistem dikonfirmasi aktif dan berjalan benar, lakukan
upgrade pada screen soal/quiz aktif (kemungkinan `lesson_screen.dart` atau
hasil migrasi dari `lesson_engine`) dengan prinsip "Simple but Powerful —
di atas level Duolingo":

### B.1 — Progress Bar & Header
- Pastikan `segmented_progress_bar.dart` (sudah ada di `features/lesson/presentation/widgets/`)
  benar-benar dipakai di screen yang aktif, terintegrasi dengan jumlah soal
  sesungguhnya dari provider/state, bukan hardcoded.
- Animasi fill antar soal pakai curve easeOutCubic, durasi 300-400ms.
- Tombol close (X) pakai dialog konfirmasi custom (scale+fade), bukan
  AlertDialog default — cek apakah `_showExitConfirmation` di lesson_screen
  sudah sesuai pattern ini, jika belum, upgrade.

### B.2 — Transisi Antar Soal
- Pastikan `question_transition_wrapper.dart` yang sudah ada benar-benar
  dipakai untuk SETIAP perpindahan soal (cek penggunaannya di lesson_screen
  / lesson_shell, jangan biarkan ada jalur yang skip transisi ini).
- Transisi: slide+fade dari kanan masuk, slide+fade ke kiri keluar,
  durasi 350-400ms, curve easeInOutCubic, TIDAK blocking interaksi user.

### B.3 — Kartu Jawaban (answer_option_card.dart / answer_button.dart)
PENTING: ada DUA file yang mirip — `answer_option_card.dart` dan
`answer_button.dart` di `features/lesson/presentation/widgets/`. Audit dulu:
apakah keduanya dipakai di tempat berbeda, atau salah satunya duplikat/dead code?
Konsolidasikan jadi SATU widget jawaban yang konsisten dipakai di semua jenis
soal, dengan state: default, selected, correct (hijau+checkmark+bounce+haptic
light), incorrect (merah+shake 3x+haptic medium), dan auto-highlight jawaban
benar saat user salah pilih.

### B.4 — Streak Indicator
- Pastikan `streak_indicator.dart` terhubung ke data combo/streak yang
  SESUNGGUHNYA dari state management (cek `learning_provider.dart` atau
  state lesson yang aktif), bukan nilai dummy.
- Muncul saat >=3 jawaban benar berturut-turut, fade out otomatis.

### B.5 — Bottom Action (lesson_bottom_action.dart)
- Disabled state sebelum user pilih jawaban, enabled dengan smooth color
  transition setelah user memilih.
- Cross-fade dari tombol "Periksa" ke "Lanjut" setelah jawaban diperiksa.
- Fixed di bottom dengan shadow elevation.

### B.6 — Loading State
- Pastikan `shimmer_loading.dart` yang sudah ada dipakai saat soal sedang
  di-load (bukan CircularProgressIndicator generic) — cek dan ganti semua
  pemakaian spinner default jika masih ada yang tersisa.

### B.7 — Guardrail Performa (WAJIB)
- Profile mode test (`flutter run --profile`) untuk transisi antar soal,
  pastikan tidak ada jank, target stabil 60fps.
- Maksimal 10-15 partikel untuk efek apapun yang terjadi BERULANG per soal
  (beda dengan confetti di Result Screen yang hanya muncul sekali di akhir
  dan boleh lebih banyak partikel).
- Background Learning/Quiz screen tetap netral (putih/light grey) — JANGAN
  pakai gradient ramai seperti Result Screen, supaya user tetap fokus
  mengerjakan soal. Gradient & confetti besar disimpan khusus untuk momen
  reward di akhir (Result Screen).

### B.8 — Verifikasi Akhir
1. `flutter analyze` — 0 warning
2. `flutter test` — semua pass, tambahkan minimal 1 widget test baru untuk
   widget jawaban yang sudah dikonsolidasi (4 state: default, selected,
   correct, incorrect)
3. Jalankan full flow sekali lagi dari Splash sampai Result Screen, laporkan
   hasilnya beserta FPS rata-rata saat transisi soal (dari DevTools jika bisa)

============================================================
ATURAN UMUM
============================================================
- JANGAN membuat sistem/folder paralel baru lagi. Jika ragu fitur sudah ada
  di mana, CARI DULU dengan grep/search sebelum membuat file baru.
- Setiap kali akan menghapus file, pastikan dulu tidak ada fitur unik yang
  hilang — laporkan jika ragu, jangan langsung hapus.
- Semua perubahan harus dilaporkan dengan diff/summary yang jelas, termasuk
  file apa yang dihapus, dipindah, atau digabung.
