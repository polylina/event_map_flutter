import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class ImageResolverService {
  Future<ui.Image> resolve(
    ImageProvider provider, {
    ImageConfiguration configuration = ImageConfiguration.empty,
  }) {
    final completer = Completer<ui.Image>();
    final stream = provider.resolve(configuration);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, synchronousCall) {
        completer.complete(info.image);
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        completer.completeError(error, stackTrace);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
    return completer.future;
  }
}
