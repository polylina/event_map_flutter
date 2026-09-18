import 'package:event_map_flutter/core/components/themed_surface.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:event_map_flutter/core/utils/web_cursor.dart';
import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/map/components/event_details_panel.dart';
import 'package:event_map_flutter/modules/map/components/events_list_panel.dart';
import 'package:event_map_flutter/modules/map/components/positioned_bottom_bar.dart';
import 'package:event_map_flutter/modules/map/store/event_details_cubit.dart';
import 'package:event_map_flutter/modules/map/store/event_details_state.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

const double _panelWidth = AppSizes.panelSizeLandscape;
const double _panelMaxHeight = AppSizes.panelSizePortrait;
const double _margin = AppSizes.generalPadding;
const double _bottomBarHeight = AppSizes.bottomBarHeight;

class PositionedEventDetailsPanel extends StatefulWidget {
  final bool isPortrait;
  final Duration? panelAnimationDuration;

  const PositionedEventDetailsPanel({
    super.key,
    this.isPortrait = false,
    this.panelAnimationDuration,
  });

  @override
  State<PositionedEventDetailsPanel> createState() =>
      _PositionedEventDetailsPanelState();
}

class _PositionedEventDetailsPanelState
    extends State<PositionedEventDetailsPanel> {
  final EventDetailsCubit _eventDetailsCubit = GetIt.I.get<EventDetailsCubit>();
  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();

  @override
  void initState() {
    super.initState();
    // In landscape the list is expanded by default; in portrait it stays
    // collapsed until the user opens it from the bottom bar.
    if (!widget.isPortrait && !_eventDetailsCubit.state.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _eventDetailsCubit.showList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = widget.isPortrait;
    return BlocConsumer<EventDetailsCubit, EventDetailsState>(
      bloc: _eventDetailsCubit,
      listenWhen: (previous, current) =>
          current.event != null && previous.event != current.event,
      listener: (context, state) => _panToEvent(context, state.event!),
      builder: (context, state) {
        final panelHeight = _panelHeight(context);
        final portraitBottom = _portraitBottom(context);

        return AnimatedPositioned(
          duration:
              widget.panelAnimationDuration ??
              const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          left: isPortrait
              ? _margin
              : state.isOpen
              ? _margin
              : -(_panelWidth + _margin),
          top: isPortrait ? null : _margin,
          right: isPortrait ? _margin : null,
          bottom: isPortrait
              ? state.isOpen
                    ? portraitBottom
                    : -(panelHeight + _margin)
              : _margin + _bottomBarHeight,
          width: isPortrait ? null : _panelWidth,
          height: isPortrait ? panelHeight : null,
          onEnd: _eventDetailsCubit.onAnimationEnd,
          child: !state.isOpen && !state.isAnimating
              ? const SizedBox.shrink()
              : MouseRegion(
                  onEnter: (_) {
                    _mapCubit.setMapScrollable(false);
                    setWebCursor(CSSCursor.defaultCursor);
                  },
                  onExit: (_) {
                    _mapCubit.setMapScrollable(true);
                    setWebCursor(CSSCursor.grab);
                  },
                  child: ThemedSurface(
                    elevation: AppSizes.shadowElevation,
                    shadowColor: AppColors.shadow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.panelBorderRadius,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final isList =
                            child.key == const ValueKey('events-list');
                        final offsetAnimation = Tween<Offset>(
                          begin: isList
                              ? const Offset(-1, 0)
                              : const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      child: state.event == null
                          ? EventsListPanel(
                              key: const ValueKey('events-list'),
                              onEventSelected:
                                  _eventDetailsCubit.selectFromList,
                              onClose: _eventDetailsCubit.hide,
                            )
                          : EventDetailsPanel(
                              key: ValueKey(state.event!.id),
                              event: state.event!,
                              onClose: _eventDetailsCubit.hide,
                              onBack: state.isFromList
                                  ? _eventDetailsCubit.backToList
                                  : null,
                            ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  double _panelHeight(BuildContext context) =>
      (MediaQuery.sizeOf(context).height * 0.55)
          .clamp(280.0, _panelMaxHeight)
          .toDouble();

  // In portrait the panel is stacked above the bottom bar.
  double _portraitBottom(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom +
      PositionedBottomBar.portraitHeight +
      _margin;

  void _panToEvent(BuildContext context, CommonEventDto event) {
    // Center the event within the map area left uncovered by the panel.
    final offset = widget.isPortrait
        ? Offset(0, -(_portraitBottom(context) + _panelHeight(context)) / 2)
        : Offset((_panelWidth + _margin * 2) / 2, 0);
    _mapCubit.panTo(
      LatLng(event.location.latitude, event.location.longitude),
      offset: offset,
    );
  }
}
