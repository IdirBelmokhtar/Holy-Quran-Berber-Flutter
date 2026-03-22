# Splash Screen Feature

## Overview
The **Splash Screen** is the app's entry point — displaying an animated brand intro with the app logo, title, a Hijri greeting, and a loading indicator. After 3 seconds, it transitions to the home screen (or "What's New" screen if there are new features to show).

## Architecture
Uses Dart `part` directive — `splash.dart` ties together controller, state, and screen parts.

```
splash/
├── splash.dart                          # Library file (imports + parts)
├── controller/
│   ├── splash_screen_controller.dart    # SplashScreenController (part)
│   └── splash_screen_state.dart         # SplashState (part)
└── screen/
    ├── splash_screen.dart               # SplashScreen widget (part)
    └── widgets/
        ├── logo_and_title.dart          # Logo + title widget (part)
        └── alheekmah_and_loading.dart   # Loading indicator widget (part)
```

## Controller: `SplashScreenController`
- **Singleton** via `GetInstance().putOrFind()`
- Orchestrates splash animations and initial data loading

### Initialization Timeline (`onInit`)
| Time | Action |
|------|--------|
| 0ms | `_loadInitialData()` — loads all saved states |
| 600ms | Triggers container animation start |
| 2800–2950ms | Small container height animations (staggered) |
| 3000ms | Container expands to full height, switches widget to LogoAndTitle |
| 1s | `startTime()` → sets animate = true |
| 4s | Calls `WhatsNewController.navigationPage()` to decide next screen |

### Key Methods
| Method | Purpose |
|--------|---------|
| `_loadInitialData()` | Loads translate values, language, last page/font, switch value, greeting, screen selection from persistence |
| `startTime()` | Triggers animations and navigation after delay |
| `ramadhanOrEidGreeting()` | Returns themed greeting widget during Ramadan or Eid |
| `customWidget` (getter) | Switches between `LogoAndTitle` (0) and `WhatsNewScreen` (1) |

## State: `SplashState`
| Field | Purpose |
|-------|---------|
| `containerHeight`, `containerHHeight` | Animated container dimensions |
| `smallContainerHeight`, etc. | Staggered animation heights |
| `containerAnimate` | Animation trigger flag |
| `animate` | Main animate flag |
| `customWidget` | Current widget index (0 = logo, 1 = what's new) |
| `today` | Current HijriDate |
| `generalCtrl` | Reference to GeneralController |

## Controllers Loaded at Splash
- `TafsirAndTranslateController` → translate values
- `SettingsController` → language
- `GeneralController` → last page, font size, greeting
- `QuranController` → switch value, last page
- `WhatsNewController` → navigation decision

## Navigation Flow
```
App Launch → SplashScreen → (3s animation)
  ↓
WhatsNewController.navigationPage()
  ├── If new features exist → WhatsNewScreen → HomeScreen
  └── If no new features → HomeScreen directly
```

## Key Dependencies
- **Packages**: `flutter_screenutil`, `flutter_svg`, `hijri_date`, `get_storage`
- **Widgets**: `ContainerWithBorder`, `LogoAndTitle`, `AlheekmahAndLoading`
- **Constants**: `SvgPath`, `LottieConstants`, `SharedPreferencesConstants`
- **Controllers**: Multiple controllers initialized here

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
