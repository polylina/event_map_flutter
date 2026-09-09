import 'package:flutter/material.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';

// Letters (any language), digits, spaces and a limited set of common
// punctuation — no other special characters.
final RegExp _validNamePattern = RegExp(
  r'^[\p{L}\p{N} _+\-()!?"'
  "'"
  r'\[\]&.,:;/*%]+$',
  unicode: true,
);

// At least one letter or digit — the name can't be special characters only.
final RegExp _hasLetterOrDigitPattern = RegExp(r'[\p{L}\p{N}]', unicode: true);

class AddEventFormState {
  final String address;
  final List<AddressSuggestionDto> suggestions;
  final AddressSuggestionDto? selectedSuggestion;
  final String name;
  final String description;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final bool showValidationErrors;

  const AddEventFormState({
    this.address = '',
    this.suggestions = const [],
    this.selectedSuggestion,
    this.name = '',
    this.description = '',
    this.selectedDate,
    this.selectedTime,
    this.showValidationErrors = false,
  });

  bool get isNameValid {
    final trimmed = name.trim();
    return trimmed.isNotEmpty &&
        _validNamePattern.hasMatch(trimmed) &&
        _hasLetterOrDigitPattern.hasMatch(trimmed);
  }

  bool get isDateTimeValid => selectedDate != null;

  bool get isValid => isNameValid && isDateTimeValid;

  AddEventFormState copyWith({
    String? address,
    List<AddressSuggestionDto>? suggestions,
    ValueGetter<AddressSuggestionDto?>? selectedSuggestion,
    String? name,
    String? description,
    ValueGetter<DateTime?>? selectedDate,
    ValueGetter<TimeOfDay?>? selectedTime,
    bool? showValidationErrors,
  }) {
    return AddEventFormState(
      address: address ?? this.address,
      suggestions: suggestions ?? this.suggestions,
      selectedSuggestion: selectedSuggestion != null
          ? selectedSuggestion()
          : this.selectedSuggestion,
      name: name ?? this.name,
      description: description ?? this.description,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      selectedTime: selectedTime != null ? selectedTime() : this.selectedTime,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
    );
  }
}
