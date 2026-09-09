import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/modules/map/services/geolocation_service.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';

class MapCubit extends Cubit<MapState> {
  static const String _colorfulStyleAsset = 'assets/styles/colorful/style.json';
  static const String _shadowStyleAsset = 'assets/styles/shadow/style.json';

  final GeolocationService _geolocationService = GetIt.I
      .get<GeolocationService>();
  StreamSubscription? _themeStream;

  MapCubit() : super(MapState(startDate: DateTime.now()));

  @override
  Future<void> close() {
    _themeStream?.cancel();
    return super.close();
  }

  Future<void> init() async {
    _themeStream ??= GetIt.I
        .get<SettingsCubit>()
        .stream
        .distinct(
          (previous, next) => previous.themeBrightness == next.themeBrightness,
        )
        .listen((state) {
          loadStyleForCurrentTheme();
        });
    loadStyleForCurrentTheme();
  }

  void loadStyleForCurrentTheme() async {
    final styleJson = await getStyleForCurrentTheme();
    emit(state.copyWith(styleJson: styleJson));
  }

  Future<void> findUser() async {
    final userPosition = await _geolocationService.getUserPosition();
    emit(
      state.copyWith(
        userPosition: userPosition,
        panTarget: userPosition,
        panOffset: Offset.zero,
      ),
    );
  }

  Future<String> getStyleForCurrentTheme() async {
    final isDark =
        GetIt.I.get<SettingsCubit>().state.themeBrightness == Brightness.dark;
    final styleJson = await rootBundle.loadString(
      isDark ? _shadowStyleAsset : _colorfulStyleAsset,
    );
    return styleJson;
  }

  void setStartDate(DateTime startDate) {
    emit(state.copyWith(startDate: startDate));
  }

  void zoomIn() {
    emit(state.copyWith(zoomRequest: state.zoomRequest + 1, isZoomingIn: true));
  }

  void zoomOut() {
    emit(
      state.copyWith(zoomRequest: state.zoomRequest + 1, isZoomingIn: false),
    );
  }

  void panTo(LatLng target, {Offset offset = Offset.zero}) {
    emit(state.copyWith(panTarget: target, panOffset: offset));
  }

  void openPanel() {
    // The form cubit is a long-lived singleton shared across panel opens.
    GetIt.I.get<AddEventFormCubit>().reset();
    emit(state.copyWith(isPanelOpen: true, isPanelAnimating: true));
  }

  void closePanel() {
    emit(state.copyWith(isPanelOpen: false, isPanelAnimating: true));
  }

  void onPanelAnimationEnd() {
    emit(state.copyWith(isPanelAnimating: false));
  }

  void setMapScrollable(bool isMapScrollable) {
    emit(state.copyWith(isMapScrollable: isMapScrollable));
  }
}
