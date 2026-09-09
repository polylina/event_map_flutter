import 'dart:ui' as ui;

import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Circular map-event marker: solid fill by default, or [image] as the fill
/// when provided (border and shadow stay the same either way).
class EventMarkerIcon extends StatelessWidget {
  const EventMarkerIcon({super.key, required this.diameter, this.image});

  static const double borderWidth = 2;

  static const Color fillColor = Color(0xFF1E88E5);
  static const Color _borderColor = Colors.white;

  final double diameter;
  final ui.Image? image;

  /// Full widget size including the margin the shadow needs so it isn't
  /// clipped when this widget is rasterized to a bitmap.
  static double totalSize(double diameter) =>
      diameter + AppSizes.shadowElevation * 4;

  @override
  Widget build(BuildContext context) {
    final size = totalSize(diameter);
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          color: Colors.transparent,
          elevation: AppSizes.shadowElevation,
          shadowColor: AppColors.shadow,
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: image == null ? fillColor : null,
              image: image == null
                  ? null
                  : DecorationImage(
                      image: _DecodedImageProvider(image!),
                      fit: BoxFit.cover,
                    ),
              border: Border.all(color: _borderColor, width: borderWidth),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps an already-decoded [ui.Image] as an [ImageProvider] so it can be
/// used in a [DecorationImage] without going through another decode/frame.
class _DecodedImageProvider extends ImageProvider<_DecodedImageProvider> {
  const _DecodedImageProvider(this.image);

  final ui.Image image;

  @override
  Future<_DecodedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _DecodedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      SynchronousFuture(ImageInfo(image: image)),
    );
  }
}
