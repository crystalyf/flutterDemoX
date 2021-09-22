import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:provider/provider.dart';

import 'components/mathview_date_info.dart';
import 'components/month_view_action_bar.dart';
import 'components/page_month.dart';
import 'feel_calendar_view_model.dart';

// ignore: must_be_immutable
class MonthView extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelectedFn;

  MonthView({
    this.onDateSelectedFn,
  }) {
    var thisMonthShowDate = DateTime.now();
    _setShowDate(thisMonthShowDate);
    _selectedDate = thisMonthShowDate;
    //last Month Page
    _addLastMonthPage(thisMonthShowDate);
    //this Month Page
    _addMonthPage(_monthViewDateInfo, thisMonthShowDate);
    //next Month Page
    _addNextMonthPage(thisMonthShowDate);
  }

  DateTime _showDate;
  MonthViewDateInfo _monthViewDateInfo;
  DateTime _selectedDate;

  //pageView加载的页面数据源，DateTime为key用来一一对应数据源
  final List<Map<DateTime, Widget>> _pageMonthList = [];

  //设置当前选中日子的日期
  void _setShowDate(DateTime date) {
    this._showDate = date;
    _monthViewDateInfo = MonthViewDateInfo(_showDate);
  }

  void _addMonthPage(MonthViewDateInfo monthViewDateInfo, DateTime dateTime) {
    var map = <DateTime, Widget>{};
    map[dateTime] = PageMonth(monthViewDateInfo);
    _pageMonthList.add(map);
  }

  void _addMouthPageAtFist(
      MonthViewDateInfo monthViewDateInfo, DateTime dateTime) {
    var map = <DateTime, Widget>{};
    map[dateTime] = PageMonth(monthViewDateInfo);
    _pageMonthList.insert(0, map);
  }

  ///追加上个月的Page
  void _addLastMonthPage(DateTime thisMonthShowDate) {
    var lastMonthShowDate = DateTime(thisMonthShowDate.year,
        thisMonthShowDate.month - 1, thisMonthShowDate.day);
    _addMouthPageAtFist(
        MonthViewDateInfo(lastMonthShowDate), lastMonthShowDate);
  }

  ///追加下个月的Page
  void _addNextMonthPage(DateTime thisMonthShowDate) {
    var lastMonthShowDate = DateTime(thisMonthShowDate.year,
        thisMonthShowDate.month + 1, thisMonthShowDate.day);
    _addMonthPage(MonthViewDateInfo(lastMonthShowDate), lastMonthShowDate);
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
          _width, _onDaySelectedFn, widget._monthViewDateInfo);
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
                    onDateChangeFn: (day, isPrevious) {
                      setState(() {
                        widget._setShowDate(day);
                        if (isPrevious) {
                          context.read<FeelCalendarViewModel>().currentPage--;
                        } else {
                          context.read<FeelCalendarViewModel>().currentPage++;
                        }
                        context
                            .read<FeelCalendarViewModel>()
                            .controller
                            .animateToPage(
                              context.read<FeelCalendarViewModel>().currentPage,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
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
                  //在SingleChildScrollView内部再进行一ConstrainedBox限制处理
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      children: [
                        Flexible(
                          child: PageView.builder(
                            itemBuilder: (context, index) {
                              return widget._pageMonthList[index].values.first;
                            },
                            itemCount: widget._pageMonthList.length,
                            controller: context
                                .watch<FeelCalendarViewModel>()
                                .controller,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index) {
                              setState(() {
                                context
                                    .read<FeelCalendarViewModel>()
                                    .currentPage = index;
                                widget._selectedDate =
                                    widget._pageMonthList[index].keys.first;
                                if (index == 0) {
                                  /**
                                   * 如果滑动到了第一页，那么要往pageList数据源最前面追加一页，此时新加的那一页便直接显示出来了。
                                   * 所以执行完addLastMonthPage之后，要显示index为1的那一页
                                   */
                                  widget
                                      ._addLastMonthPage(widget._selectedDate);
                                  context
                                      .read<FeelCalendarViewModel>()
                                      .currentPage = 1;
                                  context
                                      .read<FeelCalendarViewModel>()
                                      .controller
                                      .animateToPage(
                                        context
                                            .read<FeelCalendarViewModel>()
                                            .currentPage,
                                        duration:
                                            const Duration(milliseconds: 1),
                                        curve: Curves.easeInOut,
                                      );
                                } else if (index ==
                                    widget._pageMonthList.length - 1) {
                                  widget
                                      ._addNextMonthPage(widget._selectedDate);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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
