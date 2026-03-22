# Al-Waqf (Quranic Pause Signs) Feature

## Overview
The **Al-Waqf** screen teaches users about Quranic pause signs (علامات الوقف). It displays waqf symbols with their explanations, supporting multi-language translations. Users can browse different waqf signs with images and descriptions filtered by the current app language.

## Architecture
Clean MVC with controller, model, service, and widgets.

```
alwaqf_screen/
├── alwaqf_screen.dart            # Main screen (AlwaqfScreen)
├── controller/
│   └── waqf_controller.dart      # WaqfController (GetxController)
├── models/
│   └── waqf_model.dart           # WaqfModel data class
├── services/
│   └── waqf_service.dart         # WaqfService — loads JSON data
└── widgets/
    ├── group_buttons_widget.dart  # Filter/category buttons
    └── waqf_list_build.dart      # Waqf items list builder
```

## Controller: `WaqfController`
- **Singleton** via `GetInstance().putOrFind()`
- **State**: `waqfList` — `RxList<WaqfModel>` reactive list
- Loads waqf data on `onInit()` and re-loads on language change

### Key Methods
| Method | Purpose |
|--------|---------|
| `loadWaqfData()` | Loads JSON data via `WaqfService`, filters translations by current locale (`Get.locale?.languageCode`) |

## Data Model: `WaqfModel`
```dart
class WaqfModel {
  final String image;                    // Image asset path for the waqf sign
  final Map<String, String> translations; // Language code → description
}
```

## Data Source
- **JSON**: `assets/json/waqf_translated.json`
- Loaded via `rootBundle.loadString()` in `WaqfService.loadWaqfData()`

## Main Screen: `AlwaqfScreen`
- `Scaffold` with `AppBarWidget` (no title, has font size option)
- Body: RTL `Column` with:
  - `GroupButtonsWidget` (flex 1-2) — filter/category buttons
  - Horizontal divider
  - `WaqfListBuild` (flex 9) — scrollable list of waqf items

## Key Dependencies
- **Widgets**: `AppBarWidget` (from `core/widgets/`)
- **Extensions**: `extensions.dart` for `customOrientation()` and `hDivider()`
- **Localization**: Language-aware data filtering via `Get.locale`

## Navigation
- Navigated **to** from the home screen via `screensList`
- No sub-navigation (single screen)

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
