# Home Screen Feature

## Overview
The **Home Screen** is the main landing page of the app after splash. It serves as a dashboard displaying the Hijri date, navigation grid to all features, last reading position, daily Ayah with Tafsir, and daily Dhekr (supplication).

## Architecture
Simple screen with widget composition — no dedicated controller (uses shared controllers).

```
home/
├── home_screen.dart              # Main HomeScreen widget
├── data/
│   └── model/
│       └── adhan_data.dart       # Adhan (prayer times) data model
└── widgets/
    ├── ayah_tafsir_widget.dart   # Daily Ayah + Tafsir display
    ├── daily_zeker.dart          # Daily Dhekr card
    ├── hijri_widget.dart         # Hijri date display
    ├── last_read.dart            # Last read Quran position card
    └── screens_list.dart         # Navigation grid to all features
```

## Main Screen: `HomeScreen`
- Wrapped in `GetBuilder<ThemeController>` for theme reactivity
- Uses `ScreenUtilInit` for responsive sizing
- Gradient background from `primaryContainer`
- Contains `TabBarWidget` at top (with notification toggle)

### Portrait Layout (ListView):
1. `HijriWidget` — Current Hijri date
2. `ScreensList` — Navigation grid to all features
3. `LastRead` — Shows last read surah + page with progress bar
4. `AyahTafsirWidget` — Random daily Ayah with expandable Tafsir
5. `DailyZeker` — Random daily dhekr

### Landscape Layout:
- Two-column `Row`: Left (Hijri + LastRead), Right (ScreensList)
- Below: `AyahTafsirWidget` + `DailyZeker`

## Widgets Detail

### `ScreensList`
- Uses `screensList` from `core/utils/constants/lists.dart` — a predefined list of `Map` entries with `name`, `route`, `svgUrl`, `width`
- Renders a Wrap of `ElevatedButtonWidget` cards with SVG icons
- Tapping navigates via `Get.to(screensList[index]['route'])`
- Skips index 0 (presumably the home itself)

### `LastRead`
- Displays current surah name (SVG), page number, and a `LinearProgressIndicator` (page/604)
- Taps → `Get.to(QuranHome())` and scrolls to the current page
- Uses `QuranController` and `GeneralController`

### `AyahTafsirWidget`
- Uses `DailyAyahController.getDailyAyah()` → returns a random `AyahModel`
- Shows the Ayah text in Uthmanic font with surah name and tafsir source badge
- Expandable tafsir via `ReadMoreLess` widget
- Tafsir source is randomized from `tafsirNameRandom` list

### `DailyZeker`
- Uses `AzkarController.getDailyDhekr()` → returns a random `AdhkarData`
- Displays dhekr text with category badge

### `HijriWidget`
- Shows the current Hijri date

## Shared Controllers Used
| Controller | Used For |
|-----------|----------|
| `ThemeController` | Theme rebuilds |
| `QuranController` | Last read page/surah |
| `GeneralController` | Font sizes, greeting |
| `EventController` | Hijri date |
| `DailyAyahController` | Daily Ayah |
| `AzkarController` | Daily Dhekr |

## Key Dependencies
- **Widgets**: `TabBarWidget`, `ElevatedButtonWidget`, `ContainerWithLines`, `ReadMoreLess`
- **Data lists**: `screensList` and `tafsirNameRandom` from `core/utils/constants/lists.dart`
- **Packages**: `flutter_screenutil`, `gap`, `flutter_svg`

## Navigation
- Splash screen → `HomeScreen` (or `WhatsNewScreen` first)
- `ScreensList` → navigates to all features: Quran, Adhkar, Calendar, Books, Surah Audio, Al-Waqf, About App, Our Apps

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
