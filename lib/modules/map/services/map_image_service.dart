import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:event_map_flutter/core/services/image_resolver_service.dart';
import 'package:event_map_flutter/core/services/widget_rasterizer_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// Rasterizes map icon widgets to PNG bytes so they can be registered via
/// `MapLibreMapController.addImage` and used as symbol icons — native map
/// layers can't render Flutter widgets/shadows directly.
class MapImageService {
  final ImageResolverService _imageResolverService;
  final WidgetRasterizerService _widgetRasterizerService;

  MapImageService({
    ImageResolverService? imageResolverService,
    WidgetRasterizerService? widgetRasterizerService,
  }) : _imageResolverService =
           imageResolverService ?? GetIt.I.get<ImageResolverService>(),
       _widgetRasterizerService =
           widgetRasterizerService ?? GetIt.I.get<WidgetRasterizerService>();

  Future<Uint8List> render<T extends Widget>({
    required double size,
    T Function(ui.Image? image)? builder,
    T? widget,
    ImageProvider? image,
    double pixelRatio = 3,
  }) async {
    assert(
      builder != null || widget != null,
      'Either builder or widget must be provided',
    );
    final decodedImage = image == null
        ? null
        : await _imageResolverService.resolve(image);
    final resolvedWidget = builder != null ? builder(decodedImage) : widget!;
    final rasterized = await _widgetRasterizerService.rasterize(
      resolvedWidget,
      size: size,
      pixelRatio: pixelRatio,
    );
    final byteData = await rasterized.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }
}
