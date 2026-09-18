import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/map/store/map_cubit.dart';

import 'package:event_map_flutter/core/utils/web_cursor.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';

class Timeline extends StatefulWidget {
  static const double barHeight = 44.0;

  const Timeline({
    super.key,
    required this.direction,
    this.initialDate,
    this.onDateSelected,
    this.allowPastSelection = false,
  });

  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final TextDirection direction;
  final bool allowPastSelection;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  static const int _minuteStep = 15;
  static const Set<String> _twelveHourLanguageCodes = {'en-US'};

  static const List<String> _weekdayKeys = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];

  static const List<String> _monthKeys = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  final MapCubit _mapCubit = GetIt.I.get<MapCubit>();

  late DateTime _selectedDate;
  late int _minutes;

  DateTime get _selectedDateTime => DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    _minutes ~/ 60,
    _minutes % 60,
  );

  DateTime get _minimumDate {
    if (widget.allowPastSelection) return DateTime(1900);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime.now();
    final minimum = _minimumDate;
    _selectedDate = initialDate.isBefore(minimum)
        ? minimum
        : DateTime(initialDate.year, initialDate.month, initialDate.day);
    _minutes =
        ((initialDate.hour * 60 + initialDate.minute) / _minuteStep).round() *
        _minuteStep;
    if (!widget.allowPastSelection) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (!_selectedDate.isAfter(today) &&
          _minutes < now.hour * 60 + now.minute) {
        _minutes = now.hour * 60 + now.minute;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final divider = VerticalDivider(width: 1, indent: 8, endIndent: 8);
    final buttons = <Widget>[
      _PickerButton(
        label: _dateLabel(),
        icon: CupertinoIcons.calendar,
        onTap: _pickDate,
      ),
      divider,
      _PickerButton(
        label: _timeLabel(),
        icon: CupertinoIcons.clock,
        onTap: _pickTime,
      ),
    ];
    return Material(
      elevation: 6,
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: Timeline.barHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.direction == TextDirection.rtl
              ? buttons.reversed.toList()
              : buttons,
        ),
      ),
    );
  }

  String _dateLabel() {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final length = isPortrait ? 'short' : 'long';
    final weekday =
        'timeline.weekday.$length.${_weekdayKeys[_selectedDate.weekday - 1]}'
            .translated;
    final month = 'timeline.month.short.${_monthKeys[_selectedDate.month - 1]}'
        .translated;
    return '$weekday, ${_selectedDate.day} $month';
  }

  String _timeLabel() {
    final languageCode = GetIt.I
        .get<SettingsCubit>()
        .state
        .language
        ?.languageCode;
    if (!_twelveHourLanguageCodes.contains(languageCode)) {
      final hour = (_minutes ~/ 60).toString().padLeft(2, '0');
      final minute = (_minutes % 60).toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final hour24 = _minutes ~/ 60;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = (_minutes % 60).toString().padLeft(2, '0');
    final period = hour24 < 12
        ? 'timeline.time.am'.translated
        : 'timeline.time.pm'.translated;
    return '$hour12:$minute $period';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(_minimumDate)
          ? _minimumDate
          : _selectedDate,
      firstDate: _minimumDate,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) => MouseRegion(
        onEnter: (_) {
          _mapCubit.setMapScrollable(false);
          setWebCursor(CSSCursor.defaultCursor);
        },
        onExit: (_) {
          _mapCubit.setMapScrollable(true);
          setWebCursor(CSSCursor.grab);
        },
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
      if (!_isTimeValid(_minutes)) {
        _minutes = _clampTime(_minutes);
      }
    });
    widget.onDateSelected?.call(_selectedDateTime);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minutes ~/ 60, minute: _minutes % 60),
      builder: (dialogContext, child) => MediaQuery(
        data: MediaQuery.of(
          dialogContext,
        ).copyWith(alwaysUse24HourFormat: !_uses12HourClock),
        child: MouseRegion(
          onEnter: (_) {
            _mapCubit.setMapScrollable(false);
            setWebCursor(CSSCursor.defaultCursor);
          },
          onExit: (_) {
            _mapCubit.setMapScrollable(true);
            setWebCursor(CSSCursor.grab);
          },
          child: child!,
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _minutes = _clampTime(picked.hour * 60 + picked.minute));
    widget.onDateSelected?.call(_selectedDateTime);
  }

  bool get _uses12HourClock {
    final languageCode = GetIt.I
        .get<SettingsCubit>()
        .state
        .language
        ?.languageCode;
    return _twelveHourLanguageCodes.contains(languageCode);
  }

  bool _isTimeValid(int minutes) {
    if (widget.allowPastSelection) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_selectedDate.isAfter(today)) return true;
    if (_selectedDate.isBefore(today)) return false;
    return minutes >= now.hour * 60 + now.minute;
  }

  int _clampTime(int minutes) {
    if (_isTimeValid(minutes)) return minutes;
    final now = DateTime.now();
    return now.hour * 60 + now.minute;
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WebCursorRegion(
      cursor: CSSCursor.pointer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: Timeline.barHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  maxLines: 1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
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
