import 'package:event_map_flutter/core/components/web_icon_button.dart';
import 'package:flutter/material.dart';

/// Bottom row of a map panel: optional back arrow at the leading corner and
/// the close button at the trailing one.
class PanelControlsRow extends StatelessWidget {
  const PanelControlsRow({super.key, required this.onClose, this.onBack});

  static const double _cornerPadding = 4;

  final VoidCallback onClose;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_cornerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (onBack != null)
            WebIconButton(icon: Icons.arrow_back, onPressed: onBack)
          else
            const SizedBox.shrink(),
          WebIconButton(icon: Icons.close, onPressed: onClose),
        ],
      ),
    );
  }
}
