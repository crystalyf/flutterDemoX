import 'package:flutter/material.dart';

import 'components/day_box.dart';
import 'components/mathview_date_info.dart';
import 'components/month_info.dart';
import 'components/title_day.dart';

class FeelCalendarViewModel extends ChangeNotifier {
  List<TitleDay> _weekdays;
  List<DayBox> days;
  List<Widget> weekRow;

  double width;
  Function(DateTime, bool) onDaySelectedFn;

  FeelCalendarViewModel(
      double widthSize,
      Function(DateTime, bool) onDaySelectedFnParm,
      MonthViewDateInfo monthViewDate) {
    width = widthSize;
    onDaySelectedFn = onDaySelectedFnParm;
    // days = dayList(monthViewDate);
    _weekdays = _weekdayList();
    weekRow = _martrix(_weekdays);
  }

  List<TitleDay> _weekdayList() {
    var firstWeekday = 1;
    var _list = List<TitleDay>.generate(7, (index) {
      return TitleDay(((index + firstWeekday - 1) % 7) + 1, width);
    });
    return _list;
  }

  List<DayBox> _generateDays(
      MonthInfo monthInfo, bool backgroundGrey, DateTime today) {
    var days = <DayBox>[];
    // ignore: omit_local_variable_types
    for (int index = 0, day = monthInfo.firstShowDay;
        index < monthInfo.showCount;
        index++, day++) {
      //毎日のデータソース
      final date = DateTime(monthInfo.year, monthInfo.month, day);
      final isToday = _isSameDay(date, today);
      days.add(DayBox(date, width,
          isToday: isToday,
          backgroundGrey: backgroundGrey,
          onSelectCallback: onDaySelectedFn));
    }
    return days;
  }

  List<DayBox> dayList(final MonthViewDateInfo _monthViewDate) {
    var _list = <DayBox>[];
    final today = DateTime.now();
    MonthInfo monthInfo;
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
    days.clear();
    days.addAll(_list);
    return days;
  }

  Container _styleRow(List<Widget> list) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list));
  }

  List<Widget> _martrix(final List<Widget> _weekdays) {
    var table = <Widget>[];
    table.add(
      Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: _styleRow(_weekdays),
      ),
    );
    return table;
  }

  bool _isSameDay(final DateTime dt1, final DateTime dt2) {
    return ((null != dt1) &&
        (null != dt2) &&
        (dt1.day == dt2.day) &&
        (dt1.month == dt2.month) &&
        (dt1.year == dt2.year));
  }
}
