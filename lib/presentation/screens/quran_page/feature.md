# Quran Page Feature

## Overview
The **Quran Page** is the core feature of the app — a full Quran reader with Mushaf display, ayah-by-ayah audio playback, tafsir (interpretation), Berber translation, bookmarks, khatmah (reading plan) tracking, text search, sharing, and customizable display settings. This is the largest and most complex feature in the application.

## Architecture
Uses Dart `part` directive extensively — `quran.dart` is the library file that ties together 60+ part files. The feature includes multiple sub-controllers, widgets, and data models.

```
quran_page/
├── quran.dart                          # Library file with all imports & parts
├── controllers/
│   ├── quran/
│   │   ├── quran_controller.dart       # Main QuranController
│   │   └── quran_state.dart            # QuranState class
│   ├── audio/
│   │   └── audio_state.dart            # Audio playback state
│   ├── bookmarks_controller.dart       # BookmarksController
│   ├── khatmah_controller.dart         # KhatmahController (reading plans)
│   ├── playList_controller.dart        # PlayListController (audio playlists)
│   ├── share_controller.dart           # ShareController (screenshot & share)
│   └── translate_controller.dart       # TafsirAndTranslateController
│   └── extensions/
│       ├── audio/
│       │   ├── audio_ui.dart           # Audio UI widgets
│       │   └── audio_continuous_mode.dart # Continuous play mode
│       ├── quran/
│       │   ├── quran_getters.dart       # Quran data getters
│       │   └── quran_ui.dart           # Quran UI helpers
│       └── tafsir/
│           └── tafsir_ui.dart          # Tafsir UI
├── data/
│   └── model/
│       ├── aya.dart                    # Aya model
│       ├── bookmark.dart               # Bookmark model
│       └── bookmark_ayahs.dart         # Ayah bookmark model
├── extensions/
│   ├── bookmark_page_icon_path.dart    # Bookmark icon switching
│   └── surah_name_with_banner.dart     # Surah name SVG helpers
├── screens/
│   ├── quran_home.dart                 # Main Quran home (slider drawer)
│   └── quran_page.dart                 # Page view for Mushaf
└── widgets/
    ├── audio/                          # Audio playback widgets
    │   ├── audio_widget.dart           # Main audio bar
    │   ├── play_ayah_widget.dart       # Ayah play controls
    │   ├── skip_next.dart / skip_previous.dart  # Skip controls
    │   └── change_reader.dart          # Reciter selection
    ├── ayahs/                          # Ayah display widgets
    │   ├── ayah_build.dart             # Single ayah builder
    │   ├── ayahs_widget.dart           # Ayahs list widget
    │   ├── ayahs_menu.dart             # Long-press menu
    │   ├── share_copy_widget.dart      # Share/copy actions
    │   └── translate_build.dart        # Translation display
    ├── berber_translate_sheet.dart      # Berber translation bottom sheet
    ├── bookmarks/                      # Bookmark management
    │   ├── bookmarks_list.dart         # Bookmarks tab
    │   ├── bookmark_pages_build.dart   # Page bookmarks
    │   ├── bookmark_ayahs_build.dart   # Ayah bookmarks
    │   └── khatmah_bookmarks_screen.dart  # Khatmah bookmarks
    ├── buttons/                        # Action buttons
    │   ├── add_bookmark_button.dart    # Bookmark toggle
    │   ├── berber_translate_button.dart # Berber translation button
    │   ├── copy_button.dart            # Copy to clipboard
    │   ├── play_button.dart            # Play audio
    │   └── tafsir_button.dart          # Show tafsir
    ├── khatmah/                        # Khatmah (reading plan)
    │   ├── data/data_source/khatmah_database.dart  # Drift database
    │   ├── data/model/khatmah_model.dart           # Khatmah model
    │   ├── screen/khatmahs_screen.dart              # Khatmah list
    │   └── widgets/                                 # Khatmah UI widgets
    ├── pages/                          # Mushaf page rendering
    │   ├── left_page.dart / right_page.dart  # Page layout
    │   ├── text_build.dart             # Ayah text building
    │   ├── custom_span.dart            # Custom styled spans
    │   └── nav_bar_widget.dart         # Navigation bar
    ├── playlist/                       # Audio playlist
    │   ├── playList_build.dart         # Playlist UI
    │   ├── playList_play_widget.dart   # Playlist player
    │   └── ...                         # Other playlist widgets
    ├── search/                         # Quran search
    │   ├── quran_search.dart           # Search screen
    │   ├── search_bar.dart / search_bar_widget.dart  # Search input
    │   ├── last_search_widget.dart     # Recent searches
    │   └── controller/quran_search_controller.dart   # Search logic
    ├── screen_switch.dart              # Switch between page/list mode
    ├── quran_surah_list.dart           # Surah list
    ├── surah_juz_list.dart             # Surah/Juz navigation list
    └── juz_page.dart                   # Juz page display
```

## Main Controller: `QuranController`
- **Singleton** via `GetInstance().putOrFind()`
- **State**: `QuranState` with reactive fields

### Key State Fields
| Field | Purpose |
|-------|---------|
| `currentPageNumber` | Currently viewed page (1–604) |
| `lastReadSurahNumber` | Last read surah number |
| `isPageMode` | Toggle between page/list reading mode |
| `backgroundPickerColor` | Custom background color |
| `surahs`, `allAyahs`, `pages` | Quran data from `QuranLibrary` |

### Key Methods
| Method | Purpose |
|--------|---------|
| `loadQuran()` | Loads surah/ayah/page data from `QuranLibrary` |
| `updateTafsir(int pageIndex)` | Fetches tafsir for current page |
| `currentListPageNumber()` | Tracks scroll position in list mode |
| `getLastPage()` | Restores last reading position |
| `loadSwitchValue()` | Loads page/list mode preference |

## Sub-Controllers
| Controller | Purpose |
|-----------|---------|
| `TafsirAndTranslateController` | Manages tafsir selection and Berber translation display |
| `BookmarksController` | Page and ayah bookmarks (Drift database) |
| `KhatmahController` | Reading plan tracking (Drift database) |
| `ShareController` | Screenshot and share ayah/page as image |
| `PlayListController` | Custom audio playlists |
| `QuranSearchController` | Full-text Quran search |

## Data Sources
- **`QuranLibrary` package**: Provides all Quran text, surah metadata, ayah data
- **Drift databases**: Bookmarks, Khatmah, playlist storage
- **GetStorage**: Last page, reading mode, font preferences
- **Remote**: Audio streaming from Quran.com API
- **Assets**: Surah name SVGs, translation JSON files

## Screens
1. **`QuranHome`** — Main screen with `SliderDrawer`. Slider contains surah/juz lists, bookmarks, khatmah, search. Main body shows the Mushaf or ayah list.
2. **`QuranPage`** — Page-by-page Mushaf display using `ScrollablePositionedList`

## Berber Translation
- `BerberTranslateButton` — triggers Berber translation bottom sheet
- `BerberTranslateSheet` — displays Kabyle Berber translation with audio playback
- Translation data loaded from JSON/images in assets

## Audio System
- Ayah-by-ayah audio playback with seek bar
- Reader selection (multiple reciters)
- Continuous mode (auto-play next ayah)
- Audio playlist feature for custom selections

## Key Dependencies
- **Package**: `quran_library` — core Quran data
- **Package**: `scrollable_positioned_list` — efficient scrolling
- **Package**: `flutter_slider_drawer` — side drawer navigation
- **Package**: `screenshot` / `share_plus` — capture & share
- **Package**: `flex_color_picker` — background color customization
- **Package**: `rate_my_app` — app rating prompt
- **Database**: Drift for bookmarks, khatmah, playlists
- **Storage**: GetStorage for preferences

## Navigation
- Home screen → `QuranHome` (primary navigation)
- `LastRead` widget → `QuranHome` at last position
- Surah/Juz tap → scrolls to specific page
- Internal: drawer panels for bookmarks, search, khatmah, playlists

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
