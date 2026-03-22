# Core Widgets Layer

## Overview
The **Core Widgets** layer provides reusable, shared UI components used across multiple features. These are generic widgets not tied to any specific feature.

## File Structure

```
core/widgets/
├── app_bar_widget.dart            # Reusable AppBar with settings, search, notifications, font size
├── container_with_border.dart     # Styled container with rounded border
├── container_with_lines.dart      # Container with decorative horizontal lines
├── custom_button.dart             # Custom animated button widget
├── delete_widget.dart             # Delete confirmation dialog widget
├── elevated_button_widget.dart    # Themed elevated button
├── elevated_layer_button.dart     # Multi-layer elevated button with shadow
├── language_list.dart             # Language selection list widget
├── measure_size_widget.dart       # Widget that reports its size via callback
├── mushaf_settings.dart           # Quran display settings panel (fonts, colors, modes)
├── seek_bar.dart                  # Audio seek bar widget (used by Quran & Surah audio)
├── select_screen.dart             # Screen selection widget
├── select_screen_build.dart       # Screen selection builder (builds navigation grid)
├── settings_list.dart             # General settings list (theme, font, language, etc.)
├── shimmer_effect_build.dart      # Shimmer loading effect widget
├── tab_bar_widget.dart            # Reusable TabBar with back button, settings, notifications
├── theme_change.dart              # Theme selection/preview widget
├── time_now.dart                  # Current time display widget
├── custom_paint/
│   └── custom_slider.dart         # Custom painted slider widget
├── home_widget/
│   └── hijri_home_widget_controller.dart  # Controller for native home widget
├── local_notification/
│   └── controller/
│       └── local_notifications_controller.dart  # Local notification management
├── read_more_less/
│   └── read_more_less.dart        # Expandable "Read more / Read less" text widget
└── share/
    └── share_ayah_options.dart    # Share ayah options (text, image, clipboard)
```

## Key Widgets

### `AppBarWidget`
- Configurable AppBar with optional: title, font size button, search button, notification button, book mode
- Used by: Adhkar, Al-Waqf, and other screens

### `TabBarWidget`
- Main navigation bar at top of screens
- Supports: back button, center child, settings access, notification access, calendar settings
- Used by: Home, Adhkar, Calendar, Quran, etc.

### `SeekBar`
- Custom audio seek bar with duration display
- Used by both Quran ayah audio and Surah audio features

### `MushafSettings`
- Comprehensive Quran display settings panel
- Controls: font selection, background color, reading mode, Mushaf type, etc.

### `SettingsList`
- General app settings list (language, theme, font size, etc.)
- Shown as bottom sheet from various screens

### `SelectScreenBuild`
- Navigation grid for selecting which screen to show (used in splash/whats_new flow)

### `ShimmerEffectBuild`
- Loading placeholder with shimmer animation
- Used while content is loading

### `ReadMoreLess`
- Expandable text widget with "Read more" / "Read less" toggle
- Used in Tafsir display and other long text sections

## Key Dependencies
- **Packages**: `flutter_svg`, `get`, `flex_color_picker`, `rate_my_app`
- **Used by**: All screen features

---

> **⚠️ EDIT LOG — If you edit this layer, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
