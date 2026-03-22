# Our Apps Feature

## Overview
The **Our Apps** screen showcases other applications developed by Alheekmah. It fetches app data from a remote API and displays them in a grid. Users can tap an app to open its store listing.

## Architecture
Standard MVC with controller, data model, and screen.

```
ourApp/
├── controller/
│   └── ourApps_controller.dart    # OurAppsController
├── data/
│   └── models/
│       └── ourApp_model.dart      # OurAppInfo model
└── screen/
    ├── ourApps_screen.dart        # OurApps main screen
    └── widgets/
        └── our_apps_build.dart    # App grid builder widget
```

## Controller: `OurAppsController`
- **Singleton** via `GetInstance().putOrFind()`
- Registered as lazy singleton in `ServicesLocator`

### Key Methods
| Method | Purpose |
|--------|---------|
| `fetchApps()` | Fetches app list from `ApiConstants.ourAppsUrl` using `ApiClient`. Returns `List<OurAppInfo>`. Handles both String and List response types. Uses `Either` pattern (fold) for error handling. |
| `launchURL(context, index, OurAppInfo)` | Opens app store URL via `url_launcher` using `ApiConstants.downloadAppsUrl + appName` |

## Data Model: `OurAppInfo`
Contains app metadata like `appName`, icon URL, description, etc. Parsed from JSON via `OurAppInfo.fromJson()`.

## Data Source
- **Remote API**: `ApiConstants.ourAppsUrl` — fetched via `ApiClient` (HTTP GET)
- **Store links**: `ApiConstants.downloadAppsUrl` + app name

## Main Screen: `OurApps`
- AppBar with app icon (SVG) and back arrow
- Body layout:
  - **Portrait**: Column — app icon SVG → `ContainerWithLines` wrapping `OurAppsBuild` → Alheekmah logo at bottom
  - **Landscape**: Row — left (icon + logo), right (`OurAppsBuild`)
- `fetchApps()` is called in `build()` method

## Key Dependencies
- **Network**: `ApiClient` (from `core/services/api_client.dart`) for HTTP requests
- **Package**: `url_launcher` for opening store links
- **Widgets**: `ContainerWithLines` (from `core/widgets/`)
- **Constants**: `ApiConstants` for URLs, `SvgPath` for icons
- **Extensions**: `alignment_rotated_extension`, `svg_extensions`, `extensions`

## Navigation
- Home screen → `OurApps` (via `screensList`)
- App tap → external URL (app store)
- Back via `Get.back()`

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
