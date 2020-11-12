import 'dart:async';
import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'day.dart';
import 'month_view_action_bar.dart';

enum NoteIconType {
  none,
  grey,
  colorful,
}

// ignore: must_be_immutable
class MonthView extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelectedFn;
  final Function(DateTime showMonth) onMonthChangeFn;

  MonthView({
    this.onDateSelectedFn,
    this.onMonthChangeFn,
    initDate,
  }) {
    _setShowDate(initDate ?? DateTime.now());
    _selectedDate = initDate;
  }

  DateTime _showDate;
  _MonthViewDateInfo _monthViewDate;
  DateTime _selectedDate;

  _setShowDate(DateTime date) {
    this._showDate = date;
    _monthViewDate = _MonthViewDateInfo(_showDate, 1);
  }

  setShowMonth(DateTime month) {
    _setShowDate(month);
    Refresh();
  }

  Refresh() {
    if ((null != _monthViewState) && (_monthViewState.mounted)) {
      _monthViewState.setState(() {});
    }
  }

  MonthViewState _monthViewState;

  @override
  State<MonthView> createState() {
    _monthViewState = MonthViewState();

    return _monthViewState;
  }
}

class MonthViewState extends State<MonthView> {
  final double _width = MediaQueryData.fromWindow(window).size.width;

  Function(DateTime, bool) _onDaySelectedFn;

  MonthViewState() {
    _onDaySelectedFn = (DateTime date, bool selected) {
      widget._selectedDate = selected ? date : null;
      widget.onDateSelectedFn(widget._selectedDate);
      setState(() {});
    };
  }

  EventBus _eventBus = EventBus();
  StreamSubscription subscription;

  @override
  initState() {
    super.initState();

    subscription = _eventBus.on<DateTime>().listen((DateTime newDt) {
      widget._setShowDate(newDt);
      setState(() {});
    });
  }

  @override
  dispose() {
    _eventBus.destroy();

    super.dispose();
  }

  // List<TitleDay> _weekdayList(int firstWeekday) {
  //   List<TitleDay> _list = List.generate(7, (int index) {
  //     return TitleDay(((index + firstWeekday - 1) % 7) + 1, this._width);
  //   });
  //   return _list;
  // }

  List<DayBox> _generateDays(
      _MonthInfo monthInfo, bool baskgroundGrey, DateTime today) {
    List<DayBox> days = [];

    for (int index = 0, day = monthInfo.firstShowDay;
        index < monthInfo.showCount;
        index++, day++) {
      final date = DateTime(monthInfo.year, monthInfo.month, day);
      final selected = _isSameDay(date, widget._selectedDate);
      final isToday = _isSameDay(date, today);
      List<TextSpan> lunarStrs = [], gregorianStrs = [];

      final noteIconType = NoteIconType.colorful;
      assert(null != noteIconType);

      days.add(DayBox(date, _width,
          showNoteIcon: (noteIconType != NoteIconType.none),
          noteActive: (noteIconType == NoteIconType.colorful),
          selected: selected,
          isToday: isToday,
          baskgroundGrey: baskgroundGrey,
          gregorianStrs: gregorianStrs,
          lunarStrs: lunarStrs,
          onSelectCallback: _onDaySelectedFn));
    }

    return days;
  }

  List<DayBox> _dayList(final _MonthViewDateInfo _monthViewDate) {
    List<DayBox> _list = [];
    final today = DateTime.now();
    _MonthInfo monthInfo;
    List<DayBox> days;
    // previous month
    monthInfo = _monthViewDate.data[0];
    days = _generateDays(monthInfo, true, today);
    _list.addAll(days);
    // current month
    monthInfo = _monthViewDate.data[1];
    days = _generateDays(monthInfo, false, today);
    _list.addAll(days);
    // next month
    monthInfo = _monthViewDate.data[2];
    days = _generateDays(monthInfo, true, today);
    _list.addAll(days);
    assert(
        (28 == _list.length) || (35 == _list.length) || (42 == _list.length));
    return _list;
  }

  //每行day的Row
  _styleRow(List<Widget> list) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child:
            //每一行的day单元格
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: list));
  }

  List<Widget> _martrix(final List _dayList) {
    var table = <Widget>[];
    for (var i = 0; i < _dayList.length; i += 7) {
      table.add(_styleRow(_dayList.sublist(i, i + 7)));
    }
    return table;
  }

  @override
  Widget build(BuildContext context) {
    // final List<TitleDay> _weekdays = _weekdayList(1);
    final List<DayBox> _days = _dayList(widget._monthViewDate);
    final List<Widget> _table = _martrix(_days);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          //上个月，下个月的bar
          MonthViewActionBar(
            screenWidth: _width,
            showMonth: widget._selectedDate ?? widget._showDate,
            onDateChangeFn: (DateTime day) {
              widget._setShowDate(day);
              widget.onMonthChangeFn(day);
              if (null != widget._selectedDate) {
                widget.onDateSelectedFn(day);
                widget._selectedDate = day;
              }
              setState(() {});
            },
          ),
          Container(
            decoration: BoxDecoration(
//              color: Colors.red,
              border: Border.all(width: 1.0, color: Colors.black38),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: _table),
            ),
          ),
        ],
      ),
    );
  }
}

bool _isSameDay(final DateTime dt1, final DateTime dt2) {
  return ((null != dt1) &&
      (null != dt2) &&
      (dt1.day == dt2.day) &&
      (dt1.month == dt2.month) &&
      (dt1.year == dt2.year));
}

class _MonthInfo {
  int year = 0;
  int month = 0;
  int daysCount = 0;
  int firstShowDay = 0;
  int lastShowDay = 0;
  int showCount = 0;
}

class _MonthViewDateInfo {
  // 分别是上个月，当前月，下个月的数据
  final List<_MonthInfo> data = [_MonthInfo(), _MonthInfo(), _MonthInfo()];
  final DateTime dt;
  final int showFirstWeekday; // 从周几开始显示
  int calendarShowDaysCount; // 月历中需要显示的天数

  _MonthViewDateInfo(this.dt, this.showFirstWeekday) {
    assert(1 == showFirstWeekday); //目前只处理了从周一开始显示

    calendarShowDaysCount = 0;

    var thisMonthFirstWeedday = DateTime(dt.year, dt.month, 1).weekday;
    if (showFirstWeekday != thisMonthFirstWeedday) {
      var lastMonthInfo = data[0];
      DateTime lastMonth = DateTime(dt.year, dt.month, 0);
      lastMonthInfo.year = lastMonth.year;
      lastMonthInfo.month = lastMonth.month;
      lastMonthInfo.daysCount = lastMonth.day;

      if (1 == showFirstWeekday) {
        lastMonthInfo.showCount = thisMonthFirstWeedday - 1;
        lastMonthInfo.firstShowDay =
            lastMonthInfo.daysCount - lastMonthInfo.showCount + 1;
        lastMonthInfo.lastShowDay = lastMonth.day;
      }
      calendarShowDaysCount += lastMonthInfo.showCount;
    }

    DateTime thisMonth = DateTime(dt.year, dt.month + 1, 0);
    var thisMonthInfo = data[1];

    thisMonthInfo.year = thisMonth.year;
    thisMonthInfo.month = thisMonth.month;
    thisMonthInfo.daysCount = thisMonth.day;
    thisMonthInfo.firstShowDay = 1;
    thisMonthInfo.lastShowDay = thisMonth.day;
    thisMonthInfo.showCount = thisMonth.day;
    calendarShowDaysCount += thisMonthInfo.showCount;

    var nextMonthFirstWeekday = DateTime(dt.year, dt.month + 1, 1).weekday;
    if (showFirstWeekday != nextMonthFirstWeekday) {
      var lastMonthInfo = data[2];

      var nextMonth = DateTime(dt.year, dt.month + 2, 0);
      lastMonthInfo.year = nextMonth.year;
      lastMonthInfo.month = nextMonth.month;
      lastMonthInfo.daysCount = nextMonth.day;

      if (1 == showFirstWeekday) {
        lastMonthInfo.firstShowDay = 1;
        lastMonthInfo.showCount = 7 - nextMonthFirstWeekday + 1;
        lastMonthInfo.lastShowDay = lastMonthInfo.showCount;
      }
      calendarShowDaysCount += lastMonthInfo.showCount;
    }
  }
}
