# Adhkar (Azkar / Supplications) Feature

## Overview
The **Adhkar** feature provides Islamic supplications (أذكار) with category-based browsing, favorites (bookmarking), sharing (text & image), and notification reminders. Users can browse azkar by category, bookmark favorites to a local database, and share dhekr as text or rendered images.

## Architecture
Full MVC pattern with controller, state, models, screens, and widgets.

```
adhkar/
├── controller/
│   ├── adhkar_controller.dart    # Main controller (AzkarController)
│   ├── adhkar_state.dart         # State class (AdhkarState)
│   ├── extensions/
│   │   └── adhkar_getters.dart   # Extension getters (e.g., getDailyDhekr)
│   └── reminder/
│       └── reminder_controller.dart  # Reminder/notification scheduling
├── models/
│   └── dheker_model.dart         # Drift table definition (Adhkar)
├── screens/
│   ├── adhkar_view.dart          # Main view with TabBar (Azkar | Favorites)
│   ├── adhkar_item.dart          # List of dhekr items in a category
│   └── adhkar_fav.dart           # Favorites list (bookmarked adhkar)
└── widgets/
    ├── adhkar_list.dart           # Adhkar list builder
    ├── azkar_reminder_widget.dart # Reminder toggle UI
    ├── options_row.dart           # Options per dhekr (bookmark, share, etc.)
    ├── text_widget.dart           # Dhekr text display widget
    ├── tab_bar_view_widget.dart   # TabBarView for azkar/favorites tabs
    └── share/
        ├── share_dhekrToImage.dart    # Render dhekr as image for sharing
        └── share_dhekr_options.dart   # Share options (text vs image)
```

## Controller: `AzkarController`
- **Singleton** via `GetInstance().putOrFind()`
- **State management**: GetX (`GetxController` + `Obx`)
- **Key state** (`AdhkarState`):
  - `allAdhkar` / `filteredDhekrList` — all azkar / filtered by category
  - `adhkarList` / `filteredFavDhekrList` — bookmarked favorites
  - `categories` — unique category list
  - `dhekrOfTheDay` — daily random dhekr
  - `dhekrScreenController` / `dhekrToImageBytes` — screenshot capture for sharing

### Key Methods
| Method | Purpose |
|--------|---------|
| `fetchDhekr()` | Loads azkar from `assets/json/azkar.json`, extracts categories |
| `filterByCategory(String)` | Filters main list by category |
| `addAdhkar(AdhkarData)` | Bookmarks a dhekr to the Drift database |
| `deleteAdhkar(AdhkarData)` | Removes a bookmark from database |
| `getAdhkar()` | Loads all bookmarked adhkar from database |
| `hasBookmark(category, zekr)` | Checks if a dhekr is bookmarked |
| `buildTextSpans(String)` | Parses `{Quranic text}` patterns into styled TextSpans |
| `shareText(...)` | Shares dhekr as plain text via `SharePlus` |
| `createAndShowZekrImage()` | Screenshots dhekr widget for image sharing |
| `shareZekr()` | Shares rendered dhekr image via `SharePlus` |
| `onAdhkarNotificationsReceived(String)` | Handles notification tap → navigates to category |

## Data Model
**Drift table** (`Adhkar` in `dheker_model.dart`):
- `id` (auto-increment), `category`, `count`, `description`, `reference`, `zekr`
- Database operations go through `DbBookmarkHelper`

## Data Source
- **JSON**: `assets/json/azkar.json` — loaded via `rootBundle.loadString()`
- **Database**: Drift (SQLite) via `bookmark_database.dart` for favorites

## Screens
1. **`AdhkarView`** — TabBar with 2 tabs: "azkar" (all) and "azkarfav" (favorites)
2. **`AdhkarItem`** — Displays filtered dhekr list for a selected category. Each item shows `OptionsRow` + `TextWidget`
3. **`AdhkarFav`** — Shows bookmarked adhkar with staggered animations

## Key Dependencies
- **Database**: `bookmark_database.dart`, `db_bookmark_helper.dart` (Drift)
- **Sharing**: `share_plus` package, `screenshot` package
- **Notifications**: `reminder_controller.dart` for scheduling reminders
- **Widgets**: `AppBarWidget`, `TabBarWidget`
- **Localization**: GetX `.tr`

## Navigation
- Home screen → `AdhkarView` (via `screensList`)
- Category tap → `AdhkarItem`
- Notification tap → `AdhkarView` → `AdhkarItem` (via `onAdhkarNotificationsReceived`)

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
