import 'package:event_map_flutter/core/components/themed_divider.dart';
import 'package:event_map_flutter/core/components/themed_text.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/common_events/store/common_events_cubit.dart';
import 'package:event_map_flutter/modules/common_events/store/common_events_state.dart';
import 'package:event_map_flutter/modules/map/components/event_list_item.dart';
import 'package:event_map_flutter/modules/map/components/panel_controls_row.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Scrollable list of the events currently loaded for the visible map area.
class EventsListPanel extends StatelessWidget {
  EventsListPanel({
    super.key,
    required this.onEventSelected,
    required this.onClose,
  });

  final ValueChanged<CommonEventDto> onEventSelected;
  final VoidCallback onClose;

  final CommonEventsCubit _commonEventsCubit = GetIt.I.get<CommonEventsCubit>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.generalPadding,
              AppSizes.generalPadding,
              AppSizes.generalPadding,
              0,
            ),
            child: BlocBuilder<CommonEventsCubit, CommonEventsState>(
              bloc: _commonEventsCubit,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ThemedText(
                      'map.events'.translated,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: ThemedDivider(),
                    ),
                    Expanded(
                      child: state.events.isEmpty
                          ? Center(
                              child: ThemedText(
                                'map.noEvents'.translated,
                                fontSize: 14,
                                isSecondary: true,
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: state.events.length,
                              separatorBuilder: (context, index) =>
                                  const ThemedDivider(),
                              itemBuilder: (context, index) {
                                final event = state.events[index];
                                return EventListItem(
                                  event: event,
                                  onTap: () => onEventSelected(event),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        PanelControlsRow(onClose: onClose),
      ],
    );
  }
}
