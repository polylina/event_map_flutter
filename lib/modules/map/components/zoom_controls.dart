import 'package:event_map_flutter/core/components/web_icon_button.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    final mapCubit = GetIt.I.get<MapCubit>();
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: AppSizes.shadowElevation,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
      child: SizedBox(
        width: kMinInteractiveDimension,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WebIconButton(
              tooltip: 'Zoom in',
              icon: Icons.add,
              onPressed: mapCubit.zoomIn,
            ),
            const Divider(height: 1),
            WebIconButton(
              tooltip: 'Zoom out',
              icon: Icons.remove,
              onPressed: mapCubit.zoomOut,
            ),
          ],
        ),
      ),
    );
  }
}
