import 'package:event_map_flutter/core/di/service_locator.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsCubit theme toggle', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      GetIt.I.reset();
      ServiceLocator.registerInstances();
    });

    test('toggles between light and dark themes', () {
      final cubit = SettingsCubit();

      expect(cubit.state.themeBrightness, Brightness.light);

      cubit.toggleTheme();
      expect(cubit.state.themeBrightness, Brightness.dark);

      cubit.toggleTheme();
      expect(cubit.state.themeBrightness, Brightness.light);
    });
  });
}
