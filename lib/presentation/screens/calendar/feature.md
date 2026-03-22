# Hijri Calendar Feature

## Overview
The **Hijri Calendar** feature provides a full Islamic (Hijri) calendar with religious event tracking, day countdown to upcoming events, and event reminders with Hadith display. Users can navigate months/years, view events for specific days, and adjust the Hijri date offset.

## Architecture
Uses `part` directive pattern — all files are parts of `events.dart`.

```
calendar/
├── events.dart                        # Library file (imports + parts)
├── controller/
│   └── event_controller.dart          # EventController (part of events.dart)
├── data/
│   └── model/
│       └── event_model.dart           # Event, Hadith, DataModel classes
├── screen/
│   └── hijri_calendar_screen.dart     # HijriCalendarScreen (part of events.dart)
└── widgets/
    ├── all_calculating_events_widget.dart    # Event countdown list
    ├── calculating_date_events_widget.dart   # Single event countdown card
    ├── calendar_build.dart                   # Calendar grid builder
    ├── calender_settings.dart               # Settings (adjust Hijri offset)
    ├── days_name.dart                        # Weekday name headers
    ├── hijri_widget_integration.dart         # Hijri widget integration
    ├── month_selection.dart                  # Month picker
    ├── reminder_event_bottom_sheet.dart      # Event detail bottom sheet
    └── year_selection.dart                   # Year picker
```

## Controller: `EventController`
- **Singleton** via `Get.isRegistered` / `Get.put`
- **State**: Uses GetX reactive values + `GetStorage` for persistence

### Key State
| Field | Type | Purpose |
|-------|------|---------|
| `hijriNow` | `HijriDate` | Current adjusted Hijri date |
| `selectedDate` | `HijriDate` | Currently viewed date |
| `events` | `RxList<Event>` | All religious events |
| `months` | `List<HijriDate>` | 12 months for the current year |
| `adjustHijriDays` | `RxInt` | User offset for Hijri date correction |
| `pageController` | `PageController` | Month page navigation |
| `boxController` | `BoxController` | SlidingBox controller for events panel |

### Key Methods
| Method | Purpose |
|--------|---------|
| `initializeMonths()` | Generates 12 Hijri months, calculates first day weekday for each |
| `calculateFirstDayOfMonth(month, year)` | Determines which weekday a Hijri month starts on |
| `loadJson()` | Loads events from `assets/json/religious_event.json` |
| `ramadhanOrEidGreeting()` | Shows greeting bottom sheet if today matches an event |
| `calculate(year, month, day)` | Calculates days remaining until an event |
| `showEvent(day, month)` | Displays event details in a bottom sheet with Hadith |
| `isEvent(months, days)` | Checks if a specific day has an event |
| `isCurrentDay(month, dayOffset)` | Checks if a day is the current day |
| `getDayColor(...)` | Returns appropriate color for calendar day cells |
| `increaseDay()` / `decreaseDay()` | Adjusts Hijri date offset (persisted) |
| `onMonthChanged(int)` / `onYearChanged(int)` | Handles navigation between months/years |
| `getEventYear(month, day)` | Returns current or next year depending on if event has passed |

## Data Model: `Event`
```
Event {
  id, title, day (List<int>), month, isReminder,
  hadith (List<Hadith>), isLottie, isSvg, isTitle,
  lottiePath, svgPath
}
```

## Data Source
- **JSON**: `assets/json/religious_event.json`
- **Persistence**: `GetStorage` for `adjustHijriDays`
- **Package**: `hijri_date` for Hijri calculations

## Main Screen: `HijriCalendarScreen`
- Uses `SlidingBox` widget with `Backdrop` pattern:
  - **Backdrop body**: Calendar grid with month/year selectors, weekday headers, and pageable month view
  - **Sliding body**: Event countdown list (`AllCalculatingEventsWidget`)
- Responsive: separate portrait/landscape layouts via `customOrientation()`
- Shows Hijri month name as SVG + year

## Key Dependencies
- **Package**: `hijri_date` for all Hijri date calculations
- **Package**: `sliding_box` for collapsible events panel
- **Widgets**: `TabBarWidget`, `CalendarBuild`, `ReminderEventBottomSheet`
- **Extensions**: `convert_number_extension` for Arabic numeral display
- **Localization**: GetX `.tr` for weekday names, event titles, etc.

## Navigation
- Home screen → `HijriCalendarScreen` (via `screensList`)
- Day tap → `showEvent()` bottom sheet
- Settings → Hijri offset adjustment

---

> **⚠️ EDIT LOG — If you edit this feature, you MUST add your changes below:**
>
> | Date | Description of Change |
> |------|-----------------------|
> | _(add your edit date)_ | _(describe what you changed)_ |
