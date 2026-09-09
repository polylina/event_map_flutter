import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:event_map_flutter/modules/map/components/add_event_button.dart';
import 'package:event_map_flutter/modules/map/components/events_list_button.dart';
import 'package:event_map_flutter/modules/map/components/timeline.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';

const double _rowGap = 8;

/// Bottom bar with the timeline wheels, the events list toggle (portrait only)
/// and the Add event button — below the timeline in portrait, beside it in
/// landscape.
class PositionedBottomBar extends StatelessWidget {
  PositionedBottomBar({
    super.key,
    required this.onAddEventPressed,
    this.isPortrait = false,
    this.panelAnimationDuration,
  });

  /// Height of the bar in portrait, without the bottom safe area.
  static const double portraitHeight =
      Timeline.barHeight +
      _rowGap +
      kMinInteractiveDimension +
      AppSizes.generalPadding;

  final VoidCallback onAddEventPressed;
  final bool isPortrait;
  final Duration? panelAnimationDuration;
  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    return BlocBuilder<MapCubit, MapState>(
      bloc: _mapCubit,
      builder: (context, state) {
        final timeline = Timeline(
          direction: Directionality.of(context),
          initialDate: state.startDate,
          onDateSelected: _mapCubit.setStartDate,
          onEnter: () => _mapCubit.setMapScrollable(false),
          onExit: () => _mapCubit.setMapScrollable(true),
        );
        final addButton = AnimatedScale(
          duration: panelAnimationDuration ?? const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          scale: state.isPanelOpen ? 0.0 : 1.0,
          child: AddEventButton(onPressed: onAddEventPressed),
        );
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.generalPadding),
              child: isPortrait
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLtr) ...[
                              EventsListButton(),
                              const SizedBox(width: _rowGap),
                              timeline,
                            ] else ...[
                              timeline,
                              const SizedBox(width: _rowGap),
                              EventsListButton(),
                            ],
                          ],
                        ),
                        const SizedBox(height: _rowGap),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.generalPadding,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: addButton,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLtr) ...[
                          EventsListButton(),
                          const SizedBox(width: _rowGap),
                          timeline,
                          const SizedBox(width: _rowGap),
                          addButton,
                        ] else ...[
                          addButton,
                          const SizedBox(width: _rowGap),
                          timeline,
                          const SizedBox(width: _rowGap),
                          EventsListButton(),
                        ],
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
