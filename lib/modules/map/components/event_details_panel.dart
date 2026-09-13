import 'dart:math' as math;

import 'package:event_map_flutter/core/components/themed_text.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/map/components/event_marker_icon.dart';
import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/map/components/panel_controls_row.dart';
import 'package:flutter/material.dart';

/// Event details content: flyer, then event metadata and description.
class EventDetailsPanel extends StatelessWidget {
  const EventDetailsPanel({
    super.key,
    required this.event,
    required this.onClose,
    this.onBack,
  });

  final CommonEventDto event;
  final VoidCallback onClose;

  /// Set when the panel was opened from the events list.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final flyerHeight = math.min(340.0, constraints.maxHeight / 1.5);
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.generalPadding,
                  AppSizes.generalPadding,
                  AppSizes.generalPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6.0),
                    if (event.user != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (event.user!.avatar != null &&
                              event.user!.avatar!.isNotEmpty)
                            CircleAvatar(
                              radius: 8,
                              backgroundImage: NetworkImage(
                                event.user!.avatar!,
                              ),
                            ),
                          const SizedBox(width: 8),
                          ThemedText(
                            event.user!.name,
                            fontSize: 14,
                            isSecondary: true,
                          ),
                        ],
                      ),
                    const SizedBox(height: 12.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSizes.listTileBorderRadius,
                      ),
                      child: SizedBox(
                        height: flyerHeight,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            SizedBox.expand(
                              child: _FlyerImage(imageUrl: event.flyerUrl),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: flyerHeight / 2,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSizes.generalPadding,
                                    horizontal: AppSizes.generalPadding * 1.5,
                                  ),
                                  color: Colors.black54,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ThemedText(
                                        event.name,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        primaryColor: AppColors.onDark,
                                        primaryColorDark: AppColors.onDark,
                                      ),
                                      SizedBox(height: 4),
                                      ThemedText(
                                        event.longLabel(context),
                                        fontSize: 13,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        primaryColor: AppColors.onDark,
                                        primaryColorDark: AppColors.onDark,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.generalPadding),
                    Expanded(
                      child: SingleChildScrollView(
                        child:
                            event.description != null &&
                                event.description!.isNotEmpty
                            ? ThemedText(event.description!, fontSize: 14)
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        PanelControlsRow(onClose: onClose, onBack: onBack),
      ],
    );
  }
}

class _FlyerImage extends StatelessWidget {
  const _FlyerImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return ColoredBox(
        color: EventMarkerIcon.fillColor,
        child: const Center(
          child: Icon(Icons.event, color: Colors.white, size: 48),
        ),
      );
    }
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return ColoredBox(
          color: EventMarkerIcon.fillColor,
          child: const Center(
            child: Icon(Icons.event, color: Colors.white, size: 48),
          ),
        );
      },
    );
  }
}
