import 'package:event_map_flutter/core/components/web_cursor_region.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:event_map_flutter/core/components/themed_text.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/map/components/event_icon_avatar.dart';
import 'package:flutter/material.dart';

/// Single row of the events list: icon column + name / date / details column.
class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.event, required this.onTap});

  static const double height = 72;

  final CommonEventDto event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WebCursorRegion(
      cursor: CSSCursor.pointer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.listTileBorderRadius),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EventIconAvatar(iconUrl: event.flyerUrl, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ThemedText(
                        event.name,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ThemedText(
                        event.longLabel(context),
                        fontSize: 12,
                        isSecondary: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
