import 'package:event_map_flutter/modules/user_events/dto/user_event_dto.dart';
import 'package:event_map_flutter/modules/common_events/dto/user_dto.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

// TODO: replace hardcoded events with a real backend/API call.
class UserEventsService {
  final List<UserEventDto> _events = [
    UserEventDto(
      id: '1',
      name: 'Team standup',
      address: 'Office, Main Street',
      description: 'Daily sync with the team.',
      startTime: _today.add(const Duration(hours: 9)),
      endTime: _today.add(const Duration(hours: 9, minutes: 30)),
      location: const LatLng(50.015784, 19.886219),
      flyer: 'https://picsum.photos/id/180/1200/800',
      user: const UserDto(
        name: 'You',
        avatar: 'https://picsum.photos/id/64/200/200',
      ),
    ),
    UserEventDto(
      id: '2',
      name: 'Lunch with Alex',
      address: 'Cafe, Main Street',
      description: 'Catch up over lunch.',
      startTime: _today.add(const Duration(days: 1, hours: 12)),
      endTime: _today.add(const Duration(days: 1, hours: 13)),
      location: const LatLng(50.115784, 19.986219),
      flyer: 'https://picsum.photos/id/1080/1200/800',
      user: const UserDto(
        name: 'You',
        avatar: 'https://picsum.photos/id/64/200/200',
      ),
    ),
    UserEventDto(
      id: '3',
      name: 'Dentist appointment',
      address: 'Dental Clinic, Main Street',
      description: 'Routine checkup.',
      startTime: _today.add(const Duration(days: 3, hours: 15)),
      endTime: _today.add(const Duration(days: 3, hours: 16)),
      location: const LatLng(49.915784, 20.086219),
      flyer: 'https://picsum.photos/id/870/1200/800',
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
      if (startDate != null && event.startTime.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && event.startTime.isAfter(endDate)) {
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
