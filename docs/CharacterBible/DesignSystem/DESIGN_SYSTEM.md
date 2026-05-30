# KATAPLAY — COMPLETE DESIGN SYSTEM

**Senior Product Designer:** Duolingo Kids & Lingokids Perspective
**Target:** Children 4-10 years old
**Style:** Modern, Premium, Friendly, Rounded, Vibrant
**Versi:** 1.0

---

## 1. COLOR PALETTE

### Brand Colors (Official Final)

```
Zelby Green       #0F8B6F    ████████  HSL: 167°, 81%, 54%
Adventure Orange  #FF9F43    ████████  HSL: 30°, 100%, 63%
Sunshine Yellow   #FFD93D    ████████  HSL: 48°, 100%, 62%
Sky Blue          #60A5FA    ████████  HSL: 213°, 94%, 68%
Cream             #FFF8EC    ████████  HSL: 38°, 100%, 96%
```

### UI Colors

```
Background        #FFF8EC    ████████  Cream hangat
Card BG           #FFFFFF    ████████  Putih bersih
Surface Alt       #F5F3FF    ████████  Ungu muda 5%
Text Primary      #1A1A2E    ████████  Hampir hitam
Text Secondary    #6B7280    ████████  Abu-abu medium
Text Inverted     #FFFFFF    ████████  Putih
Border            #E5E7EB    ████████  Abu-abu tipis
Success           #22C55E    ████████  Hijau
Error             #EF4444    ████████  Merah (gunakan hati-hati)
Warning           #F59E0B    ████████  Kuning
```

---

## 2. TYPOGRAPHY (Official Final)

### Font

| Level | Font | Weight | Size | Line H | Letter Spacing |
|-------|------|--------|------|--------|----------------|
| **Logo** | Fredoka | Bold | — | — | — |
| **Display** | Fredoka | Bold | 48px | 56px | -0.01em |
| **H1** | Fredoka | SemiBold | 36px | 44px | 0em |
| **H2** | Fredoka | SemiBold | 28px | 36px | 0em |
| **H3** | Fredoka | SemiBold | 22px | 28px | +0.01em |
| **H4** | Fredoka | SemiBold | 18px | 24px | +0.01em |
| **Body L** | Nunito | Regular | 18px | 28px | +0.01em |
| **Body M** | Nunito | Regular | 16px | 24px | +0.01em |
| **Body S** | Nunito | Regular | 14px | 20px | +0.01em |
| **Button** | Nunito | Bold | 18px | 24px | +0.02em |
| **Button S** | Nunito | Bold | 14px | 20px | +0.02em |
| **Caption** | Nunito | Regular | 12px | 16px | +0.02em |
| **Label** | Nunito | Bold | 14px | 20px | +0.03em |

---

## 3. BUTTON SYSTEM

### Button Anatomy

```
┌──────────────────────────────────┐
│                                  │
│    [Icon]  Label Text  [Icon]    │
│                                  │
└──────────────────────────────────┘
        ↑                   ↑
    Padding 16-32px    Corner 32px
```

### Button Specs

| Property | Primary | Secondary | Tertiary | Ghost |
|----------|---------|-----------|----------|-------|
| **Height** | 64px | 64px | 48px | 48px |
| **Padding X** | 32px | 32px | 24px | 16px |
| **Radius** | 32px | 32px | 24px | 12px |
| **Bg Color** | #0F8B6F | #FFFFFF | Transparent | Transparent |
| **Border** | None | 2px #0F8B6F | 2px #E5E7EB | None |
| **Text Color** | #FFFFFF | #0F8B6F | #1A1A2E | #0F8B6F |
| **Shadow** | md (brand) | md | None | None |
| **Font** | Bold 18px | Bold 18px | Bold 18px | Bold 16px |

### Button States

| State | Primary | Secondary |
|-------|---------|-----------|
| **Default** | bg #0F8B6F | bg #FFF, border #0F8B6F |
| **Hover (web)** | bg #0A7D63 | bg #F0FDF4 |
| **Pressed** | bg #0A6B55 | bg #DCFCE7 |
| **Disabled** | bg #9CA3AF | bg #F3F4F6, border #D1D5DB |
| **Loading** | + spinner animation | + spinner animation |

### Button Size Variants

| Size | Height | Padding X | Font | Icon Size |
|------|--------|-----------|------|-----------|
| **Large** | 64px | 32px | Bold 18px | 24px |
| **Medium** | 52px | 24px | Bold 16px | 20px |
| **Small** | 40px | 20px | Bold 14px | 16px |

### Special Buttons

| Type | Style | Penggunaan |
|------|-------|------------|
| **Orange CTA** | bg #FF9F43, text #FFF | Reward, streak |
| **Yellow CTA** | bg #FFD93D, text #1A1A2E | Achievement |
| **Purple CTA** | bg #8B5CF6, text #FFF | Hazel's quest |
| **Amber CTA** | bg #FBBF24, text #1A1A2E | Alby's discovery |
| **Icon Button** | 48x48, radius 24, bg #FFF | Nav actions |
| **Floating** | 64x64, radius 32, shadow-lg | Quick action |

---

## 4. CARD SYSTEM

### Card Anatomy

```
┌──────────────────────────────────┐
│  ┌────────┐                      │
│  │  Icon  │  Title               │  ← Header (optional)
│  └────────┘                      │
│                                  │
│  Body content here               │
│  Multiple lines possible         │
│                                  │
│  ┌──────────────────┐            │
│  │    Button/Link    │           │  ← Footer (optional)
│  └──────────────────┘            │
└──────────────────────────────────┘
```

### Card Specs

| Property | Default | Highlight | Character |
|----------|---------|-----------|-----------|
| **Radius** | 20px | 20px | 20px |
| **Bg** | #FFFFFF | #FFFFFF | #FFFFFF |
| **Border** | 1px #F3F4F6 | 2px #0F8B6F | 1px #F3F4F6 |
| **Shadow** | shadow-md | shadow-lg | shadow-md |
| **Padding** | 24px | 24px | 20px |
| **Elevation** | 2 | 4 | 2 |

### Card Types

| Type | Width | Usage |
|------|-------|-------|
| **Full Width** | 100% - 32px margin | Main content |
| **Half** | calc(50% - 16px) | Grid layout |
| **Third** | calc(33% - 16px) | Character grid |
| **Compact** | 200-280px | Reward items |
| **Hero** | 100% | Quest banner |

### Card Variants

| Variant | Special Style | Kapan Dipakai |
|---------|--------------|---------------|
| **Quest Card** | Border kiri 4px #0F8B6F | Quest aktif |
| **Reward Card** | bg #FFFBEB, border #FFD93D | Reward display |
| **Character Card** | Avatar 80x80 + border #8B5CF6 | Pilih karakter |
| **Progress Card** | Bar progress di footer | Learning stats |
| **Story Card** | No shadow, bg #FFE4E6 | Story text |
| **Item Card** | 120x120, grid | Inventory |

---

## 5. ICON SYSTEM

### Icon Specifications

| Property | Value |
|----------|-------|
| **Style** | Filled (solid), rounded edges |
| **Stroke width** | 2px for 24px icons |
| **Corner radius** | 2px on icon corners |
| **Grid** | 24x24 (default), 20x20 (small), 32x32 (large) |
| **Padding** | 2px inside bounding box |

### Icon Sizes by Context

| Context | Size | Notes |
|---------|------|-------|
| **Navigation bar** | 28px | Tab bar icons |
| **Button** | 24px | Inside buttons |
| **Card header** | 32px | Card icon |
| **Reward** | 48-64px | Reward display |
| **Character avatar** | 80-120px | Profile |
| **World map icons** | 40px | Map markers |
| **Item inventory** | 48px | Collectibles |
| **Mini (inline)** | 16px | Labels, small badges |

### Icon Categories

| Kategori | Contoh Icon | Style |
|----------|------------|-------|
| **Navigation** | Home, Map, Quest, Profile, Shop | Filled |
| **Actions** | Play, Back, Forward, Close, Settings | Filled |
| **Learning** | Book, Pencil, Read, Write, Speak | Filled |
| **Rewards** | Star, Coin, Trophy, Badge, Gift | Filled + sparkle |
| **Characters** | Zelby, Hazel, Alby face | Avatar |
| **World** | Forest, Mountain, Sea, Cave, City | Filled + details |
| **Status** | Lock, Check, Heart, Lightning, Fire | Filled |

---

## 6. NAVIGATION SYSTEM

### Bottom Navigation Bar

```
┌──────────────────────────────────────┐
│                                      │
│  ┌────┐  ┌────┐  ┌────┐  ┌────┐     │
│  │ 🏠 │  │ 🗺 │  │ 📜 │  │ 👤 │     │
│  │Home│  │Map │  │Quest│  │Profil│   │
│  └────┘  └────┘  └────┘  └────┘     │
│                                      │
└──────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| **Height** | 72px |
| **Bg** | #FFFFFF |
| **Top border** | 1px #E5E7EB |
| **Icon size** | 28px |
| **Label font** | Caption (12px Nunito Bold) |
| **Active color** | #0F8B6F |
| **Inactive color** | #9CA3AF |
| **Padding** | 8px 0 |
| **Radius top** | 20px |

### Tab Bar Items

| Item | Icon | Label | Active Color |
|------|------|-------|-------------|
| **Home** | 🏠 | Rumah | #0F8B6F |
| **Map** | 🗺 | Peta | #FF9F43 |
| **Quest** | 📜 | Petualangan | #8B5CF6 |
| **Profile** | 👤 | Profil | #F59E0B |

### Header Navigation

```
┌──────────────────────────────────────┐
│  ← Kembali     Title         Profile │
└──────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| **Height** | 56px |
| **Bg** | Transparent or #FFF8EC |
| **Title font** | H4 Fredoka SemiBold |
| **Back button** | 40x40 icon |
| **Padding H** | 16px |

### Quest Navigation

```
┌──────────────────────────────────────┐
│  ◄      ○  ○  ●  ○  ○      ►        │
└──────────────────────────────────────┘
     Step 1  2 [3] 4  5
```

| Property | Value |
|----------|-------|
| **Dot size** | 12px |
| **Active dot** | 14px, #0F8B6F |
| **Completed** | #22C55E with check |
| **Inactive** | #D1D5DB |
| **Spacing** | 8px |

---

## 7. REWARD SCREEN SYSTEM

### Reward Screen Anatomy

```
┌──────────────────────────────────────┐
│                                      │
│          ╱‾‾‾‾‾‾╲                    │
│        ╱  ☆  ☆  ☆  ╲               │
│       │     ╲__╱     │              │
│       │    YEAY! 🎉  │  ← Animation │
│        ╲          ╱                 │
│         ╲────────╱                   │
│                                      │
│    ┌──────────────────────┐          │
│    │   +50 Bintang        │          │
│    │   Karakter Baru!     │  ← Reward│
│    │   Petualangan Berhasil│         │
│    └──────────────────────┘          │
│                                      │
│    ┌────────────────┐               │
│    │   LANJUTKAN    │               │  ← CTA
│    └────────────────┘               │
│                                      │
└──────────────────────────────────────┘
```

### Reward Screen Specs

| Property | Value |
|----------|-------|
| **Bg** | #FFF8EC (overlay gelap 40%) |
| **Card width** | 320px (centered) |
| **Card bg** | #FFFFFF |
| **Card radius** | 24px |
| **Card padding** | 32px |
| **Card shadow** | shadow-xl + glow #0F8B6F |
| **Animation** | Scale in + confetti |
| **Duration** | 2.5s auto-dismiss |

### Reward Elements

| Element | Size | Style |
|---------|------|-------|
| **Icon reward** | 80-120px | Bounce animation |
| **Star counter** | +XX | Fredoka Bold 36px, #FFD93D |
| **Title** | "Yeay!" | Fredoka Bold 48px, #0F8B6F |
| **Description** | 16px Nunito | Text Secondary |
| **Confetti** | Full screen | Particle animation |

### Reward Tiers

| Tier | Visual | Durasi | Sound |
|------|--------|--------|-------|
| **Micro** (bintang) | Icon pop +1 | 0.5s | "Pop!" |
| **Mini** (koin) | Icon slide + counter | 1s | "Cha-ching!" |
| **Meso** (item) | Card reveal + sparkle | 1.5s | "Wow!" |
| **Macro** (char) | Full screen + confetti | 2.5s | "YEAY!!" |
| **Ultra** (event) | Cinematic + fireworks | 4s | Fanfare |

---

## 8. QUEST SYSTEM

### Quest Card

```
┌──────────────────────────────────────┐
│                                      │
│  ┌────┐  📖 Petualangan Baru        │
│  │ 🏁 │                              │
│  └────┘  "Bantu Zelby menemukan      │
│           kata-kata ajaib!"          │
│                                      │
│  ▓▓▓▓▓▓▓▓▓▓░░░░░░░░ 70%            │
│                                      │
│  3/5 kata ditemukan                 │
│                                      │
│  ┌────────────────────┐             │
│  │   LANJUTKAN        │             │
│  └────────────────────┘             │
│                                      │
└──────────────────────────────────────┘
```

### Quest Specs

| Property | Value |
|----------|-------|
| **Card radius** | 20px |
| **Card bg** | #FFFFFF |
| **Progress bar height** | 8px |
| **Progress bar radius** | 4px |
| **Progress bar bg** | #E5E7EB |
| **Progress bar fill** | #0F8B6F |
| **Quest icon** | 48px |
| **Title font** | H3 Fredoka SemiBold |
| **Desc font** | Body M Nunito |
| **Step indicator** | "3/5" Bold 16px |

### Quest State

| State | Visual | CTA |
|-------|--------|-----|
| **Available** | Normal card, lock icon | "Mulai" (green) |
| **In Progress** | Highlight card, progress bar | "Lanjutkan" (green) |
| **Completed** | Checkmark, reduced opacity | "Lihat" (outline) |
| **Locked** | Gray, lock overlay | — |

### Quest Progress Bar

```
  0% ░░░░░░░░░░░░░░░░░░░░   Belum mulai
 25% ▓░░░░░░░░░░░░░░░░░░░   Baru mulai
 50% ▓▓▓▓▓░░░░░░░░░░░░░░   Setengah jalan
 75% ▓▓▓▓▓▓▓▓░░░░░░░░░░   Hampir selesai
100% ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   Selesai!
```

---

## 9. WORLD MAP SYSTEM

### World Map Layout

```
┌──────────────────────────────────────┐
│                                      │
│     🌲🌲🌲    ⛰️⛰️                  │
│   🌲 ┌──┐ 🌲 ╱──╲ ⛰️               │
│  🌲  │★ │ 🌲│ 🌊│ ⛰️               │
│   🌲 └──┘ 🌲 ╲──╱ ⛰️               │
│     🌲🌲🌲    ╲╱  ⛰️⛰️              │
│         ╲    ╱                      │
│    ┌──┐  ╲  ╱   ┌──┐               │
│    │○ │   ╲╱    │☆ │               │
│    └──┘   ╱╲    └──┘               │
│          ╱  ╲                       │
│    🏖️🏖️╱    ╲🏖️🏖️                  │
│                                      │
└──────────────────────────────────────┘
```

### Map Specs

| Property | Value |
|----------|-------|
| **Bg** | #FFF8EC |
| **Scroll** | Horizontal & vertical (pannable) |
| **Zoom** | Pinch to zoom (1x-3x) |
| **Grid** | Invisible, free placement |
| **World node size** | 80x80px |
| **Node radius** | 16px |
| **Node spacing** | Min 120px apart |
| **Path between** | 4px dotted #D1D5DB or #0F8B6F |

### World Node States

| State | Visual | Label |
|-------|--------|-------|
| **Locked** | Gray, lock icon, dimmed | "?" |
| **Available** | Colorful, pulse animation | Nama world |
| **In Progress** | Highlight, progress ring | Progress % |
| **Completed** | Checkmark, star | "Selesai!" |
| **Special Event** | Glow + sparkle | "Event!" |

### World Node Components

```
┌──────────────────┐
│                  │
│      ┌────┐      │
│      │ 🏔️ │      │  ← Icon 48px
│      └────┘      │
│                  │
│   Hutan Ajaib   │  ← Label Fredoka Bold 14px
│     2/5 🐾      │  ← Progress
│                  │
└──────────────────┘
     ↑ Radius 16px
```

### World List

| World | Theme | Icon | Warna |
|-------|-------|------|-------|
| **Hutan Ajaib** | Forest | 🌲 | #0F8B6F |
| **Lautan Kata** | Ocean | 🌊 | #60A5FA |
| **Gunung Kosa** | Mountain | ⛰️ | #8B5CF6 |
| **Kota Imajinasi** | City | 🏙️ | #FF9F43 |
| **Pulau Huruf** | Beach | 🏖️ | #FFD93D |

---

## 10. ACCESSIBILITY RULES

### Visual Accessibility

| Aturan | Spesifikasi |
|--------|-------------|
| **Min font size** | 14px (kecuali caption) |
| **Touch target min** | 48x48px (idealnya 64px) |
| **Spacing antar touch** | Min 12px |
| **Color contrast text** | AA 4.5:1 (normal), 3:1 (large) |
| **Focus indicator** | Ring 4px #0F8B6F + offset 2px |
| **Reduce motion** | Respect OS setting — kurangi scale/opacity animation |

### Cognitive Accessibility (Untuk Anak)

| Prinsip | Implementasi |
|---------|--------------|
| **Konsistensi** | Semua tombol "kembali" di posisi sama |
| **Kesederhanaan** | Maks 1 action per screen untuk anak <6 |
| **Feedback** | Setiap tap ada respons visual + audio |
| **Error forgiveness** | Tidak ada "game over" — selalu "coba lagi" |
| **Reading support** | Tombol "dengarkan" untuk semua teks |
| **Visual clues** | Ikon selalu menyertai teks |
| **Progress visibility** | Selalu tunjukkan di mana posisi anak |

### Touch Target Minimum

| Elemen | Min Size | Ideal | Catatan |
|--------|----------|-------|---------|
| **Button** | 48x48 | 64x64 | Utama |
| **Icon button** | 44x44 | 48x48 | Navigasi |
| **Card** | Tap whole card | — | Jangan tap kecil |
| **Slider** | 48px thumb | 64px | Volume, progress |
| **Checkbox** | 36x36 | 44x44 | — |
| **Close button** | 44x44 | 48x48 | Modal |

### Audio & Haptic

| Interaksi | Audio | Haptic (iOS/Android) |
|-----------|-------|----------------------|
| **Tap button** | "Click" ringan | Light impact |
| **Correct answer** | "Ding!" ascending | Success |
| **Wrong answer** | "Bloop" rendah | Warning |
| **Reward** | "Fanfare" | Heavy + success |
| **Navigation** | "Swoosh" | Light |
| **Quest complete** | "Tada!" | Success + notification |

### Animation Safety

| Aturan | Detail |
|--------|--------|
| **Reduce motion support** | Deteksi OS setting — kurangi semua scale/parallax |
| **Max animation duration** | 2.5s untuk reward, 1s untuk transisi |
| **No rapid flashing** | Tidak ada animasi >3Hz (stroke/seizure safety) |
| **No auto-play video** | Semua video harus di-trigger |
| **Pause animation** | Butuh pause/stop untuk animasi looping |

---

## 11. DESIGN SYSTEM TOKENS SUMMARY

### Spacing

| Token | px | Usage |
|-------|-----|-------|
| space-1 | 4 | Icon padding |
| space-2 | 8 | Gap kecil |
| space-3 | 12 | Stack kecil |
| space-4 | 16 | Default padding |
| space-5 | 24 | Card padding |
| space-6 | 32 | Section gap |
| space-7 | 40 | Page margin |
| space-8 | 48 | Large space |
| space-9 | 64 | Section break |

### Radius

| Token | px | Usage |
|-------|-----|-------|
| radius-sm | 8 | Input |
| radius-md | 12 | Card mini |
| radius-lg | 16 | Card standard |
| radius-xl | 20 | Card utama |
| radius-2xl | 24 | Modal |
| radius-full | 9999 | Button, avatar |

### Shadow

| Token | Value | Usage |
|-------|-------|-------|
| shadow-sm | 1px 2px rgba(0,0,0,0.06) | Subtle |
| shadow-md | 3px 6px rgba(26,26,46,0.08) | Card default |
| shadow-lg | 6px 12px rgba(26,26,46,0.10) | Modal |
| shadow-xl | 12px 24px rgba(26,26,46,0.12) | Reward |

---

## 12. SCREEN TEMPLATES

### Home Screen Layout

```
┌──────────────────────────────────────┐
│  ┌─────────────────────────┐         │
│  │  Halo, [Nama]! 👋      │         │  ← Greeting
│  │  Selamat datang kembali!│         │
│  └─────────────────────────┘         │
│                                      │
│  ┌─────────────────────────┐         │
│  │  ┌──┐ ┌──┐ ┌──┐ ┌──┐  │         │  ← Daily Streak
│  │  │M │ │S │ │S │ │R │  │         │
│  │  └──┘ └──┘ └──┘ └──┘  │         │
│  └─────────────────────────┘         │
│                                      │
│  ┌─────────────────────────┐         │
│  │  🎮 Quest Hari Ini      │         │  ← Current Quest
│  │  ▓▓▓▓▓░░░░░░ 50%       │         │
│  │  Lanjut →               │         │
│  └─────────────────────────┘         │
│                                      │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │ H  │ │ L  │ │ K  │ │ P  │       │  ← World Access
│  └────┘ └────┘ └────┘ └────┘       │
│                                      │
│  ┌─────────────────────────┐         │
│  │  👤 Zelby: Level 5      │         │  ← Character Status
│  │  ⭐ Bintang: 150        │         │
│  └─────────────────────────┘         │
│                                      │
└──────────────────────────────────────┘
```

---

*END OF DESIGN SYSTEM — CONFIDENTIAL*
