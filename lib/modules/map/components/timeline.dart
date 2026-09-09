import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';

class Timeline extends StatefulWidget {
  const Timeline({
    super.key,
    required this.direction,
    this.initialDate,
    this.onDateSelected,
    this.allowPastSelection = false,
    this.onEnter,
    this.onExit,
  });

  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final TextDirection direction;
  final bool allowPastSelection;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;

  static const double barHeight = 44.0;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  static const int _minuteStep = 15;
  static const int _monthCount = 12;
  static const int _timeSlotCount = 24 * 60 ~/ _minuteStep;
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

  late final List<DateTime> _months;
  late final FixedExtentScrollController _monthController;
  late final FixedExtentScrollController _dateController;
  late final FixedExtentScrollController _timeController;
  late int _monthIndex;
  late int _day;
  late int _timeIndex;

  DateTime get _selectedMonth => _months[_monthIndex];

  DateTime get _selectedDate =>
      DateTime(_selectedMonth.year, _selectedMonth.month, _day);

  int get _daysInMonth =>
      DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime.now();
    final now = DateTime.now();
    final firstMonth = widget.allowPastSelection
        ? DateTime(initialDate.year, initialDate.month)
        : DateTime(now.year, now.month);
    _months = List.generate(
      _monthCount,
      (i) => DateTime(firstMonth.year, firstMonth.month + i),
    );
    _monthIndex =
        ((initialDate.year - firstMonth.year) * 12 +
                initialDate.month -
                firstMonth.month)
            .clamp(0, _monthCount - 1);
    _day = initialDate.day.clamp(1, _daysInMonth);
    _timeIndex = ((initialDate.hour * 60 + initialDate.minute) / _minuteStep)
        .round()
        .clamp(0, _timeSlotCount - 1);
    _monthController = FixedExtentScrollController(initialItem: _monthIndex);
    _dateController = FixedExtentScrollController(initialItem: _day - 1);
    _timeController = FixedExtentScrollController(initialItem: _timeIndex);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final divider = VerticalDivider(width: 1, indent: 8, endIndent: 8);
    final columns = <Widget>[
      _Wheel(
        controller: _monthController,
        itemCount: _monthCount,
        width: isPortrait ? 90 : 120,
        selectedIndex: _monthIndex,
        isEnabled: (_) => true,
        labelBuilder: (index) => _monthLabel(index, isPortrait),
        onChanged: _onMonthChanged,
      ),
      divider,
      _Wheel(
        controller: _dateController,
        itemCount: _daysInMonth,
        width: isPortrait ? 90 : 120,
        selectedIndex: _day - 1,
        isEnabled: (index) => _isDateEnabled(index + 1),
        colorBuilder: (index) =>
            _isWeekend(index + 1) ? theme.colorScheme.error : null,
        labelBuilder: (index) => _dateLabel(index, isPortrait),
        onChanged: _onDateChanged,
      ),
      divider,
      _Wheel(
        controller: _timeController,
        itemCount: _timeSlotCount,
        width: 90,
        selectedIndex: _timeIndex,
        isEnabled: _isTimeEnabled,
        labelBuilder: _timeLabel,
        onChanged: _onTimeChanged,
      ),
    ];
    return MouseRegion(
      onEnter: (_) => widget.onEnter?.call(),
      onExit: (_) => widget.onExit?.call(),
      child: Material(
        elevation: 6,
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: Timeline.barHeight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.direction == TextDirection.rtl
                ? columns.reversed.toList()
                : columns,
          ),
        ),
      ),
    );
  }

  String _monthLabel(int index, bool isPortrait) {
    final month = _months[index];
    final length = isPortrait ? 'short' : 'long';
    final name =
        'timeline.month.$length.${_monthKeys[month.month - 1]}'.translated;
    return month.month == 1 ? '$name ${month.year}' : name;
  }

  String _dateLabel(int index, bool isPortrait) {
    final date = DateTime(_selectedMonth.year, _selectedMonth.month, index + 1);
    final length = isPortrait ? 'short' : 'long';
    final weekday =
        'timeline.weekday.$length.${_weekdayKeys[date.weekday - 1]}'.translated;
    return '$weekday ${date.day}';
  }

  String _timeLabel(int index) {
    final minutes = index * _minuteStep;
    final languageCode = GetIt.I
        .get<SettingsCubit>()
        .state
        .language
        ?.languageCode;
    if (!_twelveHourLanguageCodes.contains(languageCode)) {
      final hour = (minutes ~/ 60).toString().padLeft(2, '0');
      final minute = (minutes % 60).toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final hour24 = minutes ~/ 60;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = (minutes % 60).toString().padLeft(2, '0');
    final period = hour24 < 12
        ? 'timeline.time.am'.translated
        : 'timeline.time.pm'.translated;
    return '$hour12:$minute $period';
  }

  bool _isDateEnabled(int day) {
    if (widget.allowPastSelection) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      day,
    ).isBefore(today);
  }

  bool _isWeekend(int day) {
    final weekday = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      day,
    ).weekday;
    return weekday == DateTime.sunday;
  }

  bool _isTimeEnabled(int index) {
    if (widget.allowPastSelection) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_selectedDate.isAfter(today)) return true;
    if (_selectedDate.isBefore(today)) return false;
    return index * _minuteStep >= now.hour * 60 + now.minute;
  }

  void _onMonthChanged(int index) {
    setState(() {
      _monthIndex = index;
      _day = _day.clamp(1, _daysInMonth);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dateController.hasClients) {
        _dateController.jumpToItem(_day - 1);
      }
    });
    _emitSelection();
  }

  void _onDateChanged(int index) {
    if (!_isDateEnabled(index + 1)) return;
    setState(() => _day = index + 1);
    _emitSelection();
  }

  void _onTimeChanged(int index) {
    if (!_isTimeEnabled(index)) return;
    setState(() => _timeIndex = index);
    _emitSelection();
  }

  void _emitSelection() {
    final minutes = _timeIndex * _minuteStep;
    widget.onDateSelected?.call(
      DateTime(
        _selectedMonth.year,
        _selectedMonth.month,
        _day,
        minutes ~/ 60,
        minutes % 60,
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.controller,
    required this.itemCount,
    required this.width,
    required this.selectedIndex,
    required this.isEnabled,
    this.colorBuilder,
    required this.labelBuilder,
    required this.onChanged,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final double width;
  final int selectedIndex;
  final bool Function(int index) isEnabled;
  final Color? Function(int index)? colorBuilder;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onChanged;

  static const double _itemExtent = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemExtent,
        perspective: 0.002,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final enabled = isEnabled(index);
            return Center(
              child: Text(
                labelBuilder(index),
                maxLines: 1,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: enabled
                      ? colorBuilder?.call(index)
                      : theme.disabledColor,
                  fontWeight: index == selectedIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
