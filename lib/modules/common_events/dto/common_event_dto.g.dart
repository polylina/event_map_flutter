// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonEventDto _$CommonEventDtoFromJson(Map<String, dynamic> json) =>
    CommonEventDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: const LatLngConverter().fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      address: json['address'] as String,
      flyer: json['flyer'] as String?,
      user: json['user'] == null
          ? null
          : UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommonEventDtoToJson(CommonEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': const LatLngConverter().toJson(instance.location),
      'address': instance.address,
      'flyer': instance.flyer,
      'user': instance.user,
    };
