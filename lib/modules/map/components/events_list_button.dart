import 'package:event_map_flutter/core/components/web_icon_button.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/map/store/event_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Expands/collapses the events list panel.
class EventsListButton extends StatelessWidget {
  EventsListButton({super.key});

  final EventDetailsCubit _eventDetailsCubit = GetIt.I.get<EventDetailsCubit>();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
      child: WebIconButton(
        icon: Icons.list,
        onPressed: _eventDetailsCubit.toggleList,
      ),
    );
  }
}
