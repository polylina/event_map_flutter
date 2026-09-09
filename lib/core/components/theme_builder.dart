import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:event_map_flutter/modules/settings/store/settings_state.dart';

/// Wraps `SettingsCubit`'s theme brightness so widgets don't each need their
/// own `BlocBuilder<SettingsCubit, SettingsState>` + `Brightness` check.
class ThemeBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isDark) builder;

  const ThemeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: GetIt.I.get<SettingsCubit>(),
      builder: (context, state) =>
          builder(context, state.themeBrightness == Brightness.dark),
    );
  }
}
