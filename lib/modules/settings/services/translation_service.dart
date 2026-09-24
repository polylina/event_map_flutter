import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:event_map_flutter/modules/settings/dto/language_dto.dart';
import 'package:event_map_flutter/modules/settings/models/world_region.dart';

class TranslationService {
  static const String _localesAsset = 'assets/i18n/locales.json';
  static const String _translationsAssetPrefix = 'assets/i18n/';

  /// Language code available in every world region.
  static const String _globalLanguageCode = 'en-US';

  /// Language codes offered per world region, excluding the global language.
  static const Map<WorldRegion, List<String>> _regionalLanguageCodes = {
    WorldRegion.america: ['fr-FR', 'es-ES', 'pt-BR'],
    WorldRegion.europe: [
      'en-GB',
      'fr-FR',
      'de',
      'es-ES',
      'it',
      'pl-PL',
      'ru-RU',
      'pt-PT',
    ],
    WorldRegion.asia: ['zh', 'ja-JP', 'ko'],
    WorldRegion.rest: [],
  };

  /// Language codes used to derive a default language from the world
  /// region (timezone), in priority order. Only used when the device
  /// language is not supported.
  static const Map<WorldRegion, List<String>> _regionalDefaultLanguageCodes = {
    WorldRegion.america: ['es-ES', 'pt-BR', 'fr-FR'],
    WorldRegion.europe: [
      'en-GB',
      'fr-FR',
      'de',
      'es-ES',
      'it',
      'pl-PL',
      'ru-RU',
      'pt-PT',
    ],
    WorldRegion.asia: ['zh', 'ja-JP', 'ko'],
    WorldRegion.rest: [],
  };

  Future<List<LanguageDto>> loadAllLanguages() async {
    final jsonString = await rootBundle.loadString(_localesAsset);
    final List<dynamic> data = jsonDecode(jsonString);
    return data
        .map((entry) => LanguageDto.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  /// Languages supported in [region]: the regional languages plus the
  /// global language (en-US), which is available everywhere.
  Future<List<LanguageDto>> loadSupportedLanguages(WorldRegion region) async {
    final allLanguages = await loadAllLanguages();
    final regionalCodes = _regionalLanguageCodes[region] ?? const [];
    final supportedCodes = [...regionalCodes, _globalLanguageCode];
    return allLanguages
        .where((language) => supportedCodes.contains(language.languageCode))
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

  /// Picks the default language for [region]. The device language wins
  /// when the app supports it in [region]; otherwise the timezone-derived
  /// regional default is used, falling back to the global language (en-US).
  LanguageDto getDefaultLanguage(
    WorldRegion region,
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
    // Timezone-derived regional default.
    final regionalDefaults =
        _regionalDefaultLanguageCodes[region] ?? const <String>[];
    for (final defaultCode in regionalDefaults) {
      for (final language in supportedLanguages) {
        if (language.languageCode == defaultCode) {
          return language;
        }
      }
    }
    return getCurrentLanguage(supportedLanguages, _globalLanguageCode);
  }
}
