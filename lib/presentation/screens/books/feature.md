# Books (Tafsir Library) Feature

## Overview
The **Books** feature provides a digital library of Tafsir (Quranic interpretation) books. Users can browse available books, download them from GitHub, read them page-by-page, search across content, manage a personal library ("My Library"), and bookmark specific pages.

## Architecture
Full MVC with controller, state, extensions, data layer, screens, and widgets.

```
books/
├── controller/
│   ├── books_controller.dart              # Main BooksController
│   ├── books_bookmarks_controller.dart    # Bookmarks for books
│   ├── books_state.dart                   # BooksState class
│   └── extensions/
│       ├── books_getters.dart             # Getter extensions
│       ├── books_storage_getters.dart     # GetStorage persistence
│       └── books_ui.dart                  # UI helper extensions
├── data/
│   ├── data_sources/
│   │   ├── books_bookmark_database.dart   # Drift database for book bookmarks
│   │   └── books_bookmark_database.g.dart # Generated Drift code
│   └── models/
│       ├── books_model.dart               # Book model
│       ├── chapter_model.dart             # Chapter model
│       ├── page_model.dart                # PageContent model
│       └── part_model.dart                # Part model
├── screens/
│   ├── books_screen.dart                  # Main library screen (3 tabs)
│   ├── books_bookmarks_screen.dart        # Bookmarked pages screen
│   ├── chapters_screen.dart               # Chapter list for a book
│   └── read_view_screen.dart              # Page-by-page reading view
└── widgets/
    ├── all_books_build.dart               # Grid of all available books
    ├── book_cover_widget.dart             # Book cover card
    ├── book_details_widget.dart           # Book details bottom sheet
    ├── books_chapters_build.dart          # Chapter list builder
    ├── books_last_read.dart               # Last read indicator
    ├── books_tap_bar_widget.dart          # Tab bar (All / My Library / Bookmarks)
    ├── books_top_title_widget.dart        # Top title bar
    ├── my_library_build.dart              # Downloaded books grid
    └── search_screen.dart                 # Search bottom sheet
```

## Controller: `BooksController`
- **Singleton** via `GetInstance().putOrFind()`
- **State management**: GetX reactive (`BooksState` with `Rx` fields)

### Key Methods
| Method | Purpose |
|--------|---------|
| `fetchBooks()` | Loads book metadata from `assets/json/collections.json` |
| `downloadBook(int bookNumber)` | Downloads book JSON from GitHub (`alheekmahlib/Tafsir_books`) using Dio with progress tracking. Saves to app documents directory. **Not available on web.** |
| `getParts(int)` / `getChapters(int)` | Gets parts/chapters for a specific book |
| `getPages(int)` | Reads downloaded book JSON and returns all `PageContent` objects |
| `getChapterStartPage(int, String)` | Gets the page number where a chapter starts |
| `searchBooks(String, {int?})` | Full-text search across all downloaded books. Removes diacritics for matching, returns snippets with context. |
| `loadLastRead()` | Restores last reading position |
| `loadDownloadedBooks()` / `saveDownloadedBooks()` | Persist download state via GetStorage |

## Data Models
- **`Book`**: `bookNumber`, `bookName`, `description`, `parts[]`, etc.
- **`Part`**: `partName`, `chapters[]`
- **`Chapter`**: `chapterName`, page range
- **`PageContent`**: `title`, `content`, `pageNumber`, `footnotes`, `bookTitle`, `bookNumber`

## Data Sources
- **Metadata**: `assets/json/collections.json` (book catalog)
- **Book content**: Downloaded from `https://raw.githubusercontent.com/alheekmahlib/Tafsir_books/main/{bookNumber}.json`
- **Storage**: `getApplicationDocumentsDirectory()` for downloaded JSON files
- **Bookmarks**: Drift database (`books_bookmark_database.dart`)
- **Preferences**: GetStorage for download state and last read

## Screens
1. **`BooksScreen`** — Main screen with 3 tabs: All Books, My Library, Bookmarks. Has search and settings actions in AppBar.
2. **`ReadViewScreen`** — Page-by-page book reader with `PageController`
3. **`ChaptersScreen`** — Lists chapters for a specific book
4. **`BookBookmarksScreen`** — Shows bookmarked pages

## Key Dependencies
- **Network**: `Dio` for downloading books, `ConnectivityService` for checking connection
- **Database**: Drift for bookmarks
- **Storage**: GetStorage for persistence
- **Widgets**: `TabBarWidget`, `SettingsList`, `SearchScreen`
- **Extensions**: `highlight_extension` for search highlighting

## Navigation
- Home screen → `BooksScreen` (via `screensList`)
- Book tap → `ChaptersScreen` or `ReadViewScreen`
- Chapter tap → `ReadViewScreen` at specific page

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
