import 'package:equatable/equatable.dart';

class LanguageDto extends Equatable {
  final String languageCode;
  final String countryCode;
  final String name;
  final String nativeName;

  const LanguageDto({
    required this.languageCode,
    required this.countryCode,
    required this.name,
    required this.nativeName,
  });

  factory LanguageDto.fromJson(Map<String, dynamic> json) {
    return LanguageDto(
      languageCode: json['languageCode'] as String,
      countryCode: json['countryCode'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
    );
  }

  @override
  List<Object?> get props => [languageCode, countryCode, name, nativeName];
}
