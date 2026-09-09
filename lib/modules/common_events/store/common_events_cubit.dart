import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/modules/common_events/services/common_events_service.dart';
import 'package:event_map_flutter/modules/common_events/store/common_events_state.dart';

class CommonEventsCubit extends Cubit<CommonEventsState> {
  final CommonEventsService _commonEventsService = GetIt.I
      .get<CommonEventsService>();

  CommonEventsCubit() : super(const CommonEventsState());

  Future<void> loadEvents({DateTime? startDate, LatLngBounds? bounds}) async {
    final events = await _commonEventsService.getEvents(
      startDate: startDate,
      bounds: bounds,
    );
    emit(state.copyWith(events: events));
  }
}
