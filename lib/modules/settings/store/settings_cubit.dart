import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/settings/dto/language_dto.dart';
import 'package:event_map_flutter/modules/settings/services/locale_detection_service.dart';
import 'package:event_map_flutter/modules/settings/services/settings_storage_service.dart';
import 'package:event_map_flutter/modules/settings/services/theme_detection_service.dart';
import 'package:event_map_flutter/modules/settings/services/translation_service.dart';
import 'package:event_map_flutter/modules/settings/store/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final ThemeDetectionService _themeDetectionService = GetIt.I
      .get<ThemeDetectionService>();
  final LocaleDetectionService _localeDetectionService = GetIt.I
      .get<LocaleDetectionService>();
  final TranslationService _translationService = GetIt.I
      .get<TranslationService>();
  final SettingsStorageService _settingsStorageService = GetIt.I
      .get<SettingsStorageService>();

  SettingsCubit() : super(const SettingsState());

  Future<void> init() async {
    final supportedLanguages = await _translationService.loadAllLanguages();
    final platformLocale = _localeDetectionService.getPlatformLocale();
    final platformLanguageCode = platformLocale.countryCode == null
        ? platformLocale.languageCode
        : '${platformLocale.languageCode}-${platformLocale.countryCode}';
    // A stored choice wins over the detected default.
    final storedLanguageCode = await _settingsStorageService.getLanguageCode();
    final language = storedLanguageCode == null
        ? _translationService.getDefaultLanguage(
            supportedLanguages,
            platformLanguageCode,
          )
        : _translationService.getCurrentLanguage(
            supportedLanguages,
            storedLanguageCode,
          );
    final translations = await _translationService.loadTranslations(
      language.languageCode,
    );
    final storedBrightness = await _settingsStorageService.getThemeBrightness();
    emit(
      state.copyWith(
        themeBrightness:
            storedBrightness ?? _themeDetectionService.getPlatformBrightness(),
        supportedLanguages: supportedLanguages,
        language: language,
        translations: translations,
      ),
    );
  }

  Future<void> changeLanguage(LanguageDto language) async {
    final translations = await _translationService.loadTranslations(
      language.languageCode,
    );
    emit(state.copyWith(language: language, translations: translations));
    await _settingsStorageService.setLanguageCode(language.languageCode);
  }

  void toggleTheme() {
    final nextBrightness = state.themeBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    emit(state.copyWith(themeBrightness: nextBrightness));
    _settingsStorageService.setThemeBrightness(nextBrightness);
  }
}
