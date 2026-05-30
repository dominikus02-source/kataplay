# KATAPLAY — MVP SCOPE & 90-DAY LAUNCH PLAN

**Startup Product Advisor**
**Target:** Launch in 90 hari dengan tim kecil & budget startup

---

## 1. FITUR Wajib di MVP (P0)

### Core Gameplay

| Fitur | Alasan | Estimasi |
|-------|--------|----------|
| **World 1: Pulau Huruf (Level 1-10)** | Foundation — semua konten lanjutan bergantung pada core gameplay loop | 30 hari |
| **5 Mini Games (MG1-MG5)** | Cukup variatif untuk engagement tanpa over-build | 20 hari |
| **Karakter Zelby (fully animated)** | Maskot utama — wajib dari hari 1 | 15 hari |
| **Basic Reward System** | XP, koin, bintang — loop motivasi dasar | 10 hari |
| **Daily Streak (1-7 hari)** | Retention driver paling kuat | 5 hari |
| **3 Daily Quests** | Daily habit formation | 5 hari |
| **Parent Dashboard (basic)** | Trust orang tua — lihat progress anak | 10 hari |
| **Offline Play** | Wajib untuk pasar Indonesia | 10 hari |

### Infrastructure

| Fitur | Alasan | Estimasi |
|-------|--------|----------|
| **Account (email/Google)** | Sync progress antar device | 7 hari |
| **Progress Save** | Jangan sampai progress hilang | 5 hari |
| **Analytics (basic)** | Track retention, engagement | 5 hari |
| **Parent Gate** | Keamanan transaksi | 3 hari |
| **No Ads** | Trust factor | — |

### Content

| Konten | Jumlah | Estimasi |
|--------|--------|----------|
| **Kata dasar** | 100 kata | 10 hari |
| **Ilustrasi** | 100 aset | 20 hari |
| **Audio (narasi + suara)** | 100 file | 10 hari |
| **Story episode** | 3 episode (World 1) | 15 hari |

---

## 2. FITUR HARUS DITUNDA (P1 → P2)

| Fitur | Alasan Ditunda | Rencana |
|-------|---------------|---------|
| **World 2-5** | MVP cukup 1 world untuk validasi | Post-launch bulan 2-5 |
| **Multi-character (Hazel & Alby)** | Kompleksitas animasi tinggi | Post-launch bulan 2-4 |
| **Speech recognition** | Teknologi mahal, belum critical | Post-launch bulan 6 |
| **Social features** | Safety & moderation overhead | Post-launch tahun 2 |
| **In-app purchases** | Fokus dapetin user dulu | Post-launch bulan 3 |
| **School dashboard** | B2B beda channel | Post-launch tahun 2 |
| **Leaderboard** | Bisa bikin anak stres | Post-launch bulan 6 |
| **Seasonal events** | Content pipeline berat | Post-launch bulan 4 |
| **Character costumes** | Nice-to-have, bukan core | Post-launch bulan 5 |
| **Multi-language** | MVP 100% Bahasa Indonesia | Tahun 2 |

---

## 3. FITUR BERISIKO TINGGI

| Fitur | Risiko | Mitigasi |
|-------|--------|----------|
| **User-generated content** | Moderasi konten anak sangat sulit | Tidak masuk MVP. Jika diimplementasi: strict AI filter |
| **Chat / messaging** | Safety hazard untuk anak | Tidak masuk MVP. Tidak akan diimplementasi tanpa mature system |
| **Real-time multiplayer** | Latency, safety, engineering complexity | Tidak masuk MVP. Co-op hanya async |
| **AI adaptive learning** | Data insufficiency awal, ML pipeline mahal | Rule-based adaptive cukup untuk MVP |
| **AR features** | Device fragmentation, performa | Tunda sampai user base stabil |

---

## 4. FITUR MAHAL (Resource Heavy)

| Fitur | Estimasi Biaya | Lebih Murah? |
|-------|---------------|--------------|
| **Full animation cutscene** | $$$ | Gunakan comic panel style + voiceover |
| **Professional voice actors** | $$ | Bisa talent voice over lokal (lebih murah dari karakter) |
| **30+ mini games** | $$$ | 5 untuk MVP → 2 per bulan post-launch |
| **Custom illustrations per word** | $$$ | 100 untuk MVP, scale with template |
| **5 worlds** | $$$$ | 1 world untuk MVP → 1 world per 2 bulan |
| **Licensed music** | $$ | Komposer indie / royalty-free |

---

## 5. FITUR PALING BERPENGARUH TERHADAP RETENTION

| Peringkat | Fitur | Dampak Retention | Effort | 
|-----------|-------|------------------|--------|
| **#1** | **Streak system** | +35% D7 | Rendah |
| **#2** | **Daily quest** | +30% D30 | Rendah |
| **#3** | **Reward animation** | +20% D1 | Rendah |
| **#4** | **Offline play** | +25% D30 (Indonesia) | Medium |
| **#5** | **Zelby character bond** | +20% D90 | Medium |
| **#6** | **Push notifications** | +15% D7 | Rendah |
| **#7** | **New content drops** | +20% D90 | Tinggi |
| **#8** | **Sound & music** | +10% engagement | Medium |
| **#9** | **Parent dashboard** | +15% conversion | Medium |
| **#10** | **Seasonal events** | +25% D60 | Tinggi |

---

## 6. 90-DAY LAUNCH PLAN

### Sprint 0: Foundation (Days 1-14)

| Week | Tasks | Deliverable |
|------|-------|-------------|
| W1 | Architecture, tech stack, CI/CD, design system implementation | Running build |
| W2 | Core engine: navigation, world map, game state management | Navigatable prototype |

### Sprint 1: Core Gameplay (Days 15-35)

| Week | Tasks | Deliverable |
|------|-------|-------------|
| W3 | Zelby character integration, basic movement, tap interaction | Playable Zelby |
| W4 | Mini-game 1 (Letter Pop) + Mini-game 2 (Word Builder) | 2 playable games |
| W5 | Mini-game 3 (Picture Match) + World 1 layout (5 levels) | World 1 prototype |

### Sprint 2: Content & Systems (Days 36-56)

| Week | Tasks | Deliverable |
|------|-------|-------------|
| W6 | Mini-game 4 (Story Time) + Mini-game 5 (Sound Safari) | 5 games complete |
| W7 | World 1 complete (10 levels + Boss), reward system, XP/coins | Full World 1 |
| W8 | Streak system, daily quest, progress save, account system | Retention systems |

### Sprint 3: Polish & Launch (Days 57-90)

| Week | Tasks | Deliverable |
|------|-------|-------------|
| W9 | Parent dashboard, offline mode, analytics | Infrastructure |
| W10 | UI polish, animation, sound effects, music | Polished build |
| W11 | Playtesting with 50 kids, bug fixing, optimization | Tested build |
| W12 | Soft launch (Play Store beta), crash monitoring, final fixes | LIVE! |

---

## 7. MVP TEAM STRUCTURE

### Core Team (6-8 orang)

| Role | Headcount | Kebutuhan |
|------|-----------|-----------|
| **Product Manager** | 1 | Full-time |
| **Flutter Developer** | 2 | Full-time |
| **Backend Developer** | 1 | Part-time (first 2 months) |
| **UI/UX Designer** | 1 | Full-time |
| **Illustrator/Animator** | 1 | Full-time (contract possible) |
| **Content Writer** | 1 | Part-time |
| **QA Tester** | 1 | Part-time (last month) |

### Budget Estimate (Monthly)

| Item | Estimasi (Rp) |
|------|---------------|
| **Gaji tim** | 100-150 juta |
| **Server & infrastructure** | 5-10 juta |
| **Tools & licensing** | 2-5 juta |
| **Sound & illustration** | 10-20 juta (one-time) |
| **Marketing** | 10-20 juta |
| **Total/bulan** | **~130-200 juta** |
| **Total 3 bulan** | **~400-600 juta** |

---

## 8. POST-LAUNCH ROADMAP (BULAN 4-12)

| Month | Focus | Key Deliverable |
|-------|-------|----------------|
| **M4** | Hazel & Alby launch | 2 characters + their worlds intro |
| **M5** | World 2: Kebun Kata | 12 new levels, 2 new mini-games |
| **M6** | Monetization launch | Premium subscription, costume shop |
| **M7** | Seasonal event #1 | Ramadhan theme, limited characters |
| **M8** | World 3: Pantai Cerita | 14 new levels, boss |
| **M9** | Speech recognition | Speaking mini-games |
| **M10** | Seasonal event #2 | Kemerdekaan, special badge |
| **M11** | World 4: Gunung Kalimat | 16 new levels |
| **M12** | Anniversary + World 5 | Full game complete! |

---

## 9. DECISION MATRIX SUMMARY

| Fitur | MVP | Reason |
|-------|-----|--------|
| World 1 (10 levels) | ✅ | Core loop validation |
| 5 mini-games | ✅ | Content variety |
| Zelby only | ✅ | Focus, character bonding |
| Streak + quest | ✅ | Retention (high impact, low effort) |
| Reward system | ✅ | Motivation loop |
| Offline play | ✅ | Non-negotiable for Indonesia |
| Parent dashboard | ✅ | Trust = conversion |
| Hazel & Alby | ❌ | Post-launch month 2-4 |
| World 2-5 | ❌ | Post-launch month 3-10 |
| Monetization | ❌ | Post-launch month 3-6 |
| Speech recognition | ❌ | Post-launch month 9 |
| Social features | ❌ | Year 2 |

---

*END OF MVP SCOPE — CONFIDENTIAL*
