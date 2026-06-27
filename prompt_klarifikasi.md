# PROMPT OPENCODE — KLARIFIKASI WAJIB SEBELUM EKSEKUSI (Stop & Verify)

Laporan Verifikasi #1 dan #2 yang kamu berikan TIDAK SESUAI dengan kondisi
aktual repo setelah dicek ulang langsung dari GitHub. JANGAN eksekusi apapun
dulu. Perbaiki dulu audit di bawah ini dengan command yang BENAR-BENAR
dijalankan, jangan dari ingatan/asumsi laporan sebelumnya.

============================================================
KOREKSI #1 — Duplikat home_screen.dart MASIH ADA
============================================================
Kamu melaporkan "tidak ada duplikat, home_screen.dart hanya ada satu di
features/home/presentation/screens/home_screen.dart".

FAKTA: kedua file ini SAMA-SAMA ADA secara fisik di repo:
- lib/features/home/presentation/home_screen.dart
- lib/features/home/presentation/screens/home_screen.dart

Jalankan ulang:
  find lib/features/home -iname "*home_screen*"

dan konfirmasi keduanya ada. Lakukan audit yang SAMA (cek fisik file dengan
`find`, bukan dari memori) untuk SplashScreen dan ProfileScreen juga —
laporan sebelumnya soal ini kemungkinan juga keliru. Jalankan:
  find lib -iname "*splash_screen*"
  find lib/features/profile -iname "*profile_screen*"

Laporkan ulang tabel duplikat dengan hasil yang BENAR-BENAR dari command ini.

============================================================
KOREKSI #2 — learning_path/ TIDAK live, ini KONTRADIKSI dengan klaimmu sendiri
============================================================
Kamu melaporkan: "learning_path/ already navigates to both systems... 
Navigates to /lesson-engine for curriculum-based lessons (the primary path)"
— ini menyiratkan learning_path/lesson_engine adalah jalur yang AKTIF/utama.

FAKTA setelah dicek: rute `/learning-path` dan `/lesson-engine` HANYA
terdaftar di `lib/app/router/router.dart` — router yang TIDAK dipanggil
dari `main.dart` (dead route, sama seperti temuan Audit A.1 sebelumnya).
Router yang AKTIF (`lib/core/router/app_router.dart`, dipanggil main.dart)
TIDAK memiliki rute `/learning-path` maupun `/lesson-engine` sama sekali —
hanya ada `/learning` (mengarah ke features/learning/ yang LAMA).

Selain itu, ditemukan bahwa home_screen.dart versi `screens/` (yang kamu
sebut "the only one") justru memanggil `context.go('/learning-path')` —
padahal versi home_screen.dart yang BENAR-BENAR terpasang di router aktif
adalah versi yang LAIN (non-screens), yang TIDAK memanggil /learning-path
sama sekali.

Ini berarti: home_screen.dart versi "screens/" yang kamu anggap sebagai
satu-satunya/yang dipertahankan, JUSTRU adalah versi yang TIDAK terpasang
di router aktif. Tolong jelaskan kontradiksi ini:
1. Jalankan: grep -n "home_screen" lib/core/router/app_router.dart
   (router AKTIF) — file home_screen mana yang sebenarnya diimpor di sini?
2. Jalankan: grep -n "home_screen" lib/app/router/router.dart
   (router DEAD) — file home_screen mana yang diimpor di sini?
3. Konfirmasi ulang: yang dipanggil dari main.dart via app_router.dart itu
   home_screen versi mana? Apakah versi ini punya UI yang lebih lama/polos
   dibanding versi screens/, ATAU apakah dia juga sudah cukup baik?

============================================================
SETELAH KOREKSI #1 DAN #2 — TENTUKAN ULANG STRATEGI
============================================================
Dengan fakta bahwa SEMUA hal berikut hanya hidup di router yang dead
(app/router/router.dart, tidak dipanggil main.dart):
- features/lesson/ (result_screen premium)
- features/lesson_engine/ (14 renderer)
- features/learning_path/ (stage/unit progression)
- home_screen.dart versi screens/
- splash_screen.dart versi onboarding/screens/ (jika benar duplikat)
- profile_screen.dart versi screens/ (jika benar duplikat)

Sementara yang AKTIF di main.dart (via core/router/app_router.dart) adalah
versi-versi LAMA dari semuanya.

Ini mengindikasikan kemungkinan besar: app/router/router.dart + app/app.dart
adalah hasil kerja/iterasi yang LEBIH BARU dan LEBIH LENGKAP, yang belum
pernah benar-benar "dipasang" sebagai entry point aktif. Dengan kata lain,
kemungkinan strategi yang lebih tepat BUKAN "pertahankan core/router/app_router.dart
sebagai basis dan migrasi sebagian dari sisi lain ke dalamnya" — TAPI malah
SEBALIKNYA: jadikan app/router/router.dart (atau hasil gabungannya) yang
dipanggil dari main.dart, karena di situ kumpulan fitur baru/premium yang
sudah saling terhubung (home screens/ → learning-path → lesson-engine,
dan juga ada jalur ke features/lesson/).

TUGAS:
1. Buka dan baca ISI LENGKAP `lib/app/router/router.dart` — daftar semua
   rute di dalamnya, dan screen apa saja yang terhubung satu sama lain
   secara konsisten (apakah home versi screens/ → learning-path →
   lesson-engine → lesson_completion_screen itu satu rangkaian yang utuh
   dan jalan, ATAU ada lagi yang putus di tengah?).
2. Cek apakah ada rute ke `features/lesson/lesson_screen.dart` DARI DALAM
   router yang sama ini juga (app/router/router.dart) — supaya tahu apakah
   rangkaian home(screens/) → learning-path → lesson-engine, DAN
   rute ke features/lesson/ result_screen premium, BISA digabung di SATU
   router yang sama tanpa konflik.
3. Laporkan: jika app/router/router.dart dijadikan basis utama (bukan
   core/router/app_router.dart), apa saja yang HILANG/PERLU DIPINDAHKAN
   dari core/router/app_router.dart (cek dulu rute apa saja yang ADA di
   app_router.dart tapi TIDAK ADA di app/router/router.dart — misalnya
   /game/matching, /reward, /koleksi, /setelan, dll — pastikan tidak ada
   yang tercecer).
4. JANGAN ubah apapun dulu. Cukup laporkan hasil temuan 1-3 di atas dalam
   bentuk tabel perbandingan rute lengkap antara kedua router, supaya bisa
   diputuskan bersama mana yang benar-benar jadi basis final sebelum
   eksekusi penghapusan/penggabungan dimulai.

============================================================
ATURAN
============================================================
- SETIAP klaim ("file ini ada/tidak ada", "rute ini aktif/tidak") HARUS
  disertai output command (find/grep) yang benar-benar dijalankan saat ini,
  jangan mengulang dari laporan sebelumnya.
- Jangan eksekusi perubahan apapun pada tahap ini — ini PURE audit ulang.
