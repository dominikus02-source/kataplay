# KATAPLAY — GAME DESIGN DOCUMENT

**Lead Game Designer:** Duolingo, Lingokids, Pokémon, Candy Crush, Super Mario World
**Versi:** 1.0
**Target:** Anak 4-10 tahun

---

## 1. CORE GAMEPLAY

### Genre Definition

KataPlay adalah **Adventure Learning Game** — perpaduan antara:

| Genre | Inspirasi | Persentase |
|-------|-----------|-----------|
| **Adventure / Exploration** | Super Mario World | 35% |
| **Educational Puzzle** | Duolingo / Lingokids | 35% |
| **Collection RPG** | Pokémon | 20% |
| **Match / Candy Crush** | Candy Crush (reward loop) | 10% |

### Satu Kalimat Gameplay

> *"Anak menjelajahi dunia, menyelesaikan misi belajar, mengoleksi karakter, dan naik level — tanpa sadar sedang belajar Bahasa Indonesia."*

### Core Interaction Model

```
┌─────────────────────────────────────────────┐
│                                             │
│   EXPLORE → DISCOVER → PLAY → LEARN →       │
│   COLLECT → PROGRESS → REPEAT               │
│                                             │
└─────────────────────────────────────────────┘
```

| Tahap | Aktivitas Anak | Mekanisme Game |
|-------|---------------|----------------|
| **Explore** | Tap peta, pilih world, jalan ke node | Side-scroll atau point-and-click map |
| **Discover** | Temukan quest, item, karakter baru | Random encounter, hidden item |
| **Play** | Mainkan mini-game | Puzzle, drag-drop, match, tracing |
| **Learn** | Serap materi bahasa secara natural | Contextual learning in gameplay |
| **Collect** | Dapat bintang, koin, stiker, karakter | Reward screen + animation |
| **Progress** | Level naik, world baru terbuka | XP bar, level up celebration |

---

## 2. CORE LOOP

### The 15-Minute Daily Session

```
            ┌───────────────────┐
            │  BUKA APP         │  (5 detik - splash)
            └────────┬──────────┘
                     ▼
            ┌───────────────────┐
            │  HOME SCREEN      │  (Lihat streak, quest)
            └────────┬──────────┘
                     ▼
            ┌───────────────────┐
     ┌──────┤  DAILY QUEST      │◄──── 2-3 menit
     │      └────────┬──────────┘
     │               ▼
     │      ┌───────────────────┐
     │      │  MINI-GAME (1-2)  │◄──── 5-8 menit
     │      └────────┬──────────┘
     │               ▼
     │      ┌───────────────────┐
     │      │  STORY PROGRESS   │◄──── 3-5 menit
     │      └────────┬──────────┘
     │               ▼
     │      ┌───────────────────┐
     │      │  REWARD + COLLECT │◄──── 1-2 menit
     │      └────────┬──────────┘
     │               ▼
     │      ┌───────────────────┐
     └──────┤  RETURN TOMORROW  │
            └───────────────────┘
```

### Time Budget per Session

| Aktivitas | Waktu | Persentase |
|-----------|-------|-----------|
| Login + Streak | 30 detik | 3% |
| Daily Quest | 2 menit | 13% |
| Mini-Game (×2) | 6 menit | 40% |
| Story / Exploration | 4 menit | 27% |
| Reward + Collection | 1.5 menit | 10% |
| Navigation + Loading | 1 menit | 7% |
| **Total** | **~15 menit** | **100%** |

### Session Frequency Target

| Usia | Recommended | Max |
|------|------------|-----|
| 4-5 tahun | 1 session/hari (15 menit) | 20 menit |
| 6-7 tahun | 1-2 session/hari | 30 menit |
| 8-10 tahun | 2 session/hari | 40 menit |

---

## 3. META LOOP

### The Long-Term Progression

```
SESI HARIAN                           MINGGUAN                           BULANAN
┌──────────────┐              ┌──────────────────┐              ┌──────────────────────┐
│  Daily Quest │              │  Weekly Boss     │              │  Monthly Event       │
│  Mini-Games  │──────►       │  World Progress   │──────►       │  Limited Characters   │
│  XP + Coins  │              │  Character Growth │              │  Seasonal World       │
│  Streak       │              │  Badge System     │              │  Leaderboard (friendly)│
└──────────────┘              └──────────────────┘              └──────────────────────┘
       │                              │                                  │
       ▼                              ▼                                  ▼
  Short-term dopamine           Medium-term satisfaction          Long-term engagement
  (hari ini senang)             (minggu ini berkembang)           (bulan ini petualangan)
```

### Meta Loop Drivers

| Driver | Mekanisme | Frekuensi |
|--------|-----------|-----------|
| **Daily Streak** | Login streak → reward | Harian |
| **Quest Completion** | Selesaikan quest → XP + item | Harian |
| **Level Up** | Kumpulkan XP → level baru | 2-3 hari |
| **World Unlock** | Selesaikan world → world baru | 1-2 minggu |
| **Character Unlock** | Koleksi bintang → karakter baru | 1-4 minggu |
| **Seasonal Event** | Event khusus → limited items | Bulanan |
| **Mastery** | Kuasai semua mini-game → badge | Permanen |

---

## 4. WORLD STRUCTURE

### 5 Worlds + Finale

| World | Tema | Level | Boss | Skill Fokus |
|-------|------|-------|------|-------------|
| **1. Pulau Huruf** | Tropical island | 10 | Raksasa Huruf | Fonik, alfabet |
| **2. Kebun Kata** | Garden | 12 | Kumbang Kata | Kosakata dasar |
| **3. Pantai Cerita** | Beach | 14 | Raja Ombak | Kalimat sederhana |
| **4. Gunung Kalimat** | Mountain | 16 | Naga Kalimat | Struktur kalimat |
| **5. Kerajaan Bahasa** | Castle | 20 | Penyihir Kata | Membaca & menulis |
| **Finale** | Moon | 5 | Naga Terbang | Semua skill |
| **Total** | | **77** | **6 Bosses** | |

*Detail world ada di dokumen terpisah: 02_World_Map_Design.md*

---

## 5. PROGRESSION SYSTEM

### Progression Pillars

| Pillar | Apa yang Naik | Efek |
|--------|--------------|------|
| **Player Level** | Level akun (1-100) | Unlock fitur, world, karakter |
| **World Progress** | Persentase per world | Unlock world berikutnya |
| **Character Level** | Level Zelby/Hazel/Alby | Skill pasif, costume |
| **Mastery Score** | Per kategori kata | Badge, achievement |
| **Streak** | Hari berturut-turut | Reward eksklusif |

### Player Level Table (1-30)

| Level | XP Needed | Total XP | Unlock |
|-------|-----------|----------|--------|
| 1 | 0 | 0 | Mulai |
| 2 | 50 | 50 | Daily Quest |
| 3 | 80 | 130 | Pulau Huruf Level 4 |
| 4 | 120 | 250 | Mini-game baru |
| 5 | 180 | 430 | Karakter Hazel |
| 6 | 240 | 670 | - |
| 7 | 320 | 990 | World 2: Kebun Kata |
| 8 | 400 | 1390 | Mini-game baru |
| 9 | 500 | 1890 | - |
| 10 | 600 | 2490 | Karakter Alby |
| 11 | 750 | 3240 | Costume Zelby |
| 12 | 900 | 4140 | World 3 |
| 13 | 1100 | 5240 | - |
| 14 | 1300 | 6540 | Mini-game baru |
| 15 | 1500 | 8040 | Boss Rush mode |
| 16-20 | +500/level | ~13000 | World 4 |
| 21-25 | +750/level | ~20740 | Costume Hazel |
| 26-30 | +1000/level | ~30740 | World 5 |

### XP Sources

| Sumber | XP | Frekuensi |
|--------|-----|-----------|
| Mini-game selesai | 10-30 | Per game |
| Mini-game perfect score | +10 bonus | Per game |
| Daily quest | 50-100 | Harian |
| Streak bonus | 20-200 | Harian |
| Boss defeated | 100-300 | Per world |
| Achievement | 50-500 | Sekali |
| First win of day | 2x multiplier | Harian |

---

## 6. REWARD ECONOMY

### Currency Types

| Currency | Icon | Fungsi | Didapat dari |
|----------|------|--------|-------------|
| **Bintang** | ⭐ | Unlock world, karakter | Mini-game, quest |
| **Koin** | 🪙 | Beli item, costume | Mini-game, streak |
| **XP** | 📈 | Naik level | Semua aktivitas |
| **Stiker** | 🏷️ | Koleksi, hiasan | Event, achievement |
| **Badge** | 🏅 | Prestasi permanen | Milestone |

*Detail ekonomi ada di dokumen terpisah: 05_Reward_Economy.md*

---

## 7. DIFFICULTY CURVE

### Curve Design Principle

> *"Easy to learn, hard to master — but never frustrating."*

```
Difficulty
    ▲
    │                                    ╱
    │                                 ╱
    │                             ╱         ← Zone of proximal
    │                          ╱               development
    │                      ╱
    │                  ╱
    │              ╱
    │          ╱
    │      ╱
    │  ╱
    └─────────────────────────────────────────► Level
       1  2  3  4  5  6  7  8  9  10  11  12

    ── Optimal difficulty (challenging but achievable)
    ╴╴ Frustration zone (avoid)
    ╴╴ Boredom zone (avoid)
```

### Difficulty Factors

| Factor | Early Game (1-20) | Mid Game (21-60) | Late Game (61-100) |
|--------|------------------|------------------|--------------------|
| **Word length** | 2-3 huruf | 4-6 huruf | 6+ huruf |
| **Sentence length** | 2-3 kata | 4-6 kata | 7+ kata |
| **Timer** | No timer | 30 detik | 15 detik |
| **Choices** | 2 pilihan | 3-4 pilihan | 4-5 pilihan |
| **New mechanic** | Setiap 3 level | Setiap 5 level | Setiap 8 level |
| **Hint availability** | Always | After 5s wrong | After 10s wrong |

### Adaptive Difficulty

Sistem akan mendeteksi dan menyesuaikan:

| Skenario | Adjust |
|----------|--------|
| Anak menjawab benar 3x berturut-turut | Naik kesulitan +1 |
| Anak salah 2x berturut-turut | Turun kesulitan -1 |
| Anak idel 5 detik | Muncul hint |
| Anak main di atas 20 menit | Offer break + reward |

---

## 8. LEARNING CURVE

### Skill Progression

```
Level 1-20: FONIK & HURUF
  └── Mengenal huruf A-Z, bunyi huruf, huruf kapital & kecil

Level 21-40: KOSAKATA DASAR
  └── Kata benda (hewan, buah, warna, angka), kata kerja dasar

Level 41-60: KALIMAT SEDERHANA
  └── S-P-O, kalimat positif, negatif, tanya

Level 61-80: MEMBACA & MENULIS
  └── Paragraf pendek, cerita 2-3 kalimat, menulis kata

Level 81-100: MAHIR
  └── Cerita panjang, pemahaman, menulis kalimat sendiri
```

---

## 9. PLAYER MOTIVATION

### The 7 Motivators for Kids

| # | Motivator | Mekanisme | Contoh |
|---|-----------|-----------|--------|
| 1 | **Rasa Ingin Tahu** | Dunia tersembunyi, cliffhanger | "Apa yang ada di balik gunung?" |
| 2 | **Collection** | Karakter, stiker, badge | "Kumpulkan semua karakter!" |
| 3 | **Achievement** | Trophy, level up | "Level 10! Keren!" |
| 4 | **Story** | Narrative progression | "Lanjutkan cerita Zelby." |
| 5 | **Mastery** | Perfect score, 3 bintang | "Dapat 3 bintang di semua level!" |
| 6 | **Social (light)** | Bandingkan dengan teman | "Temanmu sudah di world 3!" |
| 7 | **Autonomy** | Pilih world, pilih game | "Mau main apa hari ini?" |

### What NOT to Use

| ❌ Jangan | Alasan |
|-----------|--------|
| Competitive leaderboard | Anak bisa stres |
| PvP (player vs player) | Tidak sesuai target usia |
| Pay-to-win | Tidak etis untuk anak |
| Loot box / gacha | Predatory mechanics |
| Hard fail state | Anak kecil mudah frustrasi |
| Time pressure (early) | Anxiety untuk pembaca pemula |

---

## 10. SESSION DESIGN

### Session Type 1: Daily Habit (15 min)

```
0:00 - Buka app, streak animation, daily reward
0:30 - Daily quest muncul (3 misi kecil)
2:00 - Mini-game 1: Review (materi kemarin)
4:30 - Mini-game 2: New material
7:00 - Story beat: cerita lanjutan
10:00 - Mini-game 3: Challenge
12:30 - Reward screen: XP, koin, item
14:00 - "Sampai besok, ya!" dari Zelby
```

### Session Type 2: Weekend Deep Dive (30 min)

```
0:00 - Buka app, streak bonus besar
1:00 - Weekly boss try
3:00 - Boss battle (5-7 menit)
10:00 - Reward besar
12:00 - World exploration (free play)
18:00 - Side quest / achievement hunting
25:00 - Shop / customization
28:00 - "Petualangan seru banget!"
```

### Session Type 3: Quick Check-in (5 min)

```
0:00 - Buka app
0:30 - Streak reward
1:00 - 1 mini-game cepat
3:00 - Daily quest claim
4:00 - "Besok main lagi, ya!"
```

---

## 11. RETENTION SYSTEM

### Daily Retention Mechanics

| Mekanisme | Psikologi | Day Impact |
|-----------|-----------|-----------|
| **Streak counter** | "Jangan putus!" | D1→D7 +35% |
| **Daily reward escalation** | "Besok lebih besar!" | D7→D30 +25% |
| **Streak freeze item** | "Aman kalau lupa sekali" | D30→D90 +20% |
| **Zelby goodbye message** | Emotional attachment | D1→D7 +15% |

### Weekly Retention Mechanics

| Mekanisme | Psikologi | Retention Impact |
|-----------|-----------|-----------------|
| **Weekly boss** | "Minggu ini harus kalahkan dia!" | W1→W2 +30% |
| **Weekly quest reset** | "Misi baru!" | W2→W4 +20% |
| **Badge of the week** | Limited time collection | W4→W8 +15% |

### Monthly Retention Mechanics

| Mekanisme | Psikologi | Impact |
|-----------|-----------|--------|
| **Seasonal world** | "Hanya bulan ini!" | M1→M2 +40% |
| **Monthly leaderboard** | Friendly competition | M2→M3 +15% |
| **Character of the month** | FOMO ringan | M3→M6 +25% |

### Retention Target Funnel

| Metrik | Target |
|--------|--------|
| D1 Retention | 70% |
| D7 Retention | 45% |
| D30 Retention | 30% |
| D90 Retention | 20% |
| DAU/MAU | 35% |
| Average session/week | 5.5 |

---

## 12. CONTENT EXPANSION STRATEGY

### Post-Launch Content Calendar

| Bulan | Konten | Tipe |
|-------|--------|------|
| **Month 1** | Bug fixes, polish, balancing | Maintenance |
| **Month 2** | World 1 extension (+5 level) | World |
| **Month 3** | Seasonal event: Ramadhan | Event |
| **Month 4** | 5 new mini-games | Gameplay |
| **Month 5** | World 2 extension (+5 level) | World |
| **Month 6** | Seasonal event: Kemerdekaan | Event |
| **Month 7** | Character costume shop | Monetization |
| **Month 8** | New character (surprise!) | Character |
| **Month 9** | Seasonal event: Natal & Tahun Baru | Event |
| **Month 10** | World 3 extension | World |
| **Month 11** | Mini-game creator contest | Community |
| **Month 12** | Anniversary event + major update | Event |

### Expansion Multiplier

| Content Type | Dev Effort | Retention Impact | Monetization |
|-------------|-----------|------------------|-------------|
| **New level** | Rendah | Medium | Indirect |
| **New mini-game** | Medium | High | Indirect |
| **New world** | High | Very High | Conversion |
| **Seasonal event** | Medium | Very High | Direct |
| **New character** | High | High | Direct |
| **Costume** | Low | Medium | Direct |
| **Badge/achievement** | Low | Low | — |

---

## 13. TECHNICAL DESIGN PRINCIPLES

### Performance Targets

| Metrik | Target | Notes |
|--------|--------|-------|
| **App size** | <50 MB | Important for Indonesia |
| **RAM usage** | <256 MB | Mid-low end devices |
| **Load time** | <3 detik | Splash during load |
| **Offline mode** | Full gameplay | Sync when online |
| **Animation FPS** | 24 fps | Cutscene, 12 fps idle |
| **Battery usage** | <10% per 30 min | Optimized |

### Save System

| Data | Frequency | Priority |
|------|-----------|----------|
| **Player progress** | Real-time | Critical |
| **Game state** | Every mini-game end | Critical |
| **Inventory** | Every transaction | Critical |
| **Settings** | On change | Normal |
| **Analytics** | Batch every 5 min | Background |
| **Streak data** | On login | Critical |

---

## 14. GAME DESIGN RULES

### Golden Rules of KataPlay

| # | Rule | Why |
|---|------|-----|
| 1 | **No fail state** | Anak kecil tidak boleh merasa gagal. Selalu "coba lagi." |
| 2 | **Every action has reward** | Setiap tap, swipe, drag — ada feedback positif. |
| 3 | **3-click maximum** | Dari home ke gameplay maksimal 3 tap. |
| 4 | **Reading optional** | Semua teks bisa didengarkan. |
| 5 | **No text walls** | Maks 2 kalimat per layar. |
| 6 | **Progress visible** | Anak selalu tahu di mana posisinya. |
| 7 | **Autonomy first** | Anak bisa memilih apa yang ingin dimainkan. |
| 8 | **Surprise & delight** | Hidden easter eggs, random sparkles, funny sounds. |

---

*END OF GAME DESIGN DOCUMENT — CONFIDENTIAL*
