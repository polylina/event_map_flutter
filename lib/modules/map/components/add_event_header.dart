import 'package:event_map_flutter/core/components/panel_title.dart';
import 'package:event_map_flutter/core/components/themed_divider.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/core/components/web_icon_button.dart';

class AddEventHeader extends StatelessWidget {
  AddEventHeader({super.key, required this.onClose});

  final VoidCallback onClose;
  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      bloc: _mapCubit,
      builder: (context, state) {
        final startDate = state.startDate ?? DateTime.now();
        return Padding(
          padding: const EdgeInsets.all(AppSizes.generalPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: PanelTitle(
                      'map.eventOn'.translatedWithArgs({
                        'startDate': MaterialLocalizations.of(
                          context,
                        ).formatCompactDate(startDate),
                      }),
                    ),
                  ),
                  WebIconButton(icon: Icons.close, onPressed: onClose),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ThemedDivider(),
              ),
            ],
          ),
        );
      },
    );
  }
}
