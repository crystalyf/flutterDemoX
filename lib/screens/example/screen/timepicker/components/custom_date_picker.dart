// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';

// Values derived from https://developer.apple.com/design/resources/ and on iOS
// simulators with "Debug View Hierarchy".
const double _kItemExtent = 32.0;
const double _kPickerHeight = 216.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 27.0;
// The density of a date picker is different from a generic picker.
// Eyeballed from iOS.
const double _kSqueeze = 1.25;

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  letterSpacing: -0.83,
);

// The item height is 32 and the magnifier height is 34, from
// iOS simulators with "Debug View Hierarchy".
// And the magnified fontSize by [_kTimerPickerMagnification] conforms to the
// iOS 14 native style by eyeball test.
const double _kTimerPickerMagnification = 34 / 32;

TextStyle _themeTextStyle(BuildContext context, {bool isValid = true}) {
  final style = CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle;
  return isValid
      ? style
      : style.copyWith(
          color: CupertinoDynamicColor.resolve(
              CupertinoColors.inactiveGray, context));
}

void _animateColumnControllerToItem(
    FixedExtentScrollController controller, int targetItem) {
  controller.animateToItem(
    targetItem,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 200),
  );
}

//SelectionOverlay: 选中的遮挡。
const Widget _leftSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capRightEdge: false);
const Widget _centerSelectionOverlay = CupertinoPickerDefaultSelectionOverlay(
  capLeftEdge: false,
  capRightEdge: false,
);
const Widget _rightSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capLeftEdge: false);

// Lays out the date picker based on how much space each single column needs.
//
// Each column is a child of this delegate, indexed from 0 to number of columns - 1.
// Each column will be padded horizontally by 12.0 both left and right.
//
// The picker will be placed in the center, and the leftmost and rightmost
// column will be extended equally to the remaining width.
class _DatePickerLayoutDelegate extends MultiChildLayoutDelegate {
  _DatePickerLayoutDelegate({
    @required this.columnWidths,
    @required this.textDirectionFactor,
  })  : assert(columnWidths != null),
        assert(textDirectionFactor != null);

  // The list containing widths of all columns.
  final List<double> columnWidths;

  // textDirectionFactor is 1 if text is written left to right, and -1 if right to left.
  final int textDirectionFactor;

  @override
  void performLayout(Size size) {
    var remainingWidth = size.width;

    for (var i = 0; i < columnWidths.length; i++) {

      //控制picker间的左右间距
      remainingWidth -= columnWidths[i] + _kDatePickerPadSize;
    }

    var currentHorizontalOffset = 0.0;

    for (var i = 0; i < columnWidths.length; i++) {
      final index = textDirectionFactor == 1 ? i : columnWidths.length - i - 1;
      //控制picker间的左右间距
      var childWidth = columnWidths[i] + _kDatePickerPadSize;
      if (index == 0 || index == columnWidths.length - 1) {
        childWidth += remainingWidth / 2;
      }

      // We can't actually assert here because it would break things badly for
      // semantics, which will expect that we laid things out here.
      assert(() {
        if (childWidth < 0) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: FlutterError(
                'Insufficient horizontal space to render the '
                'CupertinoDatePicker because the parent is too narrow at '
                '${size.width}px.\n'
                'An additional ${-remainingWidth}px is needed to avoid '
                'overlapping columns.',
              ),
            ),
          );
        }
        return true;
      }());
      layoutChild(index,
          BoxConstraints.tight(Size(math.max(0.0, childWidth), size.height)));
      positionChild(index, Offset(currentHorizontalOffset, 0.0));

      currentHorizontalOffset += childWidth;
    }
  }

  @override
  bool shouldRelayout(_DatePickerLayoutDelegate oldDelegate) {
    return columnWidths != oldDelegate.columnWidths ||
        textDirectionFactor != oldDelegate.textDirectionFactor;
  }
}

/// Different display modes of [CupertinoDatePickerCustom].
///
/// See also:
///
///  * [CupertinoDatePickerCustom], the class that implements different display modes
///    of the iOS-style date picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
enum CupertinoDatePickerModeCustom {
  /// Mode that shows the date in hour, minute, and (optional) an AM/PM designation.
  /// The AM/PM designation is shown only if [CupertinoDatePickerCustom] does not use 24h format.
  /// Column order is subject to internationalization.
  ///
  /// Example: ` 4 | 14 | PM `.
  time,

  /// Mode that shows the date in month, day of month, and year.
  /// Name of month is spelled in full.
  /// Column order is subject to internationalization.
  ///
  /// Example: ` July | 13 | 2012 `.
  date,

  /// Mode that shows the date as day of the week, month, day of month and
  /// the time in hour, minute, and (optional) an AM/PM designation.
  /// The AM/PM designation is shown only if [CupertinoDatePickerCustom] does not use 24h format.
  /// Column order is subject to internationalization.
  ///
  /// Example: ` Fri Jul 13 | 4 | 14 | PM `
  dateAndTime,
}

// Different types of column in CupertinoDatePicker.
enum _PickerColumnType {
  // Day of month column in date mode.
  dayOfMonth,
  // Month column in date mode.
  month,
  // Year column in date mode.
  year,
  // Medium date column in dateAndTime mode.
  date,
  // Hour column in time and dateAndTime mode.
  hour,
  // minute column in time and dateAndTime mode.
  minute,
  // AM/PM column in time and dateAndTime mode.
  dayPeriod,
}

/// A date picker widget in iOS style.
///
/// There are several modes of the date picker listed in [CupertinoDatePickerModeCustom].
///
/// The class will display its children as consecutive columns. Its children
/// order is based on internationalization.
///
/// Example of the picker in date mode:
///
///  * US-English: `| July | 13 | 2012 |`
///  * Vietnamese: `| 13 | Tháng 7 | 2012 |`
///
/// Can be used with [showCupertinoModalPopup] to display the picker modally at
/// the bottom of the screen.
///
/// Sizes itself to its parent and may not render correctly if not given the
/// full screen width. Content texts are shown with
/// [CupertinoTextThemeData.dateTimePickerTextStyle].
///
/// See also:
///
///  * [CupertinoTimerPicker], the class that implements the iOS-style timer picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
class CupertinoDatePickerCustom extends StatefulWidget {
  /// Constructs an iOS style date picker.
  ///
  /// [mode] is one of the mode listed in [CupertinoDatePickerModeCustom] and defaults
  /// to [CupertinoDatePickerModeCustom.dateAndTime].
  ///
  /// [onDateTimeChanged] is the callback called when the selected date or time
  /// changes and must not be null. When in [CupertinoDatePickerModeCustom.time] mode,
  /// the year, month and day will be the same as [initialDateTime]. When in
  /// [CupertinoDatePickerModeCustom.date] mode, this callback will always report the
  /// start time of the currently selected day.
  ///
  /// [initialDateTime] is the initial date time of the picker. Defaults to the
  /// present date and time and must not be null. The present must conform to
  /// the intervals set in [minimumDate], [maximumDate], [minimumYear], and
  /// [maximumYear].
  ///
  /// [minimumDate] is the minimum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the minimum [DateTime] the user can pick.
  /// In [CupertinoDatePickerModeCustom.time] mode, [minimumDate] should typically be
  /// on the same date as [initialDateTime], as the picker will not limit the
  /// minimum time the user can pick if it's set to a date earlier than that.
  ///
  /// [maximumDate] is the maximum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the maximum [DateTime] the user can pick.
  /// In [CupertinoDatePickerModeCustom.time] mode, [maximumDate] should typically be
  /// on the same date as [initialDateTime], as the picker will not limit the
  /// maximum time the user can pick if it's set to a date later than that.
  ///
  /// [minimumYear] is the minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeCustom.date] mode. Defaults to 1 and must not be null.
  ///
  /// [maximumYear] is the maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeCustom.date] mode. Null if there's no limit.
  ///
  /// [minuteInterval] is the granularity of the minute spinner. Must be a
  /// positive integer factor of 60.
  ///
  /// [use24hFormat] decides whether 24 hour format is used. Defaults to false.
  ///

  CupertinoDatePickerCustom({
    Key key,
    this.mode = CupertinoDatePickerModeCustom.dateAndTime,
    @required this.onDateTimeChanged,
    DateTime initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.minimumYear = 1,
    this.maximumYear,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.backgroundColor,
  })  : initialDateTime = initialDateTime ?? DateTime.now(),
        assert(mode != null),
        assert(onDateTimeChanged != null),
        assert(minimumYear != null),
        assert(
          minuteInterval > 0 && 60 % minuteInterval == 0,
          'minute interval is not a positive integer factor of 60',
        ),
        super(key: key) {
    assert(this.initialDateTime != null);
    assert(
      mode != CupertinoDatePickerModeCustom.dateAndTime ||
          minimumDate == null ||
          !this.initialDateTime.isBefore(minimumDate),
      'initial date is before minimum date',
    );
    assert(
      mode != CupertinoDatePickerModeCustom.dateAndTime ||
          maximumDate == null ||
          !this.initialDateTime.isAfter(maximumDate),
      'initial date is after maximum date',
    );
    assert(
      mode != CupertinoDatePickerModeCustom.date ||
          (minimumYear >= 1 && this.initialDateTime.year >= minimumYear),
      'initial year is not greater than minimum year, or minimum year is not positive',
    );
    assert(
      mode != CupertinoDatePickerModeCustom.date ||
          maximumYear == null ||
          this.initialDateTime.year <= maximumYear,
      'initial year is not smaller than maximum year',
    );
    assert(
      mode != CupertinoDatePickerModeCustom.date ||
          minimumDate == null ||
          !minimumDate.isAfter(this.initialDateTime),
      'initial date ${this.initialDateTime} is not greater than or equal to minimumDate $minimumDate',
    );
    assert(
      mode != CupertinoDatePickerModeCustom.date ||
          maximumDate == null ||
          !maximumDate.isBefore(this.initialDateTime),
      'initial date ${this.initialDateTime} is not less than or equal to maximumDate $maximumDate',
    );
    assert(
      this.initialDateTime.minute % minuteInterval == 0,
      'initial minute is not divisible by minute interval',
    );
  }

  /// The mode of the date picker as one of [CupertinoDatePickerModeCustom].
  /// Defaults to [CupertinoDatePickerModeCustom.dateAndTime]. Cannot be null and
  /// value cannot change after initial build.
  final CupertinoDatePickerModeCustom mode;

  /// The initial date and/or time of the picker. Defaults to the present date
  /// and time and must not be null. The present must conform to the intervals
  /// set in [minimumDate], [maximumDate], [minimumYear], and [maximumYear].
  ///
  /// Changing this value after the initial build will not affect the currently
  /// selected date time.
  final DateTime initialDateTime;

  /// The minimum selectable date that the picker can settle on.
  ///
  /// When non-null, the user can still scroll the picker to [DateTime]s earlier
  /// than [minimumDate], but the [onDateTimeChanged] will not be called on
  /// these [DateTime]s. Once let go, the picker will scroll back to [minimumDate].
  ///
  /// In [CupertinoDatePickerModeCustom.time] mode, a time becomes unselectable if the
  /// [DateTime] produced by combining that particular time and the date part of
  /// [initialDateTime] is earlier than [minimumDate]. So typically [minimumDate]
  /// needs to be set to a [DateTime] that is on the same date as [initialDateTime].
  ///
  /// Defaults to null. When set to null, the picker does not impose a limit on
  /// the earliest [DateTime] the user can select.
  final DateTime minimumDate;

  /// The maximum selectable date that the picker can settle on.
  ///
  /// When non-null, the user can still scroll the picker to [DateTime]s later
  /// than [maximumDate], but the [onDateTimeChanged] will not be called on
  /// these [DateTime]s. Once let go, the picker will scroll back to [maximumDate].
  ///
  /// In [CupertinoDatePickerModeCustom.time] mode, a time becomes unselectable if the
  /// [DateTime] produced by combining that particular time and the date part of
  /// [initialDateTime] is later than [maximumDate]. So typically [maximumDate]
  /// needs to be set to a [DateTime] that is on the same date as [initialDateTime].
  ///
  /// Defaults to null. When set to null, the picker does not impose a limit on
  /// the latest [DateTime] the user can select.
  final DateTime maximumDate;

  /// Minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeCustom.date] mode. Defaults to 1 and must not be null.
  final int minimumYear;

  /// Maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeCustom.date] mode. Null if there's no limit.
  final int maximumYear;

  /// The granularity of the minutes spinner, if it is shown in the current mode.
  /// Must be an integer factor of 60.
  final int minuteInterval;

  /// Whether to use 24 hour format. Defaults to false.
  final bool use24hFormat;

  /// Callback called when the selected date and/or time changes. If the new
  /// selected [DateTime] is not valid, or is not in the [minimumDate] through
  /// [maximumDate] range, this callback will not be called.
  ///
  /// Must not be null.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Background color of date picker.
  ///
  /// Defaults to null, which disables background painting entirely.
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() {
    // The `time` mode and `dateAndTime` mode of the picker share the time
    // columns, so they are placed together to one state.
    // The `date` mode has different children and is implemented in a different
    // state.
    switch (mode) {
      case CupertinoDatePickerModeCustom.time:
      case CupertinoDatePickerModeCustom.dateAndTime:
      case CupertinoDatePickerModeCustom.date:
        return _CupertinoDatePickerDateState();
    }
  }

  // Estimate the minimum width that each column needs to layout its content.
  static double _getColumnWidth(
    _PickerColumnType columnType,
    CupertinoLocalizations localizations,
    BuildContext context,
  ) {
    var longestText = '';

    switch (columnType) {
      case _PickerColumnType.date:
        // Measuring the length of all possible date is impossible, so here
        // just some dates are measured.
        for (var i = 1; i <= 12; i++) {
          // An arbitrary date.
          final date =
              localizations.datePickerMediumDate(DateTime(2018, i, 25));
          if (longestText.length < date.length) {
            longestText = date;
          }
        }
        break;
      case _PickerColumnType.hour:
        for (var i = 0; i < 24; i++) {
          final hour = localizations.datePickerHour(i);
          if (longestText.length < hour.length) {
            longestText = hour;
          }
        }
        break;
      case _PickerColumnType.minute:
        for (var i = 0; i < 60; i++) {
          final minute = localizations.datePickerMinute(i);
          if (longestText.length < minute.length) {
            longestText = minute;
          }
        }
        break;
      case _PickerColumnType.dayPeriod:
        longestText = localizations.anteMeridiemAbbreviation.length >
                localizations.postMeridiemAbbreviation.length
            ? localizations.anteMeridiemAbbreviation
            : localizations.postMeridiemAbbreviation;
        break;
      case _PickerColumnType.dayOfMonth:
        for (var i = 1; i <= 31; i++) {
          final dayOfMonth = localizations.datePickerDayOfMonth(i);
          if (longestText.length < dayOfMonth.length) {
            longestText = dayOfMonth;
          }
        }
        break;
      case _PickerColumnType.month:
        for (var i = 1; i <= 12; i++) {
          final month = localizations.datePickerMonth(i);
          if (longestText.length < month.length) {
            longestText = month;
          }
        }
        break;
      case _PickerColumnType.year:
        longestText = localizations.datePickerYear(2018);
        break;
    }

    assert(longestText != '', 'column type is not appropriate');

    final painter = TextPainter(
      text: TextSpan(
        style: _themeTextStyle(context),
        text: longestText,
      ),
      textDirection: Directionality.of(context),
    );

    // This operation is expensive and should be avoided. It is called here only
    // because there's no other way to get the information we want without
    // laying out the text.
    painter.layout();

    return painter.maxIntrinsicWidth;
  }
}

typedef _ColumnBuilder = Widget Function(double offAxisFraction,
    TransitionBuilder itemPositioningBuilder, Widget selectionOverlay);

class _CupertinoDatePickerDateState extends State<CupertinoDatePickerCustom> {
  int textDirectionFactor;
  CupertinoLocalizations localizations;

  // Alignment based on text direction. The variable name is self descriptive,
  // however, when text direction is rtl, alignment is reversed.
  Alignment alignCenterLeft;
  Alignment alignCenterRight;

  // The currently selected values of the picker.
  int selectedDay;
  int selectedMonth;
  int selectedYear;

  // The controller of the day picker. There are cases where the selected value
  // of the picker is invalid (e.g. February 30th 2018), and this dayController
  // is responsible for jumping to a valid value.
  FixedExtentScrollController dayController;
  FixedExtentScrollController monthController;
  FixedExtentScrollController yearController;

  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;

  // Estimated width of columns.
  Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDateTime.day;
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      // System fonts change might cause the text layout width to change.
      _refreshEstimatedColumnWidths();
    });
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);

    alignCenterLeft =
        textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
        textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    _refreshEstimatedColumnWidths();
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.dayOfMonth.index] =
        CupertinoDatePickerCustom._getColumnWidth(
            _PickerColumnType.dayOfMonth, localizations, context);
    estimatedColumnWidths[_PickerColumnType.month.index] =
        CupertinoDatePickerCustom._getColumnWidth(
            _PickerColumnType.month, localizations, context);
    estimatedColumnWidths[_PickerColumnType.year.index] =
        CupertinoDatePickerCustom._getColumnWidth(
            _PickerColumnType.year, localizations, context);
  }

  // The DateTime of the last day of a given month in a given year.
  // Let `DateTime` handle the year/month overflow.
  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  Widget _buildDayPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final daysInCurrentMonth = _lastDayInMonth(selectedYear, selectedMonth).day;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          isDayPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDayPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: dayController,
        //轴间距系数，滑动偏移效果控制
        offAxisFraction: offAxisFraction,
        //行高
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        //picker item 之间的纵间隔
        squeeze: _kSqueeze,
        onSelectedItemChanged: (index) {
          selectedDay = index + 1;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        children: List<Widget>.generate(31, (index) {
          final day = index + 1;
          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerDayOfMonth(day),
              style:
                  _themeTextStyle(context, isValid: day <= daysInCurrentMonth),
            ),
          );
        }),
        looping: true,
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  Widget _buildMonthPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (index) {
          selectedMonth = index + 1;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        children: List<Widget>.generate(12, (index) {
          final month = index + 1;
          final isInvalidMonth = (widget.minimumDate?.year == selectedYear &&
                  widget.minimumDate.month > month) ||
              (widget.maximumDate?.year == selectedYear &&
                  widget.maximumDate.month < month);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerMonth(month),
              style: _themeTextStyle(context, isValid: !isInvalidMonth),
            ),
          );
        }),
        looping: true,
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  Widget _buildYearPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: yearController,
        itemExtent: _kItemExtent,
        offAxisFraction: -0.1,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        onSelectedItemChanged: (index) {
          selectedYear = index;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        itemBuilder: (context, year) {
          if (year < widget.minimumYear) return null;

          if (widget.maximumYear != null && year > widget.maximumYear) {
            return null;
          }

          final isValidYear = (widget.minimumDate == null ||
                  widget.minimumDate.year <= year) &&
              (widget.maximumDate == null || widget.maximumDate.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: _themeTextStyle(context, isValid: isValidYear),
            ),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  bool get _isCurrentDateValid {
    // The current date selection represents a range [minSelectedData, maxSelectDate].
    final minSelectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    final maxSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final minCheck = widget.minimumDate?.isBefore(maxSelectedDate) ?? true;
    final maxCheck = widget.maximumDate?.isBefore(minSelectedDate) ?? false;

    return minCheck && !maxCheck && minSelectedDate.day == selectedDay;
  }

  // One or more pickers have just stopped scrolling.
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    // Whenever scrolling lands on an invalid entry, the picker
    // automatically scrolls to a valid one.
    final minSelectDate = DateTime(selectedYear, selectedMonth, selectedDay);
    final maxSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final minCheck = widget.minimumDate?.isBefore(maxSelectDate) ?? true;
    final maxCheck = widget.maximumDate?.isBefore(minSelectDate) ?? false;

    if (!minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final targetDate = minCheck ? widget.maximumDate : widget.minimumDate;
      _scrollToDate(targetDate);
      return;
    }

    // Some months have less days (e.g. February). Go to the last day of that month
    // if the selectedDay exceeds the maximum.
    if (minSelectDate.day != selectedDay) {
      final lastDay = _lastDayInMonth(selectedYear, selectedMonth);
      _scrollToDate(lastDay);
    }
  }

  void _scrollToDate(DateTime newDate) {
    assert(newDate != null);
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }

      if (selectedDay != newDate.day) {
        _animateColumnControllerToItem(dayController, newDate.day - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var pickerBuilders = <_ColumnBuilder>[];
    var columnWidths = <double>[];
    switch (localizations.datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        //時間セレクターは年、月、日の形式しかないため、カスタムXは提案されません、ymd直接変更されます。
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
          _buildDayPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.month.index],
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
          estimatedColumnWidths[_PickerColumnType.year.index],
        ];
        break;
      case DatePickerDateOrder.dmy:
        pickerBuilders = <_ColumnBuilder>[
          _buildDayPicker,
          _buildMonthPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
          estimatedColumnWidths[_PickerColumnType.month.index],
          estimatedColumnWidths[_PickerColumnType.year.index],
        ];
        break;
      case DatePickerDateOrder.ymd:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
          _buildDayPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index],
          estimatedColumnWidths[_PickerColumnType.month.index],
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
        ];
        break;
      case DatePickerDateOrder.ydm:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildDayPicker,
          _buildMonthPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index],
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
          estimatedColumnWidths[_PickerColumnType.month.index],
        ];
        break;
      default:
        assert(false, 'date order is not specified');
    }

    final pickers = <Widget>[];

    for (var i = 0; i < columnWidths.length; i++) {
      final offAxisFraction = (i - 1) * 0.3 * textDirectionFactor;
      //item距离边缘的padding
      var padding = const EdgeInsets.only(right: 10);

      //系统默认的选中边框
      // var selectionOverlay = _centerSelectionOverlay;
      // if (i == 0) {
      //   selectionOverlay = _leftSelectionOverlay;
      // } else if (i == columnWidths.length - 1) {
      //   selectionOverlay = _rightSelectionOverlay;
      // }

      //自定义选中边框
      var selectionOverlay = Container(
        height: 50,
        decoration: BoxDecoration(
          //设置四周边框
          border: Border.all(width: 1, color: BeautyColors.black01),
        ),
      );

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (context, child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: i == 0 ? null : padding,
              child: Container(
                alignment: i == 0 ? alignCenterLeft : alignCenterRight,
                width: columnWidths[0] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
          selectionOverlay,
        ),
      ));
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }
}

// The iOS date picker and timer picker has their width fixed to 320.0 in all
// modes. The only exception is the hms mode (which doesn't have a native counterpart),
// with a fixed width of 330.0 px.
//
// For date pickers, if the maximum width given to the picker is greater than
// 320.0, the leftmost and rightmost column will be extended equally so that the
// widths match, and the picker is in the center.
//
// For timer pickers, if the maximum width given to the picker is greater than
// its intrinsic width, it will keep its intrinsic size and position itself in the
// parent using its alignment parameter.
//
// If the maximum width given to the picker is smaller than 320.0, the picker's
// layout will be broken.

/// Different modes of [CupertinoTimerPicker].
///
/// See also:
///
///  * [CupertinoTimerPicker], the class that implements the iOS-style timer picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
enum CupertinoTimerPickerMode {
  /// Mode that shows the timer duration in hour and minute.
  ///
  /// Examples: 16 hours | 14 min.
  hm,

  /// Mode that shows the timer duration in minute and second.
  ///
  /// Examples: 14 min | 43 sec.
  ms,

  /// Mode that shows the timer duration in hour, minute, and second.
  ///
  /// Examples: 16 hours | 14 min | 43 sec.
  hms,
}

/// A countdown timer picker in iOS style.
///
/// This picker shows a countdown duration with hour, minute and second spinners.
/// The duration is bound between 0 and 23 hours 59 minutes 59 seconds.
///
/// There are several modes of the timer picker listed in [CupertinoTimerPickerMode].
///
/// The picker has a fixed size of 320 x 216, in logical pixels, with the exception
/// of [CupertinoTimerPickerMode.hms], which is 330 x 216. If the parent widget
/// provides more space than it needs, the picker will position itself according
/// to its [alignment] property.
///
/// See also:
///
///  * [CupertinoDatePickerCustom], the class that implements different display modes
///    of the iOS-style date picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
class CupertinoTimerPicker extends StatefulWidget {
  /// Constructs an iOS style countdown timer picker.
  ///
  /// [mode] is one of the modes listed in [CupertinoTimerPickerMode] and
  /// defaults to [CupertinoTimerPickerMode.hms].
  ///
  /// [onTimerDurationChanged] is the callback called when the selected duration
  /// changes and must not be null.
  ///
  /// [initialTimerDuration] defaults to 0 second and is limited from 0 second
  /// to 23 hours 59 minutes 59 seconds.
  ///
  /// [minuteInterval] is the granularity of the minute spinner. Must be a
  /// positive integer factor of 60.
  ///
  /// [secondInterval] is the granularity of the second spinner. Must be a
  /// positive integer factor of 60.
  CupertinoTimerPicker({
    Key key,
    this.mode = CupertinoTimerPickerMode.hms,
    this.initialTimerDuration = Duration.zero,
    this.minuteInterval = 1,
    this.secondInterval = 1,
    this.alignment = Alignment.center,
    this.backgroundColor,
    @required this.onTimerDurationChanged,
  })  : assert(mode != null),
        assert(onTimerDurationChanged != null),
        assert(initialTimerDuration >= Duration.zero),
        assert(initialTimerDuration < const Duration(days: 1)),
        assert(minuteInterval > 0 && 60 % minuteInterval == 0),
        assert(secondInterval > 0 && 60 % secondInterval == 0),
        assert(initialTimerDuration.inMinutes % minuteInterval == 0),
        assert(initialTimerDuration.inSeconds % secondInterval == 0),
        assert(alignment != null),
        super(key: key);

  /// The mode of the timer picker.
  final CupertinoTimerPickerMode mode;

  /// The initial duration of the countdown timer.
  final Duration initialTimerDuration;

  /// The granularity of the minute spinner. Must be a positive integer factor
  /// of 60.
  final int minuteInterval;

  /// The granularity of the second spinner. Must be a positive integer factor
  /// of 60.
  final int secondInterval;

  /// Callback called when the timer duration changes.
  final ValueChanged<Duration> onTimerDurationChanged;

  /// Defines how the timer picker should be positioned within its parent.
  ///
  /// This property must not be null. It defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// Background color of timer picker.
  ///
  /// Defaults to null, which disables background painting entirely.
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _CupertinoTimerPickerState();
}

class _CupertinoTimerPickerState extends State<CupertinoTimerPicker> {
  TextDirection textDirection;
  CupertinoLocalizations localizations;

  int get textDirectionFactor {
    switch (textDirection) {
      case TextDirection.ltr:
        return 1;
      case TextDirection.rtl:
        return -1;
    }
  }

  final TextPainter textPainter = TextPainter();
  final List<String> numbers = List<String>.generate(10, (i) => '${9 - i}');
  double numberLabelWidth;
  double numberLabelHeight;
  double numberLabelBaseline;

  double hourLabelWidth;
  double minuteLabelWidth;
  double secondLabelWidth;

  double totalWidth;
  double pickerColumnWidth;

  @override
  void initState() {
    super.initState();

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      // System fonts change might cause the text layout width to change.
      textPainter.markNeedsLayout();
      _measureLabelMetrics();
    });
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CupertinoTimerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    assert(
      oldWidget.mode == widget.mode,
      "The CupertinoTimerPicker's mode cannot change once it's built",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirection = Directionality.of(context);
    localizations = CupertinoLocalizations.of(context);

    _measureLabelMetrics();
  }

  void _measureLabelMetrics() {
    textPainter.textDirection = textDirection;
    final textStyle = _textStyleFrom(context, _kTimerPickerMagnification);

    var maxWidth = double.negativeInfinity;
    String widestNumber;

    // Assumes that:
    // - 2-digit numbers are always wider than 1-digit numbers.
    // - There's at least one number in 1-9 that's wider than or equal to 0.
    // - The widest 2-digit number is composed of 2 same 1-digit numbers
    //   that has the biggest width.
    // - If two different 1-digit numbers are of the same width, their corresponding
    //   2 digit numbers are of the same width.
    for (final input in numbers) {
      textPainter.text = TextSpan(
        text: input,
        style: textStyle,
      );
      textPainter.layout();

      if (textPainter.maxIntrinsicWidth > maxWidth) {
        maxWidth = textPainter.maxIntrinsicWidth;
        widestNumber = input;
      }
    }

    textPainter.text = TextSpan(
      text: '$widestNumber$widestNumber',
      style: textStyle,
    );

    textPainter.layout();
    numberLabelWidth = textPainter.maxIntrinsicWidth;
    numberLabelHeight = textPainter.height;
    numberLabelBaseline =
        textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);

    minuteLabelWidth = _measureLabelsMaxWidth(
        localizations.timerPickerMinuteLabels, textStyle);

    if (widget.mode != CupertinoTimerPickerMode.ms) {
      hourLabelWidth = _measureLabelsMaxWidth(
          localizations.timerPickerHourLabels, textStyle);
    }

    if (widget.mode != CupertinoTimerPickerMode.hm) {
      secondLabelWidth = _measureLabelsMaxWidth(
          localizations.timerPickerSecondLabels, textStyle);
    }
  }

  // Measures all possible time text labels and return maximum width.
  double _measureLabelsMaxWidth(List<String> labels, TextStyle style) {
    var maxWidth = double.negativeInfinity;
    for (var i = 0; i < labels.length; i++) {
      final label = labels[i];
      if (label == null) {
        continue;
      }

      textPainter.text = TextSpan(text: label, style: style);
      textPainter.layout();
      textPainter.maxIntrinsicWidth;
      if (textPainter.maxIntrinsicWidth > maxWidth) {
        maxWidth = textPainter.maxIntrinsicWidth;
      }
    }

    return maxWidth;
  }

  // Returns [CupertinoTextThemeData.pickerTextStyle] and magnifies the fontSize
  // by [magnification].
  TextStyle _textStyleFrom(BuildContext context, [double magnification = 1.0]) {
    final textStyle = CupertinoTheme.of(context).textTheme.pickerTextStyle;
    return textStyle.copyWith(fontSize: textStyle.fontSize * magnification);
  }

  // Calculate the number label center point by padding start and position to
  // get a reasonable offAxisFraction.
  double _calculateOffAxisFraction(double paddingStart, int position) {
    final centerPoint = paddingStart + (numberLabelWidth / 2);

    // Compute the offAxisFraction needed to be straight within the pickerColumn.
    final pickerColumnOffAxisFraction = 0.5 - centerPoint / pickerColumnWidth;
    // Position is to calculate the reasonable offAxisFraction in the picker.
    final timerPickerOffAxisFraction =
        0.5 - (centerPoint + pickerColumnWidth * position) / totalWidth;
    return (pickerColumnOffAxisFraction - timerPickerOffAxisFraction) *
        textDirectionFactor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The timer picker can be divided into columns corresponding to hour,
        // minute, and second. Each column consists of a scrollable and a fixed
        // label on top of it.
        List<Widget> columns;

        if (constraints.maxWidth < totalWidth) {
          totalWidth = constraints.maxWidth;
          pickerColumnWidth = totalWidth /
              (widget.mode == CupertinoTimerPickerMode.hms ? 3 : 2);
        }
        switch (widget.mode) {
          case CupertinoTimerPickerMode.hm:
            break;
          case CupertinoTimerPickerMode.ms:
            break;
          case CupertinoTimerPickerMode.hms:
            break;
        }
        final themeData = CupertinoTheme.of(context);
        return MediaQuery(
          // The native iOS picker's text scaling is fixed, so we will also fix it
          // as well in our picker.
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: CupertinoTheme(
            data: themeData.copyWith(
              textTheme: themeData.textTheme.copyWith(
                pickerTextStyle:
                    _textStyleFrom(context, _kTimerPickerMagnification),
              ),
            ),
            child: Align(
              alignment: widget.alignment,
              child: Container(
                color: CupertinoDynamicColor.resolve(
                    widget.backgroundColor, context),
                width: totalWidth,
                height: _kPickerHeight,
                child: DefaultTextStyle(
                  style: _textStyleFrom(context),
                  child: Row(
                      children: columns
                          .map((child) => Expanded(child: child))
                          .toList(growable: false)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}