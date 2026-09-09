import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:flutter/material.dart';

class PanelTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign alignment;

  const PanelTitle(
    this.text, {
    super.key,
    this.color,
    this.alignment = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Text(
        text.translated,
        textAlign: alignment,
        maxLines: 2,
        overflow: TextOverflow.fade,
        softWrap: true,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color ?? (isDark ? AppColors.darkText : AppColors.text),
        ),
      ),
    );
  }
}
