import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';

class ButtonPrimaryDark extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final bool? softWrap;

  const ButtonPrimaryDark({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.textStyle,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) {
        final foregroundColor = isDark ? AppColors.text : AppColors.darkText;
        final text = Text(
          label,
          style: TextStyle(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
          ).merge(textStyle),
          textAlign: textAlign,
          overflow: textOverflow,
          maxLines: maxLines,
          softWrap: softWrap,
        );
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.transparent : AppColors.text,
            ),
          ),
          child: Material(
            color: isDark
                ? AppColors.darkButtonPrimary
                : AppColors.buttonPrimary,
            borderRadius: BorderRadius.circular(24),
            elevation: AppSizes.shadowElevation,
            shadowColor: AppColors.shadow,
            clipBehavior: Clip.antiAlias,
            child: WebCursorRegion(
              cursor: CSSCursor.pointer,
              child: InkWell(
                onTap: onPressed,
                child: SizedBox(
                  height: kMinInteractiveDimension,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: icon == null
                        ? text
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, color: foregroundColor, size: 20),
                              const SizedBox(width: 8),
                              Flexible(child: text),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
