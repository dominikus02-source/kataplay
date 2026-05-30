# KATAPLAY — WORLD MAP DESIGN

**Senior World Designer:** Nintendo & Super Mario World Perspective
**Versi:** 1.0

---

## WORLD MAP OVERVIEW

### The KataPlay Archipelago

```
                      ┌───────────────────┐
                      │   🌙 KERAJAAN     │
                      │     BAHASA        │  ← Final World
                      │   ★★★★★ Boss     │
                      └────────┬──────────┘
                               │
    ┌───────────────┐         │         ┌───────────────────┐
    │   ⛰️ GUNUNG    │◄────────┼────────►│   🏖️ PANTAI      │
    │   KALIMAT     │         │         │   CERITA          │
    │   ★★★★       │                 │   ★★★            │
    └───────┬───────┘                 └────────┬──────────┘
            │                                  │
            │    ┌───────────────────┐         │
            └────►   🌿 KEBUN KATA  │◄────────┘
                 │   ★★             │
                 └────────┬─────────┘
                          │
                 ┌────────┴─────────┐
                 │   🏝️ PULAU HURUF  │  ← Starting World
                 │   ★               │
                 └──────────────────┘
```

### Map Design Philosophy

> *"Setiap world terlihat seperti tempat yang ingin anak kunjungi — bukan seperti pelajaran."*

### Navigation

| Interaction | Type | Notes |
|------------|------|-------|
| **Scroll** | Vertical & horizontal | Pannable, pinch-to-zoom |
| **Tap node** | Linear within world | Bisa backtrack |
| **Path** | Dotted line | #0F8B6F, 4px |
| **Locked world** | Gray + lock | "Selesaikan world sebelumnya!" |
| **Secret path** | Hidden | Easter egg — reward ekstra |

---

## WORLD 1: PULAU HURUF

### Profile

| Atribut | Detail |
|---------|--------|
| **Tema** | Tropical island — pantai, kelapa, pasir putih |
| **Warna dominan** | #60A5FA (biru), #FFD93D (kuning), #FFF8EC (cream) |
| **Skill fokus** | Mengenal huruf A-Z, fonik, huruf kapital & kecil |
| **Jumlah level** | 10 |
| **Boss** | Raksasa Huruf |
| **Reward utama** | Karakter Hazel |
| **Selesai di level** | Player Level 5 |

### Visual Theme

```
       ☀️☀️☀️
        ☁️  ☁️
    🌊🌊🌊🌊🌊🌊🌊          ← Laut biru
   🌴🌴      🌴🌴           ← Pohon kelapa
     🏖️🏖️🏖️🏖️🏖️           ← Pasir putih
      ┌──┐ ┌──┐ ┌──┐       ← Level nodes
      │A │→│B │→│C │       (berbentuk huruf)
      └──┘ └──┘ └──┘
        ↓    ↓    ↓
      ┌──┐ ┌──┐ ┌──┐
      │D │→│E │→│F │
      └──┘ └──┘ └──┘
```

### Level List

| Level | Nama | Mini-Game | Skill | Reward |
|-------|------|-----------|-------|--------|
| 1-1 | Pantai A | Letter Tracing | Mengenal A | 10 XP |
| 1-2 | Pasir B | Letter Pop | Bunyi B | 10 XP |
| 1-3 | Ombak C | Drag & Match | Huruf C | 15 XP |
| 1-4 | Pohon D | Letter Jump | Huruf D | 15 XP |
| 1-5 | Sinar E | Phonics Fun | Bunyi E | 20 XP + Stiker |
| 1-6 | Kepiting F | Memory Match | Huruf F | 20 XP |
| 1-7 | Bintang G | Letter Puzzle | Huruf G | 25 XP |
| 1-8 | Pelangi H | Sort & Match | Kapital/kecil | 25 XP |
| 1-9 | Langit I | Word Builder | 3-huruf kata | 30 XP |
| 1-10 | **Boss: Raksasa Huruf** | Boss Battle | Semua huruf | 100 XP + Hazel unlock |

### Enemies (Edukasi)

| Enemy | Visual | Teknik Mengalahkan |
|-------|--------|-------------------|
| **Huruf Nakal** | Huruf lari-lari | Tap huruf yang benar |
| **Bubble Salah** | Gelembung berisi huruf salah | Pecahkan gelembung |
| **Kepiting Kacau** | Kepiting mengocok huruf | Susun ulang |

### Boss: Raksasa Huruf

```
        ┌────────┐
        │  A B C │
        │  D E F │          ← Raksasa dari batu
        │  G H I │             dengan huruf di badan
        └────────┘
       ╱          ╲
      │  ┌────┐   │
      │  │ ●● │   │         ← Mata menyala
      │  └────┘   │
       ╲          ╱
        ╲────────╱
```

**Mekanisme Boss:**
1. Raksasa menunjukkan kombinasi huruf
2. Anak harus mengetuk huruf yang benar secara berurutan
3. 3 ronde, semakin cepat
4. Bonus: perfect streak → extra bintang

---

## WORLD 2: KEBUN KATA

### Profile

| Atribut | Detail |
|---------|--------|
| **Tema** | Garden — bunga, kupu-kupu, pohon buah |
| **Warna dominan** | #0F8B6F (hijau), #FF9F43 (orange), #FFB3B3 (pink) |
| **Skill fokus** | Kosakata dasar: hewan, buah, warna, angka |
| **Jumlah level** | 12 |
| **Boss** | Kumbang Kata |
| **Reward utama** | Karakter Alby |
| **Selesai di level** | Player Level 10 |

### Visual Theme

```
       🦋🦋🦋
     🌸🌺🌼🌻🌷          ← Taman bunga
   🌿🌿🌿🌿🌿🌿🌿       ← Tanaman
    ┌──┐   ┌──┐   ┌──┐
    │🍎│→  │🍊│→  │🍋│    ← Level berbentuk buah
    └──┘   └──┘   └──┘
      ↓     ↓     ↓
    ┌──┐   ┌──┐   ┌──┐
    │🍇│→  │🍓│→  │🍉│
    └──┘   └──┘   └──┘
       🐛🐛🐛🐛🐛
```

### Level List

| Level | Nama | Mini-Game | Skill | Reward |
|-------|------|-----------|-------|--------|
| 2-1 | Biji Ajaib | Word Match | Hewan (kucing, ikan) | 15 XP |
| 2-2 | Tunas Baru | Picture Match | Buah (apel, mangga) | 15 XP |
| 2-3 | Daun Pertama | Drag & Label | Sayur (wortel, bayam) | 20 XP |
| 2-4 | Bunga Mekar | Word Puzzle | Warna (merah, biru) | 20 XP |
| 2-5 | Lebah Rajin | Spelling Bee | Eja kata 3 huruf | 25 XP |
| 2-6 | Kupu-kupu | Memory Cards | Pasangan kata-gambar | 25 XP |
| 2-7 | Pohon Besar | Word Builder | Kata 4 huruf | 30 XP |
| 2-8 | Buah Jatuh | Catch & Spell | Buah & angka | 30 XP |
| 2-9 | Taman Rahasia | Hidden Words | Review semua | 35 XP |
| 2-10 | Gerbang Emas | Gate Challenge | Kata sifat (besar/kecil) | 35 XP |
| 2-11 | Labirin Bunga | Maze + Read | Kata kerja (makan/minum) | 40 XP |
| 2-12 | **Boss: Kumbang Kata** | Boss Battle | Semua kosakata | 150 XP + Alby |

### Boss: Kumbang Kata

**Mekanisme:**
1. Kumbang raksasa membawa kata
2. Anak memilih gambar yang sesuai dengan kata
3. 5 ronde, kata semakin panjang
4. Kumbang rewarded dengan animasi lucu

---

## WORLD 3: PANTAI CERITA

### Profile

| Atribut | Detail |
|---------|--------|
| **Tema** | Beach — pasir, ombak, kapal, harta karun |
| **Warna dominan** | #60A5FA (biru laut), #FFD93D (matahari), #FFF8EC |
| **Skill fokus** | Kalimat sederhana S-P-O |
| **Jumlah level** | 14 |
| **Boss** | Raja Ombak |
| **Reward utama** | Costume Zelby: Baju Bajak Laut |
| **Selesai di level** | Player Level 15 |

### Level List Sample

| Level | Nama | Skill |
|-------|------|-------|
| 3-1 | Botol Pesan | Membaca kata dalam kalimat |
| 3-2 | Kapal Kertas | S-P sederhana |
| 3-5 | Harta Karun | Kata kerja dalam kalimat |
| 3-8 | Pulau Misteri | Kalimat negatif |
| 3-10 | Ombak Besar | Kalimat tanya |
| 3-14 | **Boss: Raja Ombak** | Semua struktur kalimat |

---

## WORLD 4: GUNUNG KALIMAT

### Profile

| Atribut | Detail |
|---------|--------|
| **Tema** | Mountain — tebing, awan, salju, gua |
| **Warna dominan** | #8B5CF6 (ungu), #F5F3FF (putih) |
| **Skill fokus** | Struktur kalimat kompleks, kata hubung |
| **Jumlah level** | 16 |
| **Boss** | Naga Kalimat |
| **Reward** | Costume Hazel: Pendaki |
| **Level requirement** | Level 21 |

---

## WORLD 5: KERAJAAN BAHASA

### Profile

| Atribut | Detail |
|---------|--------|
| **Tema** | Castle — kastil, kristal, buku terbang |
| **Warna dominan** | #FF9F43 (keemasan), #8B5CF6 (ungu royal) |
| **Skill fokus** | Membaca cerita, menulis, grammar |
| **Jumlah level** | 20 |
| **Boss** | Penyihir Kata |
| **Reward** | Zelby costume: Ksatria |
| **Level requirement** | Level 30 |

---

## WORLD MAP DESIGN RULES

| # | Rule | Alasan |
|---|------|--------|
| 1 | **Linear within world, choice across worlds** | Anak bisa pilih world, tapi dalam world urut |
| 2 | **Progress visible** | Node selesai = berwarna, locked = abu |
| 3 | **Secret paths** | 1-2 per world — reward eksklusif |
| 4 | **Rest nodes** | Setiap 3 level ada "rest area" mini-game santai |
| 5 | **World completion = celebration** | Firework + reward screen setiap world selesai |
| 6 | **Boss visible from start** | Anak bisa lihat "musuh" dari awal — motivasi |

---

*END OF WORLD MAP DESIGN — CONFIDENTIAL*
