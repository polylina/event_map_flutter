import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';

class EventDetailsState {
  final CommonEventDto? event;
  final bool isOpen;
  final bool isAnimating;

  /// The details view was opened from the events list, so it can go back to it.
  final bool isFromList;

  const EventDetailsState({
    this.event,
    this.isOpen = false,
    this.isAnimating = false,
    this.isFromList = false,
  });

  EventDetailsState copyWith({
    CommonEventDto? event,
    bool clearEvent = false,
    bool? isOpen,
    bool? isAnimating,
    bool? isFromList,
  }) {
    return EventDetailsState(
      event: clearEvent ? null : (event ?? this.event),
      isOpen: isOpen ?? this.isOpen,
      isAnimating: isAnimating ?? this.isAnimating,
      isFromList: isFromList ?? this.isFromList,
    );
  }
}
