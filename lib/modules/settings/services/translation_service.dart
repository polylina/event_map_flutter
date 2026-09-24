import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:event_map_flutter/modules/settings/dto/language_dto.dart';

class TranslationService {
  static const String _localesAsset = 'assets/i18n/locales.json';
  static const String _translationsAssetPrefix = 'assets/i18n/';

  /// Language code used as the fallback default language.
  static const String _globalLanguageCode = 'en-US';

  Future<List<LanguageDto>> loadAllLanguages() async {
    final jsonString = await rootBundle.loadString(_localesAsset);
    final List<dynamic> data = jsonDecode(jsonString);
    return data
        .map((entry) => LanguageDto.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, String>> loadTranslations(String languageCode) async {
    final jsonString = await rootBundle.loadString(
      '$_translationsAssetPrefix$languageCode.json',
    );
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return data.map((key, value) => MapEntry(key, value as String));
  }

  LanguageDto getCurrentLanguage(
    List<LanguageDto> supportedLanguages,
    String languageCode,
  ) {
    return supportedLanguages.firstWhere(
      (language) => language.languageCode == languageCode,
      orElse: () => supportedLanguages.first,
    );
  }

  /// Picks the default language. The device language wins when the app
  /// supports it; otherwise the global language (en-US) is used.
  LanguageDto getDefaultLanguage(
    List<LanguageDto> supportedLanguages,
    String platformLanguageCode,
  ) {
    final platformBase = platformLanguageCode.split('-').first;
    // Device language wins when supported (exact match first).
    for (final language in supportedLanguages) {
      if (language.languageCode == platformLanguageCode) {
        return language;
      }
    }
    // Then a base-language match (e.g. device 'pt-PT' -> supported 'pt-BR').
    for (final language in supportedLanguages) {
      if (language.languageCode.split('-').first == platformBase) {
        return language;
      }
    }
    return getCurrentLanguage(supportedLanguages, _globalLanguageCode);
  }
}
