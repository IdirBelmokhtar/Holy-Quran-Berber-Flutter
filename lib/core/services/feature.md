# Core Services Layer

## Overview
The **Core Services** layer provides cross-cutting infrastructure: dependency injection, API networking, notifications, background tasks, connectivity monitoring, localization, error handling, and home widget integration.

## File Structure

```
core/services/
├── services_locator.dart          # Dependency injection setup (GetIt + GetX)
├── api_client.dart                # HTTP client wrapper (Dio-based)
├── background_services.dart       # Background task scheduling (Workmanager)
├── connectivity_service.dart      # Network connectivity monitoring
├── error_handling_system.dart     # Global error handling
├── home_widget_service.dart       # Native home/widget integration
├── local_notifications.dart       # Local notification scheduling
├── notifications_helper.dart      # Awesome Notifications wrapper
├── notifications_manager.dart     # Notification lifecycle manager
└── languages/
    ├── app_constants.dart          # Language/locale constants
    ├── dependency_inj.dart         # Language dependency injection
    ├── language_models.dart        # Language data models
    ├── localization_controller.dart # Localization controller (GetX)
    └── messages.dart               # Translation messages class
```

## Key Services

### `ServicesLocator` (`services_locator.dart`)
- Uses **GetIt** (`sl`) + **GetX** (`Get.put`) for dual DI registration
- Registers all controllers as lazy singletons (permanent)
- Sets desktop window size for macOS/Windows/Linux
- Initializes timezone, `RateMyApp`, and audio service
- **Controllers registered**: ThemeController, GeneralController, QuranController, TafsirAndTranslateController, BookmarksController, QuranSearchController, SettingsController, AzkarController, ShareController, PlayListController, SplashScreenController, OurAppsController, KhatmahController, DailyAyahController, BooksController, WhatsNewController, LocalNotificationsController

### `ApiClient` (`api_client.dart`)
- Dio-based HTTP client with `Either<Failure, dynamic>` return type
- Supports GET/POST methods
- Error handling with custom `Failure` class

### `NotifyHelper` (`notifications_helper.dart`)
- Wraps `awesome_notifications` package
- `initAwesomeNotifications()` — initializes notification channels
- `scheduledNotification()` — creates scheduled notifications
- `requistPermissions()` — requests notification permissions
- Action handlers for notification create/display/dismiss/tap
- On notification tap: routes to Adhkar category if it's a reminder

### `BackgroundServices` (`background_services.dart`)
- Uses `Workmanager` for background task scheduling
- Registers periodic/one-off background tasks
- Platform-guarded (iOS/Android only)

### `ConnectivityService` (`connectivity_service.dart`)
- Monitors network connectivity state
- Exposes `noConnection` reactive flag
- Used by `BooksController` before downloads

### `HomeWidgetService` (`home_widget_service.dart`)
- Integrates with native home screen widgets
- Updates widget data (daily ayah, etc.)

### `ErrorHandlingSystem` (`error_handling_system.dart`)
- Global error handling and reporting
- Custom error display via snackbars

### Language System (`languages/`)
- `LocalizationController` — manages current locale, saves preference
- `Messages` — GetX translations class, loads from JSON
- `dependency_inj.dart` — initializes language JSON loading
- `AppConstants` — supported languages list
- `LanguageModels` — language metadata

## Key Dependencies
- **Packages**: `get_it`, `get`, `awesome_notifications`, `dio`, `flutter_timezone`, `workmanager`, `desktop_window`
- **Used by**: All features across the app

---

> **⚠️ EDIT LOG — If you edit this layer, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
