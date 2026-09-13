import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:event_map_flutter/modules/common_events/dto/location_dto.dart';
import 'package:event_map_flutter/modules/common_events/dto/user_dto.dart';

part 'common_event_dto.g.dart';

@JsonSerializable()
class CommonEventDto extends Equatable {
  final int id;
  final String name;
  final DateTime startDate;
  final LocationDto location;
  final String? description;
  final String? flyerUrl;
  final UserDto? user;

  const CommonEventDto({
    required this.id,
    required this.name,
    required this.startDate,
    required this.location,
    this.description,
    this.flyerUrl,
    this.user,
  });

  factory CommonEventDto.fromJson(Map<String, dynamic> json) =>
      _$CommonEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommonEventDtoToJson(this);

  String longLabel(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final dateLabel =
        '${localizations.formatCompactDate(startDate)} · '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(startDate))}';

    return '${location.address}\n$dateLabel';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    startDate,
    location,
    flyerUrl,
    user,
  ];
}
