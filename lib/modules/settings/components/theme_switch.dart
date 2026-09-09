import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:event_map_flutter/modules/settings/store/settings_state.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = GetIt.I.get<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: settingsCubit,
      builder: (context, state) {
        final isDark = state.themeBrightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: SizedBox(
            width: kMinInteractiveDimension,
            height: kMinInteractiveDimension,
            child: IconButton(
              icon: isDark
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode),
              onPressed: settingsCubit.toggleTheme,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: AppSizes.shadowElevation,
                shadowColor: AppColors.shadow,
              ),
            ),
          ),
        );
      },
    );
  }
}
