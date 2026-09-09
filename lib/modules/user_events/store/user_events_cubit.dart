import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/user_events/dto/user_event_dto.dart';
import 'package:event_map_flutter/modules/user_events/services/user_events_service.dart';
import 'package:event_map_flutter/modules/user_events/store/user_events_state.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class UserEventsCubit extends Cubit<UserEventsState> {
  final UserEventsService _userEventsService = GetIt.I.get<UserEventsService>();

  UserEventsCubit() : super(const UserEventsState());

  Future<void> loadEvents({DateTime? startDate, LatLngBounds? bounds}) async {
    final events = await _userEventsService.getEvents(
      startDate: startDate,
      bounds: bounds,
    );
    emit(state.copyWith(events: events));
  }

  Future<void> addEvent(UserEventDto event) async {
    await _userEventsService.addEvent(event);
    emit(state.copyWith(events: [...state.events, event]));
  }
}
