import 'dart:ui';

import 'package:event_map_flutter/modules/settings/dto/language_dto.dart';

class SettingsState {
  final Brightness themeBrightness;
  final LanguageDto? language;
  final List<LanguageDto> supportedLanguages;
  final Map<String, String> translations;

  const SettingsState({
    this.themeBrightness = Brightness.light,
    this.language,
    this.supportedLanguages = const [],
    this.translations = const {},
  });

  SettingsState copyWith({
    Brightness? themeBrightness,
    LanguageDto? language,
    List<LanguageDto>? supportedLanguages,
    Map<String, String>? translations,
  }) {
    return SettingsState(
      themeBrightness: themeBrightness ?? this.themeBrightness,
      language: language ?? this.language,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      translations: translations ?? this.translations,
    );
  }
}
