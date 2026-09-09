import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';

class CommonEventsState {
  final List<CommonEventDto> events;

  const CommonEventsState({this.events = const []});

  CommonEventsState copyWith({List<CommonEventDto>? events}) {
    return CommonEventsState(events: events ?? this.events);
  }
}
