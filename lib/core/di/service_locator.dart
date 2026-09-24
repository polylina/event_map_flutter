import 'package:event_map_flutter/core/services/image_resolver_service.dart';
import 'package:event_map_flutter/core/services/notification_service.dart';
import 'package:event_map_flutter/core/services/widget_rasterizer_service.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/auth/services/auth_service.dart';
import 'package:event_map_flutter/modules/auth/services/auth_storage_service.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';
import 'package:event_map_flutter/modules/common_events/services/common_events_service.dart';
import 'package:event_map_flutter/modules/common_events/store/common_events_cubit.dart';
import 'package:event_map_flutter/modules/map/services/geolocation_service.dart';
import 'package:event_map_flutter/modules/map/services/geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/map_image_service.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/event_details_cubit.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:event_map_flutter/modules/settings/services/locale_detection_service.dart';
import 'package:event_map_flutter/modules/settings/services/settings_storage_service.dart';
import 'package:event_map_flutter/modules/settings/services/theme_detection_service.dart';
import 'package:event_map_flutter/modules/settings/services/translation_service.dart';
import 'package:event_map_flutter/modules/settings/services/world_region_service.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:event_map_flutter/modules/user_events/services/user_events_service.dart';
import 'package:event_map_flutter/modules/user_events/store/user_events_cubit.dart';

class ServiceLocator {
  static void registerInstances() {
    //Plugins and wrappers
    // TODO: register plugins and wrappers here
    // End plugins and wrappers

    //Components
    // TODO: register components here
    // End components

    //Services
    _registerLazySingleton<GeolocationService>(() => GeolocationService());
    _registerLazySingleton<GeocodingService>(() => GeocodingService());
    _registerLazySingleton<ThemeDetectionService>(
      () => ThemeDetectionService(),
    );
    _registerLazySingleton<LocaleDetectionService>(
      () => LocaleDetectionService(),
    );
    _registerLazySingleton<TranslationService>(() => TranslationService());
    _registerLazySingleton<WorldRegionService>(() => WorldRegionService());
    _registerLazySingleton<SettingsStorageService>(
      () => SettingsStorageService(),
    );
    _registerLazySingleton<NotificationService>(() => NotificationService());
    _registerLazySingleton<ImageResolverService>(() => ImageResolverService());
    _registerLazySingleton<WidgetRasterizerService>(
      () => WidgetRasterizerService(),
    );
    _registerLazySingleton<MapImageService>(() => MapImageService());
    _registerLazySingleton<UserEventsService>(() => UserEventsService());
    _registerLazySingleton<CommonEventsService>(() => CommonEventsService());
    _registerLazySingleton<AuthService>(() => AuthService());
    _registerLazySingleton<AuthStorageService>(() => AuthStorageService());
    // End services

    //Blocs and Cubits
    _registerLazySingleton<MapCubit>(() => MapCubit());
    _registerLazySingleton<AddEventFormCubit>(() => AddEventFormCubit());
    _registerLazySingleton<EventDetailsCubit>(() => EventDetailsCubit());
    _registerLazySingleton<UserEventsCubit>(() => UserEventsCubit());
    _registerLazySingleton<CommonEventsCubit>(() => CommonEventsCubit());
    _registerLazySingleton<SettingsCubit>(() => SettingsCubit());
    _registerLazySingleton<AuthCubit>(() => AuthCubit());
    // End blocs and cubits
  }

  static void _registerLazySingleton<T extends Object>(T Function() register) {
    if (!GetIt.I.isRegistered<T>()) {
      GetIt.I.registerLazySingleton(register);
    }
  }

  ServiceLocator._();
}
