import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/map/components/add_event_panel.dart';
import 'package:event_map_flutter/modules/map/components/positioned_crosshair.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = '/add-event';

  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  static const double _cityZoom = 12;
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 1,
  );

  final AddEventFormCubit _formCubit = GetIt.I.get<AddEventFormCubit>();
  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();
  MapLibreMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _formCubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      bloc: _mapCubit,
      builder: (context, state) {
        if (state.styleJson == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final topMapHeight = MediaQuery.of(context).size.height / 3;

        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: topMapHeight,
                child: Stack(
                  children: [
                    MapLibreMap(
                      styleString: state.styleJson!,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) => _mapController = controller,
                      onStyleLoadedCallback: () => _panToUserPosition(state),
                      compassEnabled: false,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                    ),
                    const PositionedCrosshair(),
                  ],
                ),
              ),
              Flexible(
                child: Material(
                  elevation: AppSizes.shadowElevation,
                  child: AddEventPanel(
                    onSuggestionSelected: _panToSuggestion,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _panToUserPosition(MapState state) {
    final userPosition = state.userPosition;
    if (userPosition == null) return;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(userPosition, _cityZoom),
    );
  }

  void _panToSuggestion(AddressSuggestionDto suggestion) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(suggestion.location, _cityZoom),
    );
  }
}
