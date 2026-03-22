# Surah Audio Feature

## Overview
The **Surah Audio** feature provides full surah-level audio streaming. Users can browse all 114 surahs, select a reciter, play/pause/skip surahs, and view playback status with a seek bar. The UI features a collapsible/expandable player panel with smooth drag gestures.

## Architecture
Uses Dart `part` directive — `surah_audio.dart` is the library file.

```
surah_audio/
├── surah_audio.dart                     # Library file (imports + parts)
├── audio_surah.dart                     # AudioScreen widget (part)
├── controller/
│   ├── surah_audio_helper.dart          # AudioCtrl extension (part)
│   └── surah_audio_state.dart           # SurahAudioState (part)
└── widgets/
    ├── back_drop_widget.dart            # Background surah list (part)
    ├── collapsed_play_widget.dart       # Collapsed player bar (part)
    ├── last_listen.dart                 # Last listened surah indicator (part)
    ├── online_play_button.dart          # Play button with streaming (part)
    ├── play_banner.dart                 # Play banner/header (part)
    ├── play_widget.dart                 # Expanded player UI (part)
    ├── surah_audio_list.dart            # Full surah list for selection (part)
    ├── surah_search.dart                # Search surah by name/number (part)
    └── surah_seek_bar.dart              # Seek bar widget (part)
```

## Controller: `AudioCtrl` (extension via `SurahAudioHelper`)
- The controller logic is split between the main `AudioCtrl` (from `quran_library` package) and a local extension `SurahAudioHelper`
- Uses `SurahAudioState` for UI state
- Uses `SurahAudioStyle` for theming the audio components

### Key State (`SurahAudioState`)
| Field | Purpose |
|-------|---------|
| `audioPlayer` | The audio player instance |
| `selectedSurahIndex` | Currently selected surah |
| `isPlayExpanded` | Whether the player panel is expanded |
| `isSheetOpen` | Whether the surah list sheet is open |
| `surahListController` | ScrollController for surah list |

### Key Methods (from `SurahAudioHelper`)
| Method | Purpose |
|--------|---------|
| `searchSurah(String)` | Searches by surah name or number (supports Arabic numerals). Scrolls to found surah. |
| `jumpToSurah(int)` | Jumps to a surah in the list (opens sheet if needed) |
| `scrollToSelectedSurah(int)` | Smooth scroll to a surah with distance-based duration |
| `surahAudioStyle` (getter) | Returns themed `SurahAudioStyle` matching current theme |

## Main Screen: `AudioScreen`
- `PopScope` wrapping — stops audio on back
- Uses `Stack` layout:
  - **Background**: `BackDropWidget` — surah browsing list
  - **Foreground (bottom)**: Expandable player panel
- Player panel has **drag gesture** handling:
  - Swipe up → expand (`isPlayExpanded = true`)
  - Swipe down → collapse (`isPlayExpanded = false`)
- Uses `AnimatedCrossFade` between:
  - `CollapsedPlayWidget` (100px) — mini player
  - `PlayWidget` — full expanded player

## Player Components
| Widget | Purpose |
|--------|---------|
| `BackDropWidget` | Surah list with search, displayed behind the player |
| `CollapsedPlayWidget` | Mini player showing current surah + play/pause |
| `PlayWidget` | Full player with seek bar, skip, reader selection |
| `SurahSeekBar` | Audio progress bar using custom `SeekBar` widget |
| `OnlinePlayButton` | Streaming play button |
| `PlayBanner` | Surah name banner in player |
| `SurahSearch` | Animated search bar for finding surahs |
| `LastListen` | Shows last listened surah for quick resume |

## Key Dependencies
- **Package**: `quran_library` — provides `AudioCtrl`, `SurahAudioStyle`, surah data
- **Package**: `mini_music_visualizer` — audio visualizer animation
- **Package**: `scrollable_positioned_list` — efficient surah list scrolling
- **Package**: `anim_search_bar` — animated search input
- **Widgets**: `TabBarWidget`, `SeekBar` (from `core/widgets/`)
- **Services**: `NotificationsManager` for audio notifications
- **Extensions**: `convert_number_extension`, `highlight_extension`

## Navigation
- Home screen → `AudioScreen` (via `screensList`)
- Back button → stops audio + `Navigator.pop()`
- Notification tap → opens/resumes audio screen

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
