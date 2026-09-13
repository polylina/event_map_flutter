import 'package:event_map_flutter/core/mixins/dio_client_mixin.dart';
import 'package:event_map_flutter/modules/common_events/dto/location_dto.dart';
import 'package:event_map_flutter/modules/user_events/dto/user_event_dto.dart';
import 'package:event_map_flutter/modules/common_events/dto/user_dto.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

// TODO: replace hardcoded events with a real backend/API call.
class UserEventsService with DioClientMixin {
  final List<UserEventDto> _events = [
    UserEventDto(
      id: 1,
      name: 'Team standup',
      description: 'Daily sync with the team.',
      startDate: _today.add(const Duration(hours: 9)),
      location: const LocationDto(
        id: 1,
        name: 'Office',
        address: 'Office, Main Street',
        latitude: 50.015784,
        longitude: 19.886219,
      ),
      flyerUrl: 'https://picsum.photos/id/180/1200/800',
      user: const UserDto(
        name: 'You',
        avatar: 'https://picsum.photos/id/64/200/200',
      ),
    ),
    UserEventDto(
      id: 2,
      name: 'Lunch with Alex',
      description: 'Catch up over lunch.',
      startDate: _today.add(const Duration(days: 1, hours: 12)),
      location: const LocationDto(
        id: 2,
        name: 'Cafe',
        address: 'Cafe, Main Street',
        latitude: 50.115784,
        longitude: 19.986219,
      ),
      flyerUrl: 'https://picsum.photos/id/1080/1200/800',
      user: const UserDto(
        name: 'You',
        avatar: 'https://picsum.photos/id/64/200/200',
      ),
    ),
    UserEventDto(
      id: 3,
      name: 'Dentist appointment',
      description: 'Routine checkup.',
      startDate: _today.add(const Duration(days: 3, hours: 15)),
      location: const LocationDto(
        id: 3,
        name: 'Dental Clinic',
        address: 'Dental Clinic, Main Street',
        latitude: 49.915784,
        longitude: 20.086219,
      ),
      flyerUrl: 'https://picsum.photos/id/870/1200/800',
      user: const UserDto(
        name: 'You',
        avatar: 'https://picsum.photos/id/64/200/200',
      ),
    ),
  ];

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<List<UserEventDto>> getEvents({
    DateTime? startDate,
    LatLngBounds? bounds,
  }) async {
    final endDate = startDate?.add(const Duration(days: 1));
    return _events.where((event) {
      if (startDate != null && event.startDate.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && event.startDate.isAfter(endDate)) {
        return false;
      }
      if (bounds == null) return true;
      final lat = event.location.latitude;
      final lng = event.location.longitude;
      return lat >= bounds.southwest.latitude &&
          lat <= bounds.northeast.latitude &&
          lng >= bounds.southwest.longitude &&
          lng <= bounds.northeast.longitude;
    }).toList();
  }

  Future<void> addEvent(UserEventDto event) async {
    _events.add(event);
  }
}
