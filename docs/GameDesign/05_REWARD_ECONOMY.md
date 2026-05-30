# KATAPLAY — REWARD ECONOMY

**Economy Designer:** Clash Royale & Pokémon Go Perspective
**Versi:** 1.0

---

## ECONOMY OVERVIEW

### Currency Types

| Mata Uang | Icon | Fungsi Utama | Didapat Dari | Max Accumulation |
|-----------|------|-------------|-------------|------------------|
| **XP** | 📈 | Naik level | Semua aktivitas | Unlimited |
| **Koin** | 🪙 | Beli item, costume, lives | Mini-game, streak, quest | 99,999 |
| **Bintang** | ⭐ | Unlock world, karakter, level | Mastery, achievement | 999 |
| **Stiker** | 🏷️ | Koleksi, hiasan album | Event, milestone | 999 jenis |
| **Badge** | 🏅 | Prestasi permanen | Pencapaian spesial | Limited |

### Economy Design Philosophy

> *"Anak selalu merasa kaya — tapi selalu punya sesuatu untuk dicapai."*

| Prinsip | Penerapan |
|---------|-----------|
| **Always earning** | Setiap tindakan menghasilkan sesuatu |
| **Always spending** | Selalu ada hal menarik untuk dibeli |
| **Never broke** | Balance agar anak tidak pernah kehabisan |
| **Never excessive** | Hindari hoarding balance |
| **Generous early** | Banyak reward di awal untuk engagement |

---

## 1. XP SYSTEM

### XP Progression Formula

```
XP needed for Level N = 50 × N × (1 + N/10)
```

### XP Table (Level 1-30)

| Level | XP Need | Total XP | Est. Hari |
|-------|---------|----------|-----------|
| 1 | 0 | 0 | 0 |
| 2 | 110 | 110 | 1 |
| 3 | 180 | 290 | 1 |
| 4 | 260 | 550 | 2 |
| 5 | 350 | 900 | 2 |
| 6 | 450 | 1350 | 3 |
| 7 | 595 | 1945 | 4 |
| 8 | 720 | 2665 | 5 |
| 9 | 855 | 3520 | 6 |
| 10 | 1000 | 4520 | 7 |
| 15 | 1875 | 15270 | 18 |
| 20 | 3500 | 40950 | 40 |
| 25 | 6312 | 100000 | 90 |
| 30 | 9000 | 182000 | 150 |

### XP Sources

| Sumber | XP Base | Bonus | Frekuensi |
|--------|---------|-------|-----------|
| Mini-game selesai | 10 | +5 perfect | Unlimited |
| Daily quest | 20-60 | +streak | 3/hari |
| Streak reward | 50-300 | Increasing | 1/hari |
| Boss defeated | 100-500 | First time | Per boss |
| Achievement | 50-1000 | One-time | Limited |
| First win of day | 2x multiplier | Daily | All games |

### Level Up Rewards

| Level | Hadiah |
|-------|--------|
| 2 | 50 koin |
| 3 | Stiker pack |
| 5 | **Karakter Hazel** |
| 7 | 100 koin |
| 10 | **Karakter Alby** |
| 12 | Costume Zelby |
| 15 | 200 koin |
| 20 | Badge "Petualang" |
| 25 | 500 koin + rare stiker |

---

## 2. COIN SYSTEM

### Coin Economy Balance

```
Daily Income:
  Streak bonus:  50-300
  Mini-games:    20-60 (2-3 games)
  Daily quests:  30-90
  ─────────────────
  Total/day:     ~150-500 coins

Daily Spending:
  Costume:       300-500 (1x purchase)
  Item:          50-200
  Life refill:   100
  ─────────────────
  Total/day:     ~100-300 coins (optional)
```

### Coin Sources

| Aktivitas | Koin | Note |
|-----------|------|------|
| Mini-game selesai | 5-15 | Per game |
| Perfect score bonus | +10 | Additional |
| Streak daily | 20-100 | Increasing |
| Daily quest | 10-30 | Per quest |
| Boss defeat | 50-200 | First time |
| Achievement | 100-500 | One-time |
| Level up | 50-500 | Per level |

### Coin Spending

| Item | Harga | Kategori | Fungsi |
|------|-------|----------|--------|
| Costume Zelby | 300 | Kosmetik | Ubah penampilan |
| Costume Hazel | 300 | Kosmetik | Ubah penampilan |
| Costume Alby | 300 | Kosmetik | Ubah penampilan |
| Room decoration | 100-500 | Kosmetik | Hias rumah karakter |
| Sticker pack | 100 | Koleksi | Stiker random |
| Life refill | 100 | Utility | Main lagi tanpa nunggu |
| Skip waiting | 50 | Utility | Skip timer |

---

## 3. BINTANG SYSTEM

### Mekanisme Bintang

Bintang adalah **mastery currency** — tidak bisa dibeli, hanya bisa didapat dari prestasi.

| Cara Mendapat | Jumlah | Frekuensi |
|--------------|--------|-----------|
| 3 bintang di level | 3 | Per level (max) |
| Perfect mini-game | 1 | Per game |
| Boss perfect | 5 | Per boss |
| Achievement | 1-10 | Limited |

### Bintang Spending

| Item | Bintang | Fungsi |
|------|---------|--------|
| Unlock world baru | 10 | Progression |
| Unlock karakter | 20 | Character |
| Unlock costume rare | 15 | Kosmetik |
| Unlock secret level | 5 | Content |
| Unlock badge | 10 | Achievement |

---

## 4. STIKER SYSTEM

### Stiker Koleksi

| Kategori | Jumlah Stiker | Cara Dapat |
|----------|--------------|------------|
| **Hewan** | 20 | Level, event |
| **Buah** | 15 | Mini-game perfect |
| **Alfabet** | 26 | Level pertama |
| **Karakter** | 15 | Achievement |
| **Seasonal** | 12 | Event bulanan |
| **Secret** | 10 | Hidden exploration |

### Stiker Usage

| Fungsi | Detail |
|--------|--------|
| **Album** | Koleksi lengkap → badge |
| **Hiasan** | Tempel di room karakter |
| **Trade** | (future) Tukar dengan teman |
| **Crafting** | (future) Gabung → item spesial |

---

## 5. BADGE SYSTEM

### Badge Categories

| Kategori | Badge | Cara Dapat |
|----------|-------|------------|
| **Progression** | "Petualang" | Level 20 |
| **Progression** | "Penjelajah" | World 3 complete |
| **Progression** | "Master Bahasa" | All worlds complete |
| **Skill** | "Ahli Huruf" | All letter levels 3★ |
| **Skill** | "Ahli Kata" | All word levels 3★ |
| **Skill** | "Ahli Baca" | All story levels 3★ |
| **Collection** | "Kolektor" | 50 stiker |
| **Collection** | "Kolektor Legend" | All stiker |
| **Streak** | "Rajin" | Streak 7 hari |
| **Streak** | "Tak Terhentikan" | Streak 30 hari |
| **Event** | "Ramadhan" | Event selesai |
| **Event** | "Merdeka" | Event 17 Agustus |
| **Secret** | "Penemu" | Find secret path |

---

## 6. BALANCING PRINCIPLES

### Anti-Frustration Design

| Skenario | Mekanisme |
|----------|-----------|
| **Kehabisan koin** | Daily free coin (50) — selalu ada |
| **Level terlalu sulit** | Hint gratis setelah 2x gagal |
| **Boss terlalu kuat** | Power-up gratis setiap attempt |
| **Kehabisan streak** | Freeze system (3 hari sekali) |
| **Event terlewat** | Catch-up mechanic (last 3 days) |

### Anti-Exploitation Design

| Risiko | Pencegahan |
|--------|-----------|
| **Bot farming** | Captcha ringan, rate limiting |
| **Multiple account** | Perangkat binding |
| **Coin hoarding** | Limited max (99,999) |
| **In-app purchase abuse** | Parent gate, spending limit |
| **Stiker duping** | Random dengan protection |

---

## 7. ECONOMY FORMULA SUMMARY

### Income vs Spending Balance

| Metrik | Target | Formula |
|--------|--------|---------|
| **Daily income (coins)** | ~250 | Streak + 2 games + 3 quests |
| **Daily spending (avg)** | ~150 | 1 costume every 2 days |
| **Savings rate** | 40% | Anak menabung untuk item besar |
| **Time to buy costume** | 2-3 hari | Motivasi tanpa frustrasi |
| **Time to unlock new world** | 1-2 minggu | Sustainable engagement |
| **Premium item cost** | 3-5 hari main | Worth buying with $ |
| **Free currency %** | 80% | Majority free |
| **Paid currency %** | 20% | Cosmetics only |

---

*END OF REWARD ECONOMY — CONFIDENTIAL*
