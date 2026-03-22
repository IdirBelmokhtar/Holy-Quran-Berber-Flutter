# Database Layer

## Overview
The **Database** layer manages local SQLite persistence using the **Drift** ORM. It handles two primary storage concerns: Quran/Adhkar bookmarks and notification records.

## File Structure

```
database/
├── bookmark_db/
│   ├── bookmark_database.dart       # Main Drift database definition
│   ├── bookmark_database.g.dart     # Auto-generated Drift code
│   ├── db_bookmark_helper.dart      # Static helper methods for CRUD operations
│   └── connection/
│       ├── connection.dart           # Platform connection factory
│       ├── native.dart              # Native (iOS/Android/Desktop) connection
│       ├── unsupported.dart         # Unsupported platform fallback
│       └── web.dart                 # Web platform connection
└── notificationDatabase.dart        # Notification storage database
```

## Bookmark Database

### Database Definition (`bookmark_database.dart`)
- Drift `@DriftDatabase` annotation with tables: `Adhkar` (table defined in `dheker_model.dart`)
- Multi-platform support via `connection/` directory
- Schema version management for migrations

### Tables
| Table | Columns | Used By |
|-------|---------|---------|
| `Adhkar` | `id`, `category`, `count`, `description`, `reference`, `zekr` | Adhkar favorites |

### Helper (`db_bookmark_helper.dart`)
Static methods for database operations:
| Method | Purpose |
|--------|---------|
| `addAdhkar(AdhkarCompanion)` | Insert a bookmarked dhekr |
| `getAllAdhkar()` | Retrieve all bookmarked adhkar |
| `deleteAdhkar(category, zekr)` | Delete a specific bookmark |
| `updateAdhkar(companion, id)` | Update a bookmark |

### Platform Connections
- **Native** (`native.dart`): Uses `NativeDatabase` with `path_provider`
- **Web** (`web.dart`): Uses `WebDatabase` with IndexedDB
- **Unsupported** (`unsupported.dart`): Throws error for unsupported platforms
- Connection factory in `connection.dart` selects the right implementation

## Notification Database (`notificationDatabase.dart`)
- Stores notification records
- Tracks read/unread state and badge counts

## Key Dependencies
- **Package**: `drift` (SQLite ORM for Dart/Flutter)
- **Package**: `path_provider` (for database file location)
- **Package**: `sqlite3_flutter_libs` (native SQLite)
- **Used by**: Adhkar bookmark feature, Quran bookmark feature, notification system

## Additional Drift Databases (in feature directories)
Note: Other Drift databases exist within feature directories:
- `books/data/data_sources/books_bookmark_database.dart` — Book bookmarks
- `quran_page/widgets/khatmah/data/data_source/khatmah_database.dart` — Khatmah tracking

---

> **⚠️ EDIT LOG — If you edit this layer, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
