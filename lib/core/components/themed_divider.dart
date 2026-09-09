import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';

class ThemedDivider extends StatelessWidget {
  const ThemedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Divider(
        height: 1,
        color: isDark ? AppColors.darkDivider : AppColors.divider,
      ),
    );
  }
}
