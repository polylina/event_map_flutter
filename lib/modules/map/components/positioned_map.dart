import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/common_events/store/common_events_cubit.dart';
import 'package:event_map_flutter/modules/map/components/event_marker_icon.dart';
import 'package:event_map_flutter/modules/map/services/map_image_service.dart';
import 'package:event_map_flutter/modules/map/store/event_details_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';
import 'package:event_map_flutter/modules/user_events/store/user_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

const CameraPosition _initialCameraPosition = CameraPosition(
  target: LatLng(0, 0),
  zoom: 1,
);

const double metersPerDegree = 111320;
const double equatorMetersPerPixelAtZoom0 = 78271.51696;

class PositionedMap extends StatefulWidget {
  const PositionedMap({super.key});

  @override
  State<PositionedMap> createState() => _PositionedMapState();
}

class _PositionedMapState extends State<PositionedMap> {
  static const double _cityZoom = 12;
  static const String _markerImageId = 'event-marker';
  static const double _markerDiameter = 24;
  static const double _markerPixelRatio = 3;

  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();
  final UserEventsCubit _userEventsCubit = GetIt.I.get<UserEventsCubit>();
  final CommonEventsCubit _commonEventsCubit = GetIt.I.get<CommonEventsCubit>();
  final MapImageService _mapImageService = GetIt.I.get<MapImageService>();
  final EventDetailsCubit _eventDetailsCubit = GetIt.I.get<EventDetailsCubit>();
  MapLibreMapController? _mapController;
  late int _lastZoomRequest;
  List<Symbol> _eventMarkers = [];
  Map<String, CommonEventDto> _markerEventsById = {};
  final Set<String> _registeredImageIds = {};
  late StreamSubscription _startDateStream;
  late StreamSubscription _panTargetStream;
  late StreamSubscription _zoomStream;
  late StreamSubscription _panelOpenStream;
  late StreamSubscription _userEventsStream;
  late StreamSubscription _commonEventsStream;

  bool _isStyleLoaded = false;

  @override
  void initState() {
    super.initState();
    // Changes in timeline
    _startDateStream = _mapCubit.stream
        .distinct((previous, next) => previous.startDate == next.startDate)
        .listen((state) {
          if (_isStyleLoaded) {
            _loadEvents();
          }
        });
    // Changes in target address
    _panTargetStream = _mapCubit.stream
        .distinct((previous, next) => previous.panTarget == next.panTarget)
        .listen((state) {
          if (_isStyleLoaded) {
            _panTo(state.panTarget, state.panOffset);
          }
        });
    // `distinct` still lets the first observed state through, so the zoom
    // request is tracked explicitly — otherwise the initial state would zoom
    // the camera and cancel the pan to the user position.
    _lastZoomRequest = _mapCubit.state.zoomRequest;
    _zoomStream = _mapCubit.stream
        .where((state) => state.zoomRequest != _lastZoomRequest)
        .listen((state) {
          _lastZoomRequest = state.zoomRequest;
          _zoom(state.isZoomingIn);
        });
    // Changes in panel open state
    _panelOpenStream = _mapCubit.stream
        .distinct((previous, next) => previous.isPanelOpen == next.isPanelOpen)
        .listen((state) {
          _loadEvents();
        });
    // Changes in user events
    _userEventsStream = _userEventsCubit.stream.listen((state) {
      _drawMarkers(state.events);
    });
    // Changes in common events
    _commonEventsStream = _commonEventsCubit.stream.listen((state) {
      _drawMarkers(state.events);
    });
  }

  @override
  void dispose() {
    _startDateStream.cancel();
    _panTargetStream.cancel();
    _zoomStream.cancel();
    _panelOpenStream.cancel();
    _userEventsStream.cancel();
    _commonEventsStream.cancel();
    _mapController?.onSymbolTapped.remove(_onSymbolTapped);
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      bloc: _mapCubit,
      builder: (context, state) {
        return Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: MapLibreMap(
            styleString: state.styleJson!,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (MapLibreMapController controller) {
              _mapController = controller;
              controller.onSymbolTapped.add(_onSymbolTapped);
            },
            onStyleLoadedCallback: () {
              // Style images are tied to the style instance; the cache and old
              // marker references must be discarded on every style load.
              _isStyleLoaded = true;
              _registeredImageIds.clear();
              _eventMarkers = [];
              if (_markerEventsById.isNotEmpty) {
                _drawMarkers(_markerEventsById.values.toList());
              }
              // A style (re)load resets the camera, so re-apply the last target.
              final panTarget = _mapCubit.state.panTarget;
              if (panTarget == null) {
                _mapCubit.findUser();
              } else {
                _panTo(panTarget, _mapCubit.state.panOffset);
              }
            },
            onCameraIdle: _loadEvents,
            compassEnabled: false,
            scrollGesturesEnabled: state.isMapScrollable,
            zoomGesturesEnabled: state.isMapScrollable,
          ),
        );
      },
    );
  }

  void _panTo(LatLng? target, Offset offset) {
    if (target == null) {
      return;
    }
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_cameraCenterFor(target, offset), _cityZoom),
    );
  }

  // Shifts the camera center so that `target` lands `offset` logical pixels
  // away from the middle of the map (used to keep it clear of open panels).
  LatLng _cameraCenterFor(LatLng target, Offset offset) {
    if (offset == Offset.zero) {
      return target;
    }
    final latitudeRadians = target.latitude * pi / 180;
    final metersPerPixel =
        equatorMetersPerPixelAtZoom0 * cos(latitudeRadians) / pow(2, _cityZoom);
    return LatLng(
      target.latitude + offset.dy * metersPerPixel / metersPerDegree,
      target.longitude -
          offset.dx * metersPerPixel / (metersPerDegree * cos(latitudeRadians)),
    );
  }

  void _onSymbolTapped(Symbol symbol) {
    final eventId = symbol.data?['eventId'] as String?;
    final event = _markerEventsById[eventId];
    if (event != null) {
      _eventDetailsCubit.showEvent(event);
    }
  }

  void _zoom(bool isZoomingIn) {
    _mapController?.animateCamera(
      isZoomingIn ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut(),
    );
  }

  Future<void> _loadEvents() async {
    final bounds = await _visibleRegionOrNull();
    if (_mapCubit.state.isPanelOpen) {
      await _userEventsCubit.loadEvents(
        bounds: bounds,
        startDate: _mapCubit.state.startDate,
      );
    } else {
      await _commonEventsCubit.loadEvents(
        bounds: bounds,
        startDate: _mapCubit.state.startDate,
      );
    }
  }

  // getVisibleRegion fails with PlatformException while a new style is still
  // being applied (e.g. when called from onStyleLoadedCallback or right after
  // a theme switch); treat it as "no bounds" and let the next onCameraIdle
  // reload with fresh bounds.
  Future<LatLngBounds?> _visibleRegionOrNull() async {
    final controller = _mapController;
    if (controller == null || !_isStyleLoaded) return null;
    try {
      return await controller.getVisibleRegion();
    } on PlatformException {
      return null;
    }
  }

  Future<void> _drawMarkers(List<CommonEventDto> events) async {
    final controller = _mapController;
    if (controller == null || !_isStyleLoaded) return;
    if (_eventMarkers.isNotEmpty) {
      await controller.removeSymbols(_eventMarkers);
    }
    final imageIds = await Future.wait(
      events.map(
        (event) => _ensureMarkerImageRegistered(controller, event.flyer),
      ),
    );
    // Only the JSON-serializable id is passed as symbol data; the full event
    // object can't cross the platform channel (fails in removeAll/addAll's
    // GeoJSON re-serialization).
    final markers = await controller.addSymbols(
      [
        for (var i = 0; i < events.length; i++)
          SymbolOptions(
            geometry: events[i].location,
            iconImage: imageIds[i],
            iconSize: 1 / _markerPixelRatio,
            iconAnchor: 'center',
          ),
      ],
      [
        for (final event in events) {'eventId': event.id},
      ],
    );
    if (!mounted) return;
    setState(() {
      _eventMarkers = markers;
      _markerEventsById = {for (final event in events) event.id: event};
    });
  }

  // Flyer url doubles as the maplibre image id; falls back to the default marker.
  Future<String> _ensureMarkerImageRegistered(
    MapLibreMapController controller,
    String? flyerUrl,
  ) async {
    final imageId = flyerUrl ?? _markerImageId;
    if (_registeredImageIds.contains(imageId)) return imageId;
    var isMobile = false;
    try {
      isMobile = Platform.isAndroid || Platform.isIOS;
    } catch (_) {}
    final bytes = await _mapImageService.render<EventMarkerIcon>(
      size: EventMarkerIcon.totalSize(_markerDiameter),
      pixelRatio: isMobile
          ? MediaQuery.of(context).devicePixelRatio * _markerPixelRatio
          : _markerPixelRatio,
      image: flyerUrl == null ? null : NetworkImage(flyerUrl),
      builder: (image) =>
          EventMarkerIcon(diameter: _markerDiameter, image: image),
    );
    await controller.addImage(imageId, bytes);
    _registeredImageIds.add(imageId);
    return imageId;
  }
}
