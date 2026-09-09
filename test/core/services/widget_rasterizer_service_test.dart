import 'package:event_map_flutter/core/di/service_locator.dart';
import 'package:event_map_flutter/core/services/widget_rasterizer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('WidgetRasterizerService', () {
    setUp(() {
      GetIt.I.reset();
      ServiceLocator.registerInstances();
    });

    test('is registered in ServiceLocator', () {
      final service = GetIt.I.get<WidgetRasterizerService>();
      expect(service, isA<WidgetRasterizerService>());
    });

    testWidgets('rasterizes Widget to ui.Image', (tester) async {
      final service = WidgetRasterizerService();
      final image = await service.rasterize(
        const SizedBox(
          width: 30,
          height: 30,
          child: ColoredBox(color: Colors.red),
        ),
        size: 30,
        pixelRatio: 2,
      );

      expect(image.width, 60);
      expect(image.height, 60);
    });
  });
}
