// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEventDto _$UserEventDtoFromJson(Map<String, dynamic> json) => UserEventDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  location: LocationDto.fromJson(json['location'] as Map<String, dynamic>),
  description: json['description'] as String?,
  flyerUrl: json['flyerUrl'] as String?,
  user: json['user'] == null
      ? null
      : UserDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserEventDtoToJson(UserEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'location': instance.location,
      'description': instance.description,
      'flyerUrl': instance.flyerUrl,
      'user': instance.user,
    };
