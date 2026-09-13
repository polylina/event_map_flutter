import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/modules/common_events/services/common_events_service.dart';
import 'package:event_map_flutter/modules/common_events/store/common_events_state.dart';

class CommonEventsCubit extends Cubit<CommonEventsState> {
  final CommonEventsService _commonEventsService = GetIt.I
      .get<CommonEventsService>();

  CancelToken? _loadEventsCancelToken;

  CommonEventsCubit() : super(const CommonEventsState());

  Future<void> loadEvents({DateTime? startDate, LatLngBounds? bounds}) async {
    _loadEventsCancelToken?.cancel();
    final cancelToken = CancelToken();
    _loadEventsCancelToken = cancelToken;
    try {
      final events = await _commonEventsService.getEvents(
        startDate: startDate,
        bounds: bounds,
        cancelToken: cancelToken,
      );
      emit(state.copyWith(events: events));
    } finally {
      if (_loadEventsCancelToken == cancelToken) {
        _loadEventsCancelToken = null;
      }
    }
  }

  @override
  Future<void> close() {
    _loadEventsCancelToken?.cancel();
    return super.close();
  }
}
