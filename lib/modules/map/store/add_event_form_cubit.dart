import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/common_events/dto/location_dto.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/geocoding_service.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_state.dart';
import 'package:event_map_flutter/modules/user_events/dto/user_event_dto.dart';

class AddEventFormCubit extends Cubit<AddEventFormState> {
  static const Duration _debounceDuration = Duration(milliseconds: 400);

  final GeocodingService _geocodingService = GetIt.I.get<GeocodingService>();
  Timer? _debounce;

  AddEventFormCubit() : super(const AddEventFormState());

  /// Clears all form fields — called each time the panel is (re)opened,
  /// since the cubit is a long-lived singleton shared across opens.
  void reset() {
    _debounce?.cancel();
    emit(const AddEventFormState());
  }

  void onAddressChanged(String query) {
    _debounce?.cancel();
    // Editing the address again after a selection re-opens the search flow.
    final clearsSelection = state.selectedSuggestion != null;
    emit(
      state.copyWith(
        address: query,
        selectedSuggestion: clearsSelection ? () => null : null,
      ),
    );
    if (query.trim().isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }
    _debounce = Timer(_debounceDuration, () => _search(query));
  }

  Future<void> _search(String query) async {
    final suggestions = await _geocodingService.search(query);
    emit(state.copyWith(suggestions: suggestions));
  }

  void selectSuggestion(AddressSuggestionDto suggestion) {
    emit(
      state.copyWith(
        address: suggestion.address,
        selectedSuggestion: () => suggestion,
        suggestions: [],
      ),
    );
  }

  void onNameChanged(String value) {
    emit(state.copyWith(name: value));
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void setDateTime(DateTime dateTime) {
    emit(
      state.copyWith(
        selectedDate: () =>
            DateTime(dateTime.year, dateTime.month, dateTime.day),
        selectedTime: () => TimeOfDay.fromDateTime(dateTime),
      ),
    );
  }

  /// Marks the form as validated so field-level error messages are shown.
  void markValidationAttempted() {
    emit(state.copyWith(showValidationErrors: true));
  }

  /// Builds a [UserEventDto] from the current form state, or null if
  /// required fields (address, name, date) are missing/invalid.
  UserEventDto? buildEvent() {
    final suggestion = state.selectedSuggestion;
    final date = state.selectedDate;
    if (suggestion == null || date == null || !state.isValid) {
      return null;
    }
    final time = state.selectedTime ?? const TimeOfDay(hour: 0, minute: 0);
    final start = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return UserEventDto(
      id: DateTime.now().microsecondsSinceEpoch,
      name: state.name,
      description: state.description,
      startDate: start,
      location: LocationDto(
        name: suggestion.title,
        address: suggestion.address,
        latitude: suggestion.location.latitude,
        longitude: suggestion.location.longitude,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
