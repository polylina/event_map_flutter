import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:event_map_flutter/modules/settings/dto/language_dto.dart';

class TranslationService {
  static const String _localesAsset = 'assets/i18n/locales.json';
  static const String _translationsAssetPrefix = 'assets/i18n/';

  Future<List<LanguageDto>> loadSupportedLanguages() async {
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
}
