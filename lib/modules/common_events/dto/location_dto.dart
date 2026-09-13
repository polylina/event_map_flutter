import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto extends Equatable {
  final int? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  const LocationDto({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);

  @override
  List<Object?> get props => [id, name, address, latitude, longitude];
}
