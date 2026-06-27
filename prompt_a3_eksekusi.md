# PROMPT OPENCODE — TAHAP A.3: EKSEKUSI KONSOLIDASI KATAPLAY

Audit A.1 dan keputusan A.2 sudah dikonfirmasi sebagai berikut:

- `features/lesson/` (PREMIUM, dengan animated_stars, confetti_particles, dll)
  akan menjadi SATU-SATUNYA sistem lesson/quiz yang aktif.
- `features/lesson_engine/` DITAHAN (jangan dihapus) karena punya 14 jenis
  renderer soal unik yang tidak ada di `features/lesson/`.
- `features/learning_path/` DITAHAN (jangan dihapus) karena punya logic
  stage/unit progression unik.
- `features/learning/` (OLD) akan dihapus SETELAH migrasi selesai.
- Duplikat Home/Splash/Profile/Colors: versi "NEW" akan dipertahankan,
  versi "OLD" akan dihapus.

SEBELUM mengeksekusi penghapusan apapun, kerjakan dulu 2 VERIFIKASI WAJIB
di bawah ini. JANGAN lanjut ke eksekusi penghapusan sebelum verifikasi ini
selesai dan dilaporkan.

============================================================
VERIFIKASI WAJIB #1 — RENCANA INTEGRASI lesson_engine & learning_path
============================================================
`lesson_engine/` dan `learning_path/` saat ini hanya terhubung lewat
`app/router/router.dart` yang TIDAK dipanggil oleh `main.dart` (dead route).
Jika `features/lesson/` dijadikan satu-satunya sistem aktif, maka 14 jenis
renderer soal di `lesson_engine/` dan logic stage/unit di `learning_path/`
HARUS punya jalan untuk tetap bisa dipakai. Pilih SATU pendekatan berikut
dan laporkan mana yang dipilih beserta alasannya:

PILIHAN A — Migrasi logic ke dalam `features/lesson/`:
  Pindahkan/adaptasi 14 renderer dari `lesson_engine/presentation/renderers/`
  (atau path sejenis) ke dalam `features/lesson/presentation/` sebagai
  varian render jenis soal, sehingga `lesson_screen.dart` bisa menampilkan
  semua 14 jenis soal tersebut DENGAN visual premium yang sudah ada
  (animated_stars, dll tetap terpakai di result_screen, dan kartu jawaban
  premium tetap terpakai untuk semua jenis soal).
  Demikian juga pindahkan logic stage/unit dari `learning_path/` agar
  `features/lesson/` tahu soal mana yang termasuk stage/unit mana.

PILIHAN B — `features/lesson/` memanggil renderer dari `lesson_engine/`:
  Alih-alih memindah kode, `lesson_screen.dart` mengimpor dan memakai
  langsung renderer-renderer dari `lesson_engine/` sebagai dependency,
  sehingga tidak perlu duplikasi kode, cukup hubungkan saja.

PILIHAN C (HANYA jika setelah dicek lebih lanjut justru `lesson_engine/`
  yang punya struktur data/provider lebih matang dan lebih mudah jadi basis):
  `features/lesson/` yang dimerge ke dalam `lesson_engine/` (kebalikan dari
  rencana awal) — TAPI pertahankan SEMUA widget premium yang sudah dibuat
  (animated_stars.dart, confetti_particles.dart, dst) dengan memindahkannya
  ke dalam struktur `lesson_engine/`.

Sebelum memilih, CEK DULU dan laporkan:
- Apakah `lesson_engine/` punya provider/state management (riverpod) yang
  sudah terhubung ke Hive/data real, atau masih dummy/mock?
- Apakah `features/lesson/` punya provider yang sudah terhubung ke data real?
- Mana yang struktur datanya (model soal, model progress) lebih mendekati
  kebutuhan app secara keseluruhan?

Laporkan pilihan (A/B/C) dan bukti pendukungnya SEBELUM eksekusi migrasi.

============================================================
VERIFIKASI WAJIB #2 — CEK KEMATANGAN NEW vs OLD (Home/Splash/Profile)
============================================================
Jangan langsung hapus versi OLD hanya karena ada versi NEW. Untuk MASING-MASING
pasangan duplikat ini:
- `home/presentation/home_screen.dart` (OLD) vs
  `home/presentation/screens/home_screen.dart` (NEW)
- `auth/presentation/splash_screen.dart` (OLD) vs
  `onboarding/presentation/screens/splash_screen.dart` (NEW)
- `profile/presentation/profile_screen.dart` (OLD) vs
  `profile/presentation/screens/profile_screen.dart` (NEW)

Cek dan laporkan dalam tabel:
| File | Terhubung ke provider/state real? | Terhubung ke Hive/data persist? | Lines of code | Ada TODO/placeholder/dummy data? |

JIKA ternyata versi OLD lebih lengkap secara fungsional (misal: OLD sudah
terhubung ke data real user progress, sementara NEW masih UI statis dengan
dummy data) — JANGAN dihapus. Sebaliknya: pertahankan LOGIC/STATE dari versi
yang lebih matang, tapi pertahankan VISUAL/UI dari versi yang lebih bagus
tampilannya. Gabungkan jika perlu (ambil state management dari yang satu,
pasang ke UI dari yang lain), jangan asal pilih berdasarkan "NEW vs OLD" saja.

Untuk `app_colors.dart` (core/theme/ vs app/theme/) — ini lebih sederhana,
cukup bandingkan isi keduanya, pilih yang palette-nya dipakai oleh
`features/lesson/` (karena itu yang jadi sistem aktif), pastikan SEMUA
screen lain (home, profile, dst) di-refactor untuk memakai 1 file warna
yang sama ini.

============================================================
EKSEKUSI (SETELAH 2 VERIFIKASI DI ATAS SELESAI DAN DILAPORKAN)
============================================================
1. Jalankan migrasi/integrasi sesuai pilihan yang sudah ditentukan di
   Verifikasi #1.
2. Satukan router: HANYA `core/router/app_router.dart` yang boleh ada,
   hapus `app/router/router.dart` dan `app/app.dart` SETELAH semua route
   pentingnya (yang mengarah ke `features/lesson/`, `lesson_engine/` punya
   logicnya, `learning_path/`) sudah dipindahkan masuk ke `app_router.dart`.
3. `main.dart` harus mengarah ke route awal yang akhirnya membawa user ke
   `features/lesson/lesson_screen.dart` (bukan `features/learning/learning_screen.dart`)
   untuk pengalaman belajar/quiz.
4. Hapus `features/learning/` HANYA setelah dikonfirmasi tidak ada logic
   unik yang belum termigrasi (cek dulu providernya, jangan asal hapus).
5. Untuk Home/Splash/Profile: eksekusi sesuai hasil Verifikasi #2 (gabungkan
   state+UI terbaik, bukan otomatis pilih NEW).
6. Satukan `app_colors.dart` dan `app_theme.dart` jadi satu masing-masing.
7. Update SEMUA import yang masih mengarah ke path yang dihapus/dipindah.

============================================================
VERIFIKASI AKHIR (WAJIB)
============================================================
1. `flutter analyze` — laporkan jumlah error/warning sebelum dan sesudah.
2. `flutter test` — laporkan jumlah test pass/fail sebelum dan sesudah.
3. `git status` dan `git diff --stat` — tampilkan daftar file yang
   diubah/dihapus/ditambah sebagai bukti perubahan benar-benar tersimpan.
4. KONFIRMASI APAKAH PERUBAHAN INI SUDAH DI-COMMIT (`git log -1`) DAN
   SUDAH DI-PUSH ke remote GitHub (`git status` harus menunjukkan
   "branch is up to date with origin/main" atau sejenisnya). Jika belum
   bisa push (misal karena tidak ada akses kredensial), JELASKAN SECARA
   EKSPLISIT bahwa perubahan ini HANYA ada di environment lokal dan belum
   tercermin di GitHub — jangan biarkan ini ambigu di laporan akhir.
5. Jalankan app dari awal (`flutter run` atau build APK) dan jelaskan
   secara konkret flow yang muncul: Splash mana yang muncul → Home mana →
   masuk lesson → jenis-jenis soal apa yang bisa muncul (apakah sudah
   termasuk 14 jenis dari lesson_engine, atau cuma jenis lama) → Result
   Screen versi mana yang muncul di akhir (harus versi premium).

============================================================
LARANGAN
============================================================
- JANGAN menghapus file yang punya logic/provider/state unik tanpa
  memverifikasi dulu isinya benar-benar teralihkan.
- JANGAN membuat sistem/router/folder paralel baru lagi.
- JANGAN melaporkan "selesai" tanpa bukti git diff/git log yang konkret.
