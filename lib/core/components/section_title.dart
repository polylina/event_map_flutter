import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/components/themed_divider.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final Color? color;

  const SectionTitle(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Row(
        children: [
          LineDecoration(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text.translated.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontSize: 11,
                color:
                    color ??
                    (isDark ? AppColors.darkText : AppColors.sectionTitle),
              ),
            ),
          ),
          LineDecoration(),
        ],
      ),
    );
  }
}

class LineDecoration extends StatelessWidget {
  final Color? color;

  const LineDecoration({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Expanded(child: ThemedDivider()),
    );
  }
}
