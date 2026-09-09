import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/di/service_locator.dart';
import 'package:event_map_flutter/modules/map/screens/add_event_screen.dart';
import 'package:event_map_flutter/modules/map/screens/map_screen.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:event_map_flutter/modules/settings/store/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  ServiceLocator.registerInstances();
  await GetIt.I.get<SettingsCubit>().init();
  unawaited(GetIt.I.get<MapCubit>().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.defaultAccent,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      shadowColor: AppColors.shadow,
      dividerTheme: DividerThemeData(
        color: isDark ? colorScheme.outlineVariant : AppColors.divider,
      ),
      scaffoldBackgroundColor: isDark ? AppColors.darkSurface : null,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? (isDark ? AppColors.darkFill : AppColors.inputFillFocused)
              : (isDark ? AppColors.darkFill : AppColors.inputFillEnabled),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.inputBorderFocused, width: 1),
        ),
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: GetIt.I.get<SettingsCubit>(),
      builder: (context, state) {
        final isDark = state.themeBrightness == Brightness.dark;
        return MaterialApp(
          title: 'Event Map',
          locale: state.language == null
              ? null
              : Locale(
                  state.language!.languageCode.split('-').first,
                  state.language!.countryCode,
                ),
          supportedLocales: state.supportedLanguages
              .map(
                (language) => Locale(
                  language.languageCode.split('-').first,
                  language.countryCode,
                ),
              )
              .toList(),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: MapScreen.routeName,
          routes: {
            MapScreen.routeName: (context) => MapScreen(),
            AddEventScreen.routeName: (context) => const AddEventScreen(),
          },
        );
      },
    );
  }
}
