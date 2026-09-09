---
applyTo: "**"
---

# event_map_flutter — architecture conventions

Package name: `event_map_flutter`. Flutter SDK at `/Users/polina/flutter/bin/flutter`
(not on PATH by default — export `PATH="/Users/polina/flutter/bin:$PATH"` before
any flutter/dart command).

Architecture modeled after reference repo
`/Users/polina/dev/Specure/specure-nettest/flutter-standalone` (simplified for a
fresh project — don't copy its full complexity, just the pattern/naming).

## Folder structure

- `lib/core/di/service-locator.dart` — `ServiceLocator` static class wrapping `get_it`.
  Has `registerInstances()` with sections (Plugins and wrappers / Components / Services /
  Blocs and Cubits), each with `// End ...` marker comment. Private static helpers
  `_registerSingleton`, `_registerLazySingleton`, `_registerFactory` guard against
  double registration via `GetIt.I.isRegistered<T>()`. Private constructor `ServiceLocator._()`.
  Call `ServiceLocator.registerInstances()` in `main()` before `runApp`.
- `lib/modules/<feature>/screens/` — UI widgets, e.g. `map_screen.dart` → `MapScreen`.
- `lib/modules/<feature>/store/` — state management: `<feature>_cubit.dart` (flutter_bloc
  `Cubit<State>`, pulls deps via `GetIt.I.get<...>()`) + `<feature>_state.dart` (plain class
  with `copyWith`).
- `lib/modules/<feature>/services/` — feature-scoped services (plain classes registered in
  ServiceLocator), e.g. `geolocation_service.dart` → `GeolocationService`.
- `lib/modules/<feature>/dto/` — data classes shared between store and screens. **All DTOs
  must extend `Equatable`** (package `equatable`) with `props` overridden.

## Event handler placement rule

Prefer a Cubit method over a local `setState`/private handler method in a
widget for anything beyond pure UI/`BuildContext` concerns (debounce timers,
service calls, derived state). Widgets should only keep `TextEditingController`s
and platform dialogs (`showDatePicker`/`showTimePicker`/etc.) that need
`BuildContext`, forwarding the result straight into the cubit. See
`AddEventFormCubit` (map module) as the reference example.

## Translated strings

`lib/modules/settings/extensions/translated_string.dart` → `TranslatedString` extension
on `String`, `'key'.translated` getter (reads `GetIt.I.get<SettingsCubit>().state
.translations[this] ?? this`). Use this
instead of direct `state.translations['key']` access in widgets.

## Widgets that aren't full screens

Feature-specific widgets go in `lib/modules/<feature>/components/`. Reusable
cross-feature widgets go in `lib/core/components/`, e.g. `button_primary_dark.dart`
→ `ButtonPrimaryDark` (label/onPressed args); `button_primary_light.dart` →
`ButtonPrimaryLight` (label/trailing/onPressed args). One file per widget, e.g.
`components/add_event_button.dart` → `AddEventButton`. Not under `screens/`.

## Naming convention

File names are `lower_case_with_underscores.dart` (standard Dart `file_names` lint),
with a role suffix: `*_screen.dart`, `*_cubit.dart`, `*_state.dart`, `*_service.dart`,
`*_dto.dart`. (Earlier kebab-case style like `map-screen.dart`/`user-position.dto.dart`
was renamed away from — don't reintroduce hyphens/dots in filenames.)

## Routing

`MaterialApp` uses `routes` map + `initialRoute`, not `home`. Add new screens as route
entries in `lib/main.dart`.

## Global input styling

`MaterialApp`'s `theme.inputDecorationTheme` in `lib/main.dart` sets defaults for
all `TextField`/`TextFormField`: `borderRadius: 10` (via `border`/`enabledBorder`/
`focusedBorder`, all `OutlineInputBorder` with `borderSide: BorderSide.none`),
`filled: true`, `fillColor` via `WidgetStateColor.resolveWith` — `#F6F6F6` when
focused, `#E0E0E0` (darker) otherwise. Don't set per-widget `border`/`fillColor`
on individual `InputDecoration`s — rely on the theme so all inputs stay consistent.

## Theme-aware components (dark/light branching)

Don't write `BlocBuilder<SettingsCubit, SettingsState>` + manual
`state.themeBrightness == Brightness.dark` checks in each new panel/screen —
use the generalized wrappers in `lib/core/components/`:

- `theme_builder.dart` → `ThemeBuilder({builder: (context, isDark) => ...})`,
  the base primitive (wraps `SettingsCubit`'s `BlocBuilder` once). Other themed
  components build on this.
- `themed_surface.dart` → `ThemedSurface({child, lightColor, darkColor})` —
  `Material` background that auto-switches (white / `#424242` by default).
  Used as the panel-level wrapper.
- `themed_text_field.dart` → `ThemedTextField({controller, focusNode,
autofocus, labelText, onChanged, darkFillColor})` — `TextField` with white
  text/label and a darker fill (`#303030` by default) in dark mode.
- `themed_icon_button.dart` → `ThemedIconButton({icon, onPressed})` — white
  icon in dark mode.
- `section_title.dart` → `SectionTitle`'s `color` param is optional
  (nullable); when omitted it resolves via `ThemeBuilder` to white/black
  automatically instead of hardcoding `Colors.black`.
  Add new themed primitives here (not ad-hoc `isDark` checks) as more
  theme-dependent styling needs arise.

## Known/expected lint noise (do not "fix" unless asked)

- Unused-element warnings on ServiceLocator's `_registerSingleton`/`_registerFactory`
  helpers while no service uses that registration style yet — stubs by design.

## Assets

Map style JSONs live in `assets/styles/<style-name>/style.json`. Declared as
folder-globs in `pubspec.yaml` `flutter: assets:`. Loaded at runtime via
`rootBundle.loadString(...)` (styles reference only remote tile/sprite/glyph
URLs, so no other files from the folder need bundling/loading).

## Settings module

`lib/modules/settings/services/theme_detection_service.dart` → `ThemeDetectionService`
reads `PlatformDispatcher.instance.platformBrightness`. `lib/modules/settings/store/`
has `settings_cubit.dart`/`settings_state.dart` (`SettingsCubit.init()` stores detected
`Brightness`). `SettingsCubit.init()` is called once in `main()` right after
`ServiceLocator.registerInstances()`, before `runApp`, so it's ready before any other
cubit's `init()` reads it (e.g. `MapCubit.init()` reads `SettingsCubit.state.themeBrightness`
to pick `colorful` vs `shadow` map style).

## Deps installed so far

flutter_bloc, get_it, maplibre_gl (class names are `MapLibreMap`/`MapLibreMapController`,
NOT `Maplibre*`), geolocator, equatable.

## i18n

Local-JSON based (no CMS). Assets all live in single folder
`assets/i18n/`: `locales.json` (list of `{languageCode, name, nativeName}`) +
`<code>.json` per language (flat key→string map), declared as one
folder-glob in `pubspec.yaml`.
`lib/modules/settings/dto/language_dto.dart` → `LanguageDto` (Equatable).
`lib/modules/settings/services/locale_detection_service.dart` →
`LocaleDetectionService.getPlatformLocale()` (`PlatformDispatcher.instance.locale`).
`lib/modules/settings/services/translation_service.dart` → `TranslationService`
loads both asset types via `rootBundle.loadString` + `jsonDecode`.
`SettingsState` has `language`/`supportedLanguages`/`translations` fields;
`SettingsCubit.init()` is `Future<void>` — detects system locale, matches
against supported languages (falls back to first supported), loads its
translations, emits all at once.
`SettingsCubit.changeLanguage(LanguageDto)` reloads translations and emits.
`main()` is `async` with `WidgetsFlutterBinding.ensureInitialized()` and
`await`s `SettingsCubit.init()` before `runApp`.
`lib/modules/settings/components/language_switch.dart` → `LanguageSwitch`
widget (DropdownButton bound to `SettingsCubit` state/`changeLanguage`),
placed top-right of `MapScreen` via `Stack`/`Positioned`/`SafeArea`.

## Add-event address search panel

`AddEventPanel` opens as an overlay in `map_screen.dart` (`isPanelOpen` state),
inside the same `Stack` as the map via `LayoutAwareBuilder` + `AnimatedPositioned`.
The `MapLibreMap` is wrapped in a plain (non-animated) `Positioned` that shrinks
by the panel size on `bottom` (portrait) or `right` (landscape) only once
`isPanelOpen && !isPanelAnimating` — map resize snaps instantly after the panel's
slide-in animation finishes, it does not animate together with the panel:
portrait → full width, fixed height, slides up from the bottom;
landscape → full height, fixed width, slides in from the right.
`AddEventButton` is hidden while the panel is open.
Form/search logic lives in `AddEventFormCubit` (registered in `ServiceLocator`
as a lazy singleton) — holds `suggestions`/`selectedSuggestion`/`name`/`description`/
`selectedDate`/`selectedTime`, owns the 400ms debounce `Timer` and
`GeocodingService` calls. The cubit is a long-lived singleton shared across
panel opens — call `reset()` each time the panel (re)opens.
`AddEventPanel` uses a `BlocConsumer` to switch its body between
`components/address_suggestions_list.dart` → `AddressSuggestionsList`
(search-results section + `ListView.separated`, taps call
`selectSuggestion`) and `components/add_event_form.dart` → `AddEventForm`
(name/description fields + date/time `ListTile`s opening
`showDatePicker`/`showTimePicker`; pickers stay in the widget since they need
`BuildContext`, but the picked value is written back via the cubit).
RULE: prefer putting `onChanged`/business-logic handlers in a Cubit
method rather than local `setState`/private methods in the widget — widgets
keep only `TextEditingController`s and picker calls that require `BuildContext`.
The selected-location marker uses two `maplibre_gl` `Circle`s (translucent halo
`#E53935` r16 + solid dot r7 with white stroke) via `controller.addCircle` — no
custom icon asset. Removed via `controller.removeCircles` before adding a new
pair on re-selection.
`MapLibreMap`'s `scrollGesturesEnabled`/`zoomGesturesEnabled`/
`rotateGesturesEnabled`/`tiltGesturesEnabled` are all wired to `!isPanelOpen`
— without this, scrolling the panel's suggestion `ListView` also pans/zooms
the map underneath (platform view gesture bleed-through), since it's all one
`Stack`.

Geocoding: `modules/map/dto/address_suggestion_dto.dart` → `AddressSuggestionDto`
(Equatable: title/address/latitude/longitude). `modules/map/services/`
`abstract_geocoding_service.dart` → `AbstractGeocodingService` (`search(String)`),
implemented by Google/Here/LocationIQ/Nominatim services — all use
`package:http` directly (no `dio`). All `search()` impls THROW on non-200/parse
failure (no swallowing to `[]`) so the facade can detect provider failure.
LocationIQ and Nominatim both return OSM-style `display_name`/`address`/`lat`/`lon`
results, so they share `AddressSuggestionDto.fromOsmResult(Map result)` factory
constructor (in `address_suggestion_dto.dart` itself) — parses
title/address/latitude/longitude at once, stripping location-level components
(city/district/state/region/postcode/country/etc.) out of `title`, leaving the
full breakdown only in `address` (`display_name`). Don't duplicate this parsing
logic per-service again.
`GeocodingService` facade picks primary provider via a `switch` on
`GeocodingConfig.provider` (`'google'`/`'locationiq'`/default `here`),
wraps `search()` in try/catch and falls back to `NominatimGeocodingService`
on any exception; returns `[]` only if the fallback also throws.
Uses `flutter_dotenv` package: `.env` (gitignored, real local keys) +
`.env.example` (committed template) at repo root, declared as an asset in
`pubspec.yaml`. `main()` calls `await dotenv.load()` right after
`WidgetsFlutterBinding.ensureInitialized()`, before
`ServiceLocator.registerInstances()`.

## Web platform gotcha

`maplibre_gl` on web needs the MapLibre GL JS lib loaded manually — it's not bundled.
Files are vendored locally (not via unpkg CDN) at `web/vendor/maplibre-gl/maplibre-gl.js`
and `.css` (version must match what `maplibre_gl`'s own README pins — check
`~/.pub-cache/hosted/pub.dev/maplibre_gl-<version>/README.md`). Referenced in
`web/index.html` `<head>` via local relative paths:

```html
<script src="vendor/maplibre-gl/maplibre-gl.js"></script>
<link href="vendor/maplibre-gl/maplibre-gl.css" rel="stylesheet" />
```

Missing this causes `TypeError: Cannot read properties of undefined (reading 'LngLat')`
in `maplibre_gl_web/src/geo/lng_lat.dart` at runtime in Chrome.
