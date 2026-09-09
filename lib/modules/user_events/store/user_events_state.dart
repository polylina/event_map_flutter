import 'package:event_map_flutter/modules/user_events/dto/user_event_dto.dart';

class UserEventsState {
  final List<UserEventDto> events;

  const UserEventsState({this.events = const []});

  UserEventsState copyWith({List<UserEventDto>? events}) {
    return UserEventsState(events: events ?? this.events);
  }
}
