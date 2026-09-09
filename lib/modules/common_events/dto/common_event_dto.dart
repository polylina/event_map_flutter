import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/core/json/lat_lng_converter.dart';
import 'package:event_map_flutter/modules/common_events/dto/user_dto.dart';

part 'common_event_dto.g.dart';

@JsonSerializable()
class CommonEventDto extends Equatable {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  @LatLngConverter()
  final LatLng location;
  final String address;
  final String? description;
  final String? flyer;
  final UserDto? user;

  const CommonEventDto({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.address,
    this.description,
    this.flyer,
    this.user,
  });

  factory CommonEventDto.fromJson(Map<String, dynamic> json) =>
      _$CommonEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommonEventDtoToJson(this);

  String longLabel(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final dateLabel =
        '${localizations.formatCompactDate(startTime)} · '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(startTime))}'
        '–'
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(endTime))}';

    return '$address\n$dateLabel';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    startTime,
    endTime,
    location,
    address,
    flyer,
    user,
  ];
}
