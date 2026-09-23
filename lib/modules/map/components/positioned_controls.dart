import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/auth/components/login_control.dart';
import 'package:event_map_flutter/modules/settings/components/language_switch.dart';
import 'package:event_map_flutter/modules/settings/components/theme_switch.dart';
import 'package:event_map_flutter/modules/map/components/zoom_controls.dart';
import 'package:flutter/material.dart';

class PositionedControls extends StatelessWidget {
  const PositionedControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: AppSizes.generalPadding,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LoginControl(),
            LanguageSwitch(),
            ThemeSwitch(),
            const ZoomControls(),
          ],
        ),
      ),
    );
  }
}
