import 'package:event_map_flutter/core/components/themed_surface.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/map/components/add_event_panel.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';

const double _panelSizeLandscape = AppSizes.panelSizeLandscape;
const double _margin = AppSizes.generalPadding;

class PositionedAddEventPanel extends StatelessWidget {
  PositionedAddEventPanel({super.key, this.panelAnimationDuration});

  final Duration? panelAnimationDuration;
  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();

  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<MapCubit, MapState>(
      bloc: _mapCubit,
      builder: (context, state) {
        return AnimatedPositioned(
          duration: panelAnimationDuration ?? const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          left: null,
          top: _margin,
          right: state.isPanelOpen ? _margin : -(_panelSizeLandscape + _margin),
          bottom: _margin,
          width: _panelSizeLandscape,
          height: null,
          onEnd: _mapCubit.onPanelAnimationEnd,
          child: !state.isPanelOpen && !state.isPanelAnimating
              ? const SizedBox.shrink()
              : MouseRegion(
                  onEnter: (_) => _mapCubit.setMapScrollable(false),
                  onExit: (_) => _mapCubit.setMapScrollable(true),
                  child: ThemedSurface(
                    elevation: AppSizes.shadowElevation,
                    shadowColor: AppColors.shadow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.panelBorderRadius,
                      ),
                    ),
                    child: AddEventPanel(
                      onSuggestionSelected: (suggestion) =>
                          _mapCubit.panTo(suggestion.location),
                      onClose: _mapCubit.closePanel,
                      isFullScreen: true,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
