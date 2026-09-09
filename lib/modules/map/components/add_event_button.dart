import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/components/button_primary_dark.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:event_map_flutter/modules/settings/store/settings_state.dart';

class AddEventButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final SettingsCubit _settingsCubit = GetIt.I.get<SettingsCubit>();

  AddEventButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: _settingsCubit,
      builder: (context, state) => ButtonPrimaryDark(
        label: 'map.addEvent'.translated,
        icon: Icons.add_location_alt_outlined,
        onPressed: onPressed,
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
      ),
    );
  }
}
