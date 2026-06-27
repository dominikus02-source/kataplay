# PROMPT OPENCODE — KOREKSI DOKUMENTASI + QA END-TO-END MENYELURUH

Tahap B (haptic, shake, shimmer loading, integrasi 18 jenis soal) sudah
dikonfirmasi BEKERJA secara kode (diverifikasi independen lewat pembacaan
source code langsung). Namun ditemukan 2 hal yang perlu ditindaklanjuti
sebelum dianggap benar-benar tuntas:

============================================================
BAGIAN 1 — KOREKSI NAMA JENIS SOAL DI LAPORAN/DOKUMENTASI
============================================================
Tabel verifikasi 18 jenis soal yang dilaporkan sebelumnya memakai nama-nama
yang TIDAK COCOK dengan `enum LessonType` yang sebenarnya ada di
`lib/features/lesson/domain/lesson.dart`. Contoh ketidakcocokan:

Nama di laporan (SALAH)      →  Nama sebenarnya di enum
multipleChoice                →  imageChoice / wordChoice (tidak ada "multipleChoice")
pictureChoose                 →  tidak ada nama ini di enum
voiceRepeat                   →  tidak ada nama ini di enum (mungkin maksudnya recordVoice?)
cocokKata                     →  matching atau matchPair (nama Indonesia tidak ada di enum)

TUGAS:
1. Jalankan: grep -A 20 "enum LessonType" lib/features/lesson/domain/lesson.dart
   dan SALIN PERSIS 18 nama yang keluar dari command ini (jangan dari ingatan).
2. Buat ULANG tabel verifikasi dengan 18 nama yang BENAR sesuai hasil command
   di atas. Untuk SETIAP jenis soal, isi ulang kolom Haptic/Shake/Transition/
   Bottom/Streak dengan hasil pengecekan yang BENAR-BENAR dijalankan saat ini
   (bukan disalin dari laporan sebelumnya), termasuk cantumkan file renderer
   spesifik yang menangani jenis soal tersebut (contoh: "matchPair →
   ditangani oleh lib/features/lesson_engine/presentation/renderers/match_pair_renderer.dart").
3. Jika ada jenis soal yang TERNYATA belum punya renderer/handler yang jelas
   (cek dengan grep nama enum tersebut di seluruh lib/features/lesson_engine/
   dan lib/features/lesson/), laporkan secara eksplisit sebagai GAP, jangan
   ditandai centang hijau begitu saja.

============================================================
BAGIAN 2 — QA END-TO-END MANUAL (WAJIB, INI YANG BELUM PERNAH DIBUKTIKAN)
============================================================
Semua verifikasi sejauh ini berbasis pembacaan kode (grep/static check).
BELUM ADA satupun bukti konkret bahwa app benar-benar BISA DIJALANKAN tanpa
crash untuk SEMUA 18 jenis soal di device/emulator sungguhan. Kerjakan:

1. Jalankan `flutter run` (debug mode) di emulator atau device fisik.
2. Untuk SETIAP dari 18 jenis soal (nama yang benar dari Bagian 1), buat
   atau temukan minimal 1 soal sample dari jenis tersebut dalam data yang
   ada, lalu mainkan secara manual sampai submit jawaban (benar DAN salah,
   coba keduanya jika sempat) dan catat:
   - Apakah render TANPA error/exception di console?
   - Apakah shake+haptic terasa/muncul saat jawaban salah?
   - Apakah transisi ke soal berikutnya berjalan smooth (tidak ada freeze)?
   - Screenshot SETIAP jenis soal (atau screen recording singkat) sebagai
     bukti visual, bukan cuma klaim teks.
3. Khusus untuk recordVoice dan speakingPractice — ini kemungkinan butuh
   permission microphone. Cek apakah app crash/error jika permission
   ditolak, dan apakah ada fallback yang manusiawi (bukan crash).
4. Mainkan SATU lesson penuh dari awal sampai akhir (idealnya campuran
   beberapa jenis soal berbeda dalam 1 sesi, bukan cuma 1 jenis berulang)
   sampai ke Result Screen, pastikan:
   - Confetti muncul jika skor sempurna
   - Animated stars, gradient text, XP counter semuanya jalan
   - Tombol "Lanjut" berfungsi kembali ke Home/learning path
5. Jika DITEMUKAN bug/crash pada jenis soal manapun selama testing manual
   ini — JANGAN langsung diperbaiki dengan workaround cepat. Laporkan dulu:
   jenis soal mana, error message/stack trace lengkap, dan kemungkinan
   akar masalahnya, sebelum melakukan perbaikan.

============================================================
BAGIAN 3 — PERFORMANCE PROFILING (BELUM PERNAH DIUKUR NYATA)
============================================================
Sejauh ini target "60fps" hanya disebutkan sebagai guardrail, belum pernah
diukur dengan bukti konkret. Jalankan:
1. `flutter run --profile`
2. Buka Flutter DevTools, rekam frame rendering saat:
   - Transisi antar soal (untuk minimal 3 jenis soal berbeda)
   - Saat shake animation trigger (jawaban salah)
   - Saat Result Screen muncul dengan confetti (skor sempurna)
3. Laporkan FPS rata-rata dan apakah ada frame yang "janky" (>16ms render
   time) di momen-momen tersebut. Screenshot DevTools timeline jika bisa.

============================================================
LAPORAN AKHIR YANG DIHARAPKAN
============================================================
1. Tabel 18 jenis soal dengan nama BENAR + status QA manual (bukan cuma
   grep) untuk masing-masing.
2. Daftar bug/error yang ditemukan saat testing manual (jika ada), dengan
   detail cukup untuk diperbaiki di prompt selanjutnya.
3. Hasil profiling FPS dengan bukti (angka/screenshot DevTools).
4. `git add -A && git commit -m "..." && git push origin main` — jalankan
   sendiri, tampilkan `git log -1 --oneline` setelahnya sebagai bukti.

============================================================
ATURAN
============================================================
- Klaim apapun di laporan ("berfungsi", "tidak ada error") harus berdasarkan
  testing yang BENAR-BENAR dijalankan barusan, bukan asumsi dari hasil
  flutter analyze/test yang sifatnya statis.
- Jika sebuah jenis soal tidak sempat ditest manual karena alasan teknis
  (misal: butuh asset/data yang tidak tersedia), laporkan dengan jujur
  sebagai "belum tertest" — jangan ditandai selesai.
