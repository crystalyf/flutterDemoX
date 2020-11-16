import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:provider/provider.dart';

import 'components/day_box.dart';
import 'components/mathview_date_info.dart';
import 'components/month_view_action_bar.dart';
import 'feel_calendar_view_model.dart';


// ignore: must_be_immutable
class MonthView extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelectedFn;
  final Function(DateTime showMonth) onMonthChangeFn;

  MonthView({
    this.onDateSelectedFn,
    this.onMonthChangeFn,
  }) {
    _setShowDate(DateTime.now());
    _selectedDate = DateTime.now();
  }

  DateTime _showDate;
  MonthViewDateInfo _monthViewDate;
  DateTime _selectedDate;

  void _setShowDate(DateTime date) {
    this._showDate = date;
    _monthViewDate = MonthViewDateInfo(_showDate);
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

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return FeelCalendarViewModel(
          _width, _onDaySelectedFn, widget._monthViewDate);
    }, child: Consumer<FeelCalendarViewModel>(builder: (context, value, child) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: BeautyColors.blue04,
              ),
              child: Column(
                children: [
                  MonthViewActionBar(
                    screenWidth: _width,
                    showMonth: widget._selectedDate ?? widget._showDate,
                    onDateChangeFn: (day) {
                      setState(() {
                        widget._setShowDate(day);
                        widget.onMonthChangeFn(day);
                        if (null != widget._selectedDate) {
                          widget.onDateSelectedFn(day);
                          widget._selectedDate = day;
                        }
                      });
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: BeautyColors.blue04,
                    ),
                    child: Column(
                        children:
                        context.watch<FeelCalendarViewModel>().weekRow),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    crossAxisCount: 7,
                    childAspectRatio: 7 / 13,
                    children:
                    context.select<FeelCalendarViewModel, List<DayBox>>(
                            (viewModel) => viewModel.dayList(widget._monthViewDate)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}




