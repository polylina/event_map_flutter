import 'package:event_map_flutter/core/components/layout_aware_builder.dart';
import 'package:event_map_flutter/modules/map/components/positioned_bottom_bar.dart';
import 'package:event_map_flutter/modules/map/components/positioned_add_event_panel.dart';
import 'package:event_map_flutter/modules/map/components/positioned_controls.dart';
import 'package:event_map_flutter/modules/map/components/positioned_crosshair.dart';
import 'package:event_map_flutter/modules/map/components/positioned_event_details_panel.dart';
import 'package:event_map_flutter/modules/map/components/positioned_map.dart';
import 'package:event_map_flutter/modules/map/screens/add_event_screen.dart';
import 'package:event_map_flutter/modules/auth/utils/auth_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';

class MapScreen extends StatelessWidget {
  static const String routeName = '/map';
  static const Duration _panelAnimationDuration = Duration(milliseconds: 250);

  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();

  MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapCubit, MapState>(
        bloc: _mapCubit,
        builder: (context, state) {
          if (state.styleJson == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return LayoutAwareBuilder<bool>(
            portraitLayout: true,
            landscapeLayout: false,
            builder: (context, isPortrait) {
              return isPortrait
                  ? Stack(
                      children: [
                        const PositionedMap(),
                        PositionedBottomBar(
                          isPortrait: true,
                          onAddEventPressed: () => callIfAuthenticated(
                            context,
                            callable: () => Navigator.of(
                              context,
                            ).pushNamed(AddEventScreen.routeName),
                          ),
                        ),
                        const PositionedControls(),
                        PositionedEventDetailsPanel(
                          isPortrait: true,
                          panelAnimationDuration: _panelAnimationDuration,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        const PositionedMap(),
                        PositionedBottomBar(
                          onAddEventPressed: () => callIfAuthenticated(
                            context,
                            callable: _mapCubit.openPanel,
                          ),
                          panelAnimationDuration: _panelAnimationDuration,
                        ),
                        const PositionedControls(),
                        PositionedAddEventPanel(
                          panelAnimationDuration: _panelAnimationDuration,
                        ),
                        PositionedEventDetailsPanel(
                          panelAnimationDuration: _panelAnimationDuration,
                        ),
                        if (state.isPanelOpen) PositionedCrosshair(),
                      ],
                    );
            },
          );
        },
      ),
    );
  }
}
