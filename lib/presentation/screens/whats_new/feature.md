# What's New Feature

## Overview
The **What's New** screen displays new features introduced in the latest app update. It appears once after an update (before the home screen), showing a page-view carousel of new features with a "Continue" button. If already seen for the current version, it skips directly to the home screen.

## Architecture
Uses Dart `part` directive — `whats_new.dart` is the library file.

```
whats_new/
├── whats_new.dart                           # Library file (imports + parts)
├── controller/
│   ├── whats_new_controller.dart            # WhatsNewController (part)
│   ├── whats_new_state.dart                 # WhatsNewState (part)
│   └── extensions/
│       └── whats_new_getters.dart           # Getter extensions (part)
└── screen/
    ├── whats_new_screen.dart                # WhatsNewScreen widget (part)
    └── widgets/
        ├── button_widget.dart               # Continue/skip button (part)
        ├── page_view_build.dart             # PageView carousel (part)
        ├── smooth_page_indicator.dart       # Page dots indicator (part)
        └── whats_new_widget.dart            # Single feature card (part)
```

## Controller: `WhatsNewController`
- **Singleton** via `GetInstance().putOrFind()`
- Registered as lazy singleton in `ServicesLocator`

### Key State (`WhatsNewState`)
| Field | Purpose |
|-------|---------|
| `newFeatures` | List of new feature data to display |
| `pageController` | PageView controller |
| `currentPage` | Currently viewed page index |

### Key Methods
| Method | Purpose |
|--------|---------|
| `navigationPage()` | Called after splash timer. Checks if current version's what's new has been seen. If yes → navigate to `HomeScreen` via `SelectScreenBuild`. If no → show `WhatsNewScreen`. Uses `GetStorage` with version-based key. |

## Navigation Flow
```
SplashScreen (3s) → WhatsNewController.navigationPage()
  ├── Version already seen → HomeScreen (SelectScreenBuild)
  └── Version not seen → WhatsNewScreen
      ├── User browses features via PageView
      └── User taps "Continue" → marks version as seen → HomeScreen
```

## Screen: `WhatsNewScreen`
- Receives `newFeatures` list as parameter
- Displays a `PageView` carousel of feature cards (`WhatsNewWidget`)
- Has a `SmoothPageIndicator` showing current position
- "Continue" button navigates to `HomeScreen` and persists that version was seen

## Key Dependencies
- **Package**: `smooth_page_indicator` — page dots
- **Storage**: `GetStorage` — persists whether the user has seen the current version's features
- **Constants**: `SharedPreferencesConstants` for storage keys
- **Widgets**: `ElevatedButtonWidget`, `SelectScreenBuild`
- **Screen**: `ScreenType` enum for screen type selection

## Integration with Splash
- `SplashScreenController.startTime()` calls `WhatsNewController.instance.navigationPage()` after splash animation completes
- The splash controller can switch its `customWidget` to show `WhatsNewScreen` directly in the splash flow

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
