# About App Feature

## Overview
The **About App** screen provides information about the application and offers user interaction options (share, email, Facebook). It is accessible from the home screen's settings/navigation.

## Architecture
Simple flat structure with 3 files — no separate controller or state management needed.

### Files

| File | Purpose |
|------|---------|
| `about_app.dart` | Main screen `AboutApp` (StatelessWidget). Builds the Scaffold with AppBar displaying the app icon, and a body containing `AboutAppText` + `UserOptions`. Uses `customOrientation()` for responsive portrait/landscape layouts. |
| `about_app_text.dart` | `AboutAppText` widget using `ExpansionTileCard` — displays expandable "About App" section with localized text (`'aboutApp'.tr`, `'about_app'.tr`, `'about_app3'.tr`). Uses `naskh` and `kufi` font families. |
| `user_options.dart` | `UserOptions` widget showing 3 action rows inside a `ContainerWithBorder`: **Share** (calls `shareApp()`), **Email** (calls `contactUs()`), **Facebook** (calls `launchAlheekmahUrl()`). Each row has an icon + divider + label. |

## Key Dependencies
- **Extensions**: `alignment_rotated_extension`, `svg_extensions`, `extensions` (from `core/utils/constants/extensions/`)
- **Extensions for actions**: `contact_us_extension`, `launch_alheekmah_url_extension`, `share_app_extension`
- **Widgets**: `ContainerWithBorder` (from `core/widgets/`)
- **Localization**: GetX `.tr` for all strings
- **SVG**: `SvgPath.svgSplashIcon`, `SvgPath.svgSplashIconS`

## Data Flow
No data fetching — purely UI. All text comes from localization keys.

## Navigation
- Navigated **to** via `Get.to()` from the home screen or settings
- Back via `Get.back()` (back arrow in AppBar)

## Responsive Design
Uses `context.customOrientation()` to switch between:
- **Portrait**: Vertical `ListView` (icon → about text → user options)
- **Landscape**: Horizontal `Row` (icon left, content right)

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
