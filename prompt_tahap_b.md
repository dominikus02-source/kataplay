# PROMPT OPENCODE — TAHAP B: POLISH FINAL LEARNING/QUIZ SCREEN

Tahap A (konsolidasi arsitektur) sudah TUNTAS dan terverifikasi:
- Satu router aktif, satu jalur lesson (features/lesson/) dengan 14 jenis
  soal dari lesson_engine sudah terintegrasi via bridge layer
- SegmentedProgressBar, StreakIndicator, QuestionTransitionWrapper,
  AnswerOptionCard sudah terpasang dan dipakai nyata di lesson_screen.dart

Audit kode terbaru menemukan kondisi SPESIFIK berikut — kerjakan HANYA
gap yang disebutkan di bawah, JANGAN bangun ulang yang sudah berfungsi.

============================================================
TEMUAN: DEAD CODE WIDGET (cek dulu, jangan asal hapus)
============================================================
3 file widget berikut DIBUAT tapi TIDAK dipanggil di manapun dalam codebase
(dikonfirmasi via grep, tidak ada satupun pemanggilan):
- lib/features/lesson/presentation/widgets/answer_button.dart
- lib/features/lesson/presentation/widgets/lesson_feedback_panel.dart
- lib/features/lesson/presentation/widgets/shimmer_loading.dart

Untuk SETIAP file ini:
1. Baca isinya dulu — apakah fungsinya sudah benar-benar tergantikan oleh
   widget lain yang sekarang dipakai (misal: answer_button.dart mungkin
   versi lama sebelum answer_option_card.dart), ATAU apakah ini fitur
   yang seharusnya dipakai tapi terlewat saat integrasi?
2. JIKA tergantikan sepenuhnya → hapus filenya (kecuali shimmer_loading,
   lihat instruksi B.3 di bawah — itu HARUS dipakai, bukan dihapus).
3. JIKA punya fungsi unik yang belum tercover → integrasikan ke tempat
   yang sesuai.
Laporkan keputusan untuk masing-masing 3 file ini.

============================================================
B.1 — HAPTIC FEEDBACK (BELUM ADA SAMA SEKALI)
============================================================
Dikonfirmasi: tidak ada satupun pemanggilan `HapticFeedback` di
lesson_screen.dart maupun answer_option_card.dart. Tambahkan:
- `HapticFeedback.lightImpact()` saat user pilih jawaban BENAR
  (panggil bersamaan dengan animasi checkmark/scale-bounce yang sudah ada
  di answer_option_card.dart)
- `HapticFeedback.mediumImpact()` saat user pilih jawaban SALAH
  (panggil bersamaan dengan shake animation yang sudah ada — cukup
  tambahkan baris pemanggilan haptic di trigger yang sama dengan
  `_shakeController.forward(from: 0)`)
- `HapticFeedback.selectionClick()` (ringan) saat user TAP memilih opsi
  jawaban sebelum submit (state "selected", belum tahu benar/salah)
- Pastikan import `package:flutter/services.dart` ditambahkan jika belum ada

============================================================
B.2 — SHAKE ANIMATION UNTUK 14 JENIS SOAL BARU (lesson_engine)
============================================================
Shake + haptic feedback yang ada di `answer_option_card.dart` saat ini
HANYA dipakai untuk jalur 7 jenis soal lama (yang dirender via
AnswerOptionCard langsung). Untuk 14 jenis soal yang dirender lewat bridge
ke `lesson_engine` renderers (listen_choose_renderer.dart,
picture_choice_renderer.dart, match_pair_renderer.dart, dst):
1. Cek SETIAP renderer di lib/features/lesson_engine/presentation/renderers/
   — apakah mereka punya feedback visual sendiri untuk jawaban benar/salah
   (shake, color change, dst), atau masih polos/minimal?
2. Untuk renderer yang masih polos: tambahkan SHAKE ANIMATION dan HAPTIC
   FEEDBACK yang KONSISTEN dengan yang ada di answer_option_card.dart
   (gunakan curve dan durasi yang sama agar terasa seragam di seluruh app).
   Pertimbangkan ekstrak logic shake jadi mixin/widget reusable
   (misal `ShakeAnimationMixin` atau `ShakeWrapper` widget) supaya tidak
   copy-paste kode shake controller 14 kali — taruh di
   `lib/features/lesson/presentation/widgets/shake_wrapper.dart` dan pakai
   di semua renderer yang butuh.
3. Pastikan auto-highlight jawaban benar (warna hijau otomatis muncul di
   opsi yang benar) saat user salah pilih — ini berlaku untuk SEMUA 14
   jenis soal yang formatnya pilihan (imageChoice, wordChoice, pictureChoice,
   listenChoose, sentenceChoice, matching, matchPair, dst). Untuk jenis soal
   yang bukan pilihan (recordVoice, speakingPractice, storyReading,
   readingComprehension) — sesuaikan feedback-nya (tidak perlu highlight
   opsi, tapi tetap perlu indikasi visual benar/salah yang jelas).

============================================================
B.3 — SHIMMER LOADING (SUDAH DIBUAT, BELUM DIPAKAI)
============================================================
`shimmer_loading.dart` sudah ada sebagai widget tapi TIDAK dipanggil di
manapun. Cari di lesson_screen.dart (dan lesson_shell.dart jika relevan)
titik mana yang sekarang menampilkan loading state saat soal/data sedang
di-fetch (kemungkinan masih `CircularProgressIndicator` default atau
state kosong). Ganti dengan `ShimmerLoading` widget yang sudah dibuat.

============================================================
B.4 — TRANSISI ANTAR SOAL: VERIFIKASI KONSISTENSI UNTUK 14 JENIS BARU
============================================================
`QuestionTransitionWrapper` sudah dipasang di lesson_screen.dart untuk
transisi soal. Pastikan transisi ini SECARA KONSISTEN membungkus SEMUA
jenis soal, termasuk 14 jenis yang dirender via bridge ke lesson_engine
(cek apakah `_buildAnswerArea` atau method serupa yang dispatch ke 14
renderer itu tetap berada DI DALAM `QuestionTransitionWrapper`, atau
apakah ada jalur render yang lolos/skip wrapper ini).

============================================================
B.5 — BOTTOM ACTION BUTTON: VERIFIKASI STATE TRANSITION
============================================================
Cek `lesson_bottom_action.dart` (sudah ada) — pastikan:
- Disabled state (abu-abu) sebelum user pilih jawaban, untuk SEMUA 14
  jenis soal baru juga (bukan cuma 7 jenis lama) — beberapa jenis soal
  baru seperti recordVoice/speakingPractice mungkin perlu logic berbeda
  untuk menentukan kapan "jawaban sudah dipilih" (misal: rekaman sudah
  selesai direkam).
- Cross-fade dari "Periksa" ke "Lanjut" sudah smooth (cek implementasi
  AnimatedSwitcher atau sejenisnya ada di sini).

============================================================
B.6 — STREAK INDICATOR: VERIFIKASI DATA REAL
============================================================
`StreakIndicator` sudah terpasang. Cek apakah nilai streak yang ditampilkan
benar-benar dihitung dari jawaban benar berturut-turut SESUNGGUHNYA (state
di learning_provider/lesson controller), atau ada kemungkinan nilainya
dummy/placeholder. Laporkan hasil cek ini.

============================================================
B.7 — POLISH TAMBAHAN (jika waktu memungkinkan, prioritas rendah)
============================================================
- Tombol close (X) di lesson_top_bar.dart: pastikan dialog konfirmasi
  keluar pakai animasi scale+fade custom, bukan AlertDialog default Flutter.
- Pastikan `const` widget dipakai di tempat yang memungkinkan pada
  lesson_screen.dart dan renderer-renderer lesson_engine (performance).

============================================================
GUARDRAIL PERFORMA (WAJIB, SAMA SEPERTI SEBELUMNYA)
============================================================
- Background Learning/Quiz screen TETAP netral (putih/light grey) —
  JANGAN tambahkan gradient ramai di sini, itu khusus Result Screen.
- Efek partikel/shake apapun yang terjadi BERULANG per soal: ringan,
  jangan sampai bikin jank. Test dengan `flutter run --profile` khususnya
  saat transisi antar 14 jenis soal yang baru diintegrasikan.

============================================================
VERIFIKASI AKHIR (WAJIB)
============================================================
1. `flutter analyze` — laporkan error/warning sebelum & sesudah.
2. `flutter test` — laporkan pass/fail. Tambahkan widget test untuk
   `ShakeWrapper`/shake mixin baru (jika dibuat) dan untuk minimal 2
   renderer dari lesson_engine yang sudah ditambahkan haptic+shake.
3. `git add -A && git commit -m "..." && git push origin main` — JALANKAN
   SENDIRI langkah ini sampai selesai (jangan hanya menyarankan), lalu
   tampilkan output `git log -1 --oneline` dan `git status` setelah push
   sebagai bukti konkret.
4. Jalankan app dari awal, test minimal 3 jenis soal dari kelompok 14 yang
   baru (misal: listenChoose, matchPair, storyReading) untuk konfirmasi
   shake+haptic+transisi bekerja konsisten dengan 7 jenis soal lama.
5. Laporkan tabel: [Jenis soal] | [Shake+haptic ada?] | [Transisi konsisten?]
   | [Auto-highlight jawaban benar jika salah, ada?] — untuk SEMUA 18 jenis
   soal di enum LessonType saat ini.

============================================================
ATURAN
============================================================
- JANGAN buat widget/file baru jika fungsinya sudah ada di salah satu dari
  17 file widget yang sudah ada di lib/features/lesson/presentation/widgets/.
- WAJIB commit dan push sendiri di akhir — jangan berhenti di "siap di-commit".
