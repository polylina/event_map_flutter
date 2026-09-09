import 'package:flutter/painting.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:equatable/equatable.dart';

class MapState extends Equatable {
  final LatLng? userPosition;
  final String? styleJson;
  final DateTime? startDate;
  final LatLng? panTarget;

  /// Where the pan target should land on screen, relative to the map center,
  /// in logical pixels.
  final Offset panOffset;
  final bool isPanelOpen;
  final bool isPanelAnimating;
  final bool isMapScrollable;
  final int zoomRequest;
  final bool isZoomingIn;

  const MapState({
    this.userPosition,
    this.styleJson,
    this.startDate,
    this.panTarget,
    this.panOffset = Offset.zero,
    this.isPanelOpen = false,
    this.isPanelAnimating = false,
    this.isMapScrollable = true,
    this.zoomRequest = 0,
    this.isZoomingIn = true,
  });

  MapState copyWith({
    LatLng? userPosition,
    String? styleJson,
    DateTime? startDate,
    LatLng? panTarget,
    Offset? panOffset,
    bool? isPanelOpen,
    bool? isPanelAnimating,
    bool? isMapScrollable,
    int? zoomRequest,
    bool? isZoomingIn,
  }) {
    return MapState(
      userPosition: userPosition ?? this.userPosition,
      styleJson: styleJson ?? this.styleJson,
      startDate: startDate ?? this.startDate,
      panTarget: panTarget ?? this.panTarget,
      panOffset: panOffset ?? this.panOffset,
      isPanelOpen: isPanelOpen ?? this.isPanelOpen,
      isPanelAnimating: isPanelAnimating ?? this.isPanelAnimating,
      isMapScrollable: isMapScrollable ?? this.isMapScrollable,
      zoomRequest: zoomRequest ?? this.zoomRequest,
      isZoomingIn: isZoomingIn ?? this.isZoomingIn,
    );
  }

  @override
  List<Object?> get props => [
    userPosition,
    styleJson,
    startDate,
    panTarget,
    panOffset,
    isPanelOpen,
    isPanelAnimating,
    isMapScrollable,
    zoomRequest,
    isZoomingIn,
  ];
}
