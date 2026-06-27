# PHASE 15.1A — Test Screen UI Fix Report

## Overview

Removed debug chips and pink accent colors from the child-facing lesson/test screen. Applied a clean gray/neutral answer choice style with proper CTA states.

## Files Changed

### `lib/features/lesson/presentation/lesson_screen.dart`
- **Removed** `_buildBrainStatusRow()` call from build method (line 335)
- **Removed** `_buildBrainStatusRow()` method (was lines 496–525)
- **Removed** `_buildStatusChip()` method (was lines 527–556)
- **Refactored** `_buildGameButton()` — replaced accent-based gradient colors with solid gray/neutral palette

### `lib/features/lesson/presentation/widgets/answer_button.dart`
- **Removed** `accentColor` parameter
- **Removed** `_baseColor` getter
- **Replaced** all color logic with fixed gray/neutral/correct/wrong colors

### `lib/features/lesson/presentation/widgets/lesson_bottom_action.dart`
- **Removed** `import '../../../../app/theme/app_colors.dart'` (no longer needed)
- **Replaced** gradient+opacity CTA with solid-color approach
- **Updated** disabled state: background `#E5E7EB`, text `#9CA3AF`
- **Updated** enabled state: background `#24C96B`, white text, visible shadow
- **Fixed** safe area: uses `MediaQuery.of(context).padding.bottom + 24`

## Debug Chips Removed

| Chip | Source | Removed From |
|------|--------|-------------|
| "Mode Adaptif" | `_focusLabel` variable | `_buildBrainStatusRow()` |
| "Pemanasan" | `brainQuestion.difficulty.label` | `_buildBrainStatusRow()` |
| "Latih fokus memilih kata yang tepat." | `brainQuestion.microGoal` | `_buildBrainStatusRow()` |

## Answer Choice Color Palette

| State | Background | Border | Text |
|-------|-----------|--------|------|
| Normal | `#F7F8FA` | `#E5E7EB` | `#263238` |
| Selected | `#F0F7FF` | `#60A5FA` | `#60A5FA` |
| Correct | `#DDFBEA` | `#24C96B` | `#24C96B` |
| Wrong | `#FFF3D6` | `#FFB545` | `#FFB545` |

## CTA Button States

| State | Background | Text | Shadow |
|-------|-----------|------|--------|
| Disabled | `#E5E7EB` | `#9CA3AF` | None |
| Enabled | `#24C96B` | White | Green 25% opacity, 12px blur |
| Success | `#24C96B` | White | Green 25% opacity, 12px blur |
| Danger | `#FF6B6B` | White | Coral 25% opacity, 12px blur |

## QA Results

- `flutter analyze lib/` — **0 errors, 0 warnings** (3 pre-existing info-lints)
- `flutter test` — **25 pass, 5 fail** (5 widget test failures are pre-existing: GoRouter + Hive dependency in test harness)

## Screenshot Checklist

- [x] No "Mode Adaptif" chip
- [x] No "Pemanasan" chip
- [x] No "Latih fokus..." banner
- [x] Answer choices are gray/white, not pink
- [x] CTA enabled after answer selected
- [x] No overflow
- [x] Clean kids premium look
