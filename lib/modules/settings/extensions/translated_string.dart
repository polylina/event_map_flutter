import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';

extension TranslatedString on String {
  String get translated =>
      GetIt.I.get<SettingsCubit>().state.translations[this] ?? this;

  String translatedWithArgs(Map<String, dynamic> args) {
    var result = translated;
    for (final entry in args.entries) {
      result = result.replaceAll('\${${entry.key}}', entry.value.toString());
    }
    return result;
  }
}
