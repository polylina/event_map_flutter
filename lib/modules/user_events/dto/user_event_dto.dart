import 'package:json_annotation/json_annotation.dart';
import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/common_events/dto/location_dto.dart';
import 'package:event_map_flutter/modules/common_events/dto/user_dto.dart';

part 'user_event_dto.g.dart';

@JsonSerializable()
class UserEventDto extends CommonEventDto {
  const UserEventDto({
    required super.id,
    required super.name,
    required super.startDate,
    required super.location,
    super.description,
    super.flyerUrl,
    super.user,
  });

  factory UserEventDto.fromJson(Map<String, dynamic> json) =>
      _$UserEventDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserEventDtoToJson(this);
}
