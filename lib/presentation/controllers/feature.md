# Presentation Controllers Layer

## Overview
The **Presentation Controllers** layer contains global/shared controllers that are not tied to a single feature but are used across multiple screens. These are registered in `ServicesLocator` and available globally.

## File Structure

```
presentation/controllers/
├── daily_ayah_controller.dart        # DailyAyahController
├── elevated_button_controller.dart   # ElevatedButtonController
├── settings_controller.dart          # SettingsController
├── theme_controller.dart             # ThemeController
└── general/
    ├── general_controller.dart       # GeneralController
    ├── general_state.dart            # GeneralState
    └── extensions/
        ├── general_getters.dart      # Getter extensions
        └── general_ui.dart           # UI helper extensions
```

## Controllers

### `ThemeController` (`theme_controller.dart`)
- Manages app theme switching (light/dark/custom themes)
- Stores theme preference via `GetStorage`
- Provides `currentThemeData` getter
- `checkTheme()` — loads saved theme on startup
- `isDarkMode` — boolean check for current mode

### `GeneralController` (`general_controller.dart`)
- General-purpose controller for shared state
- **State** (`GeneralState`):
  - `fontSizeArabic` — Arabic text font size (reactive)
  - `screenSelectedValue` — selected screen type
  - `arabicNumber` — Arabic number formatter
  - `greeting` — time-based greeting text
- **Key Methods**:
  - `getLastPageAndFontSize()` — restores font size and last page from storage
  - `updateGreeting()` — sets greeting based on time of day
  - `eidDays` (getter) — checks if current Hijri date is during Eid

### `SettingsController` (`settings_controller.dart`)
- Manages app-level settings
- `loadLang()` — loads saved language preference
- Provides settings state

### `DailyAyahController` (`daily_ayah_controller.dart`)
- Manages the daily random Ayah feature on the home screen
- `getDailyAyah()` — returns a random Ayah (changes daily)
- `selectedTafsir` — randomly selected tafsir for the daily ayah
- `tafsirRadioValue` — which tafsir source to use
- Uses `QuranLibrary` for Ayah data and tafsir fetching

### `ElevatedButtonController` (`elevated_button_controller.dart`)
- Simple controller for elevated button animation state
- Manages press/release visual feedback

## Extensions

### `general_getters.dart`
- Extension getters on `GeneralController`
- Provides computed properties for commonly accessed state

### `general_ui.dart`
- UI helper extensions on `GeneralController`
- Provides methods for building common UI patterns

## Key Dependencies
- **Packages**: `get` (GetX), `get_storage`, `quran_library`
- **Used by**: Home screen, Quran, Splash, and all features that need theme/font/settings

## Registration
All controllers are registered in `ServicesLocator.init()` as lazy singletons via `Get.put(..., permanent: true)` + `sl.registerLazySingleton()`.

---

> **⚠️ EDIT LOG — If you edit this layer, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
