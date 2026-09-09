import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/map/store/event_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  EventDetailsCubit() : super(const EventDetailsState());

  void showEvent(CommonEventDto event) {
    emit(
      state.copyWith(
        event: event,
        isOpen: true,
        isAnimating: true,
        isFromList: false,
      ),
    );
  }

  void showList() {
    emit(
      state.copyWith(
        clearEvent: true,
        isOpen: true,
        isAnimating: true,
        isFromList: false,
      ),
    );
  }

  void selectFromList(CommonEventDto event) {
    emit(state.copyWith(event: event, isFromList: true));
  }

  void backToList() {
    emit(state.copyWith(clearEvent: true, isFromList: false));
  }

  void toggleList() {
    if (state.isOpen) {
      hide();
    } else {
      showList();
    }
  }

  void hide() {
    emit(state.copyWith(isOpen: false, isAnimating: true));
  }

  void onAnimationEnd() {
    emit(state.copyWith(isAnimating: false));
  }
}
