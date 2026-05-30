# KATAPLAY — DAILY QUEST SYSTEM

**Retention Designer:** Duolingo Perspective
**Versi:** 1.0

---

## DESIGN PHILOSOPHY

### Prinsip Utama

> *"Anak kembali bukan karena kewajiban — tapi karena mereka ingin melihat apa yang menanti mereka hari ini."*

### Psikologi Anak yang Digunakan

| Konsep Psikologi | Penerapan | Catatan Etis |
|------------------|-----------|--------------|
| **Variable Reward** | Reward harian tidak selalu sama — kadang stiker, kadang koin, kadang karakter | Aman — antisipasi positif |
| **Commitment Bias** | Streak counter — "sudah 5 hari, sayang kalau putus" | Wajar — streak freeze sebagai safety |
| **Loss Aversion** | "Kamu akan kehilangan streak 7 hari!" | Hati-hati — gunakan positive framing "Hampir 7 hari!" |
| **Curiosity Gap** | "Quest hari ini: rahasia apa di balik pohon besar?" | Sehat — storytelling positif |
| **Completion Drive** | Progress bar harian: 1/3 quest selesai | Memuaskan, tidak membuat frustrasi |

### Healthy Engagement Rules

| # | Rule | Why |
|---|------|-----|
| 1 | **No push notifications after 7pm** | Anak butuh batas screen time |
| 2 | **Streak freeze every 3 days** | Satu kali lupa tidak menghancurkan progress |
| 3 | **Maximum 3 daily quests** | Tidak membebani |
| 4 | **Quest bisa dituker** | Jika terlalu sulit, anak bisa skip (ganti rugi) |
| 5 | **No punishment for missing** | Streak putus → "Besok mulai lagi!" — zero shame |

---

## DAILY QUEST SYSTEM

### Daily Quest Structure

Setiap hari, anak mendapat **3 quest**:

| Quest Type | Contoh | XP | Waktu |
|-----------|--------|-----|-------|
| **Easy** (1 quest) | "Main 1 mini-game" | 20 XP | 2 menit |
| **Medium** (1 quest) | "Selesaikan 2 mini-game" | 40 XP | 5 menit |
| **Challenge** (1 quest) | "Dapat 3 bintang di level 3" | 60 XP | 8 menit |

### Quest Pool (30+ Variasi)

| # | Quest | Type | Kategori | XP |
|---|-------|------|----------|----|
| 1 | Main 1 mini-game | Easy | Engagement | 20 |
| 2 | Selesaikan 2 mini-game | Medium | Engagement | 40 |
| 3 | Dapat 3 bintang | Challenge | Mastery | 60 |
| 4 | Buka 1 level baru | Easy | Progression | 25 |
| 5 | Baca 1 cerita | Medium | Reading | 45 |
| 6 | Kumpulkan 50 koin | Medium | Economy | 40 |
| 7 | Perfect score di game apa pun | Challenge | Mastery | 65 |
| 8 | Main bersama Hazel | Medium | Character | 40 |
| 9 | Cari item rahasia | Challenge | Exploration | 70 |
| 10 | Streak 3 mini-game benar | Challenge | Accuracy | 60 |
| 11 | Coba game baru hari ini | Easy | Discovery | 30 |
| 12 | Naik 1 level | Medium | Progression | 50 |
| 13 | Kumpulkan 10 stiker | Medium | Collection | 45 |
| 14 | Selesaikan world node | Challenge | Progression | 75 |
| 15 | Dengar 1 cerita audio | Easy | Listening | 25 |

### Daily Streak Rewards

| Day | Reward | Visual |
|-----|--------|--------|
| D1 | 50 XP + 20 koin | 🔥 Api kecil |
| D2 | 75 XP + 25 koin | 🔥🔥 |
| D3 | 100 XP + 30 koin + stiker | 🔥🔥🔥 |
| D4 | 125 XP + 35 koin | 🔥🔥🔥🔥 |
| D5 | 150 XP + 40 koin + badge mini | 🔥🔥🔥🔥🔥 |
| D6 | 200 XP + 50 koin | 🔥🔥🔥🔥🔥🔥 |
| D7 | **300 XP + 100 koin + karakter limited** | 🔥🔥🔥🔥🔥🔥🔥🎉 |

### Streak Freeze

| Mekanisme | Detail |
|-----------|--------|
| **Free streak per 3 hari** | Otomatis — setiap 3 hari berturut-turut, dapat 1 freeze |
| **Freeze maksimal** 2 | Simpan maks 2 freeze |
| **Aktivasi** Otomatis saat lupa login | Freeze terpakai, streak aman |

### Comeback Reward

Jika anak tidak login selama:

| Absent | Comeback Reward |
|--------|----------------|
| 1 hari | Streak freeze (jika punya) — tidak ada hukuman |
| 2-3 hari | "Zelby kangen!" — bonus 100 XP + 50 koin |
| 4-7 hari | "Zelby sedih..." — bonus 200 XP + 100 koin + stiker |
| 7+ hari | "Selamat datang kembali!" — bonus 300 XP + 150 koin + badge |

---

## WEEKLY QUEST SYSTEM

### Weekly Structure

| Day | Quest | Notes |
|-----|-------|-------|
| **Senin** | "Mulai minggu dengan semangat!" — 3 mini-game | Boost streak |
| **Selasa** | "Belajar kata baru" — 5 kata baru | Vocabulary |
| **Rabu** | "Tantangan membaca" — 1 cerita | Literacy |
| **Kamis** | "Kolektor stiker" — kumpulkan 3 stiker | Collection |
| **Jumat** | "Boss rush" — lawan boss yang sudah dikalahkan | Mastery |
| **Sabtu** | "Petualangan bebas" — eksplorasi 15 menit | Exploration |
| **Minggu** | "Weekly boss" — boss mingguan khusus | Challenge |

### Weekly Boss

| Atribut | Detail |
|---------|--------|
| **Mekanisme** | Boss mingguan — lebih kuat dari boss world |
| **Kesulitan** | Adjust based on player level |
| **Reward** | 500 XP + 100 koin + stiker limited |
| **Reset** | Setiap hari Minggu jam 24:00 |
| **Attempt** | Unlimited — no stress |

### Weekly Reward

| Streak Hari | Hadiah Mingguan |
|-------------|----------------|
| 7/7 hari | 1000 XP + 300 koin + badge mingguan |
| 6/7 hari | 700 XP + 200 koin |
| 5/7 hari | 500 XP + 150 koin |
| <5 hari | 300 XP + 100 koin |

---

## MONTHLY QUEST SYSTEM

### Monthly Challenge

| Atribut | Detail |
|---------|--------|
| **Durasi** | 1 bulan kalender |
| **Quest total** | 20 quest (5 per minggu) |
| **Reward utama** | Karakter limited / Costume eksklusif |
| **Progress** | Progress bar bulanan |

### Monthly Theme

| Bulan | Theme | Karakter Limited | Bonus XP |
|-------|-------|------------------|----------|
| Januari | Petualangan Salju | Zelby Winter | 2x |
| Februari | Cinta & Persahabatan | Hazel Love | 2x |
| Maret | Taman Bermain | Alby Play | 2x |
| April | Bumi Kita | Eco Zelby | 2x |
| Mei | Pendidikan | Hazel Guru | 2x |
| Juni | Laut & Pantai | Zelby Surfer | 3x |
| Juli | Kemerdekaan | Pahlawan Alby | 3x |
| Agustus | HUT RI | Team Merah-Putih | 3x |
| September | Olahraga | Hazel Atlet | 2x |
| Oktober | Cerita Seram (lucu) | Zelby Hantu | 2x |
| November | Keluarga | Family Set | 2x |
| Desember | Natal & Tahun Baru | Santa Zelby | 3x |

---

## QUEST UI DESIGN

### Daily Quest Card

```
┌──────────────────────────────────────┐
│  📋 Quest Hari Ini                  │
│                                      │
│  ┌──────────────────────────────┐   │
│  │  🔥 Streak: 5 hari!          │   │
│  │  ▓▓▓▓▓▓▓▓▓▓░░░░ Hari 7: 300XP │   │
│  └──────────────────────────────┘   │
│                                      │
│  ☐ Main 1 mini-game        +20 XP  │
│  ☐ Selesaikan 2 mini-game   +40 XP  │
│  ☐ Dapat 3 bintang          +60 XP  │
│                                      │
│  ┌──────────────────────────────┐   │
│  │  Progress: 1/3 quest 🔥     │   │
│  └──────────────────────────────┘   │
└──────────────────────────────────────┘
```

### Quest Reward Animation

```
Saat quest selesai:
┌──────────────────────────────────────┐
│                                      │
│          🎉 Quest Selesai!           │
│                                      │
│       ☑ Main 1 mini-game ✅         │
│       +20 XP                         │
│       +10 koin                       │
│                                      │
│               🎁                    │
│                                      │
│          Ambil Reward →              │
└──────────────────────────────────────┘
```

---

## NOTIFICATION STRATEGY

### Push Notification Schedule

| Waktu | Pesan | Tujuan |
|-------|-------|--------|
| **07:00** | "Selamat pagi! Zelby sudah siap main!" | Morning habit |
| **12:00** | "Quest baru menunggu, loh!" | Mid-day reminder |
| **16:00** | "Hazel dan Alby main, yuk!" | After school |
| **18:00** | "Main 5 menit sebelum tidur, yuk!" | Evening session |
| **Notifikasi maks** | **2 per hari** | Tidak spam |

### Message Variations

| Type | Contoh |
|------|--------|
| **Character** | "Zelby: Ayo, aku temukan sesuatu!" |
| **Quest** | "Quest hari ini: kumpulkan 50 koin!" |
| **Streak** | "🔥 Streak 5 hari! Besok reward besar!" |
| **Friend** | (future) "Temanmu sudah di world 3!" |
| **Event** | "Event Ramadhan dimulai! Dapat karakter spesial!" |

---

*END OF DAILY QUEST SYSTEM — CONFIDENTIAL*
