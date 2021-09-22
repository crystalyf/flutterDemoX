import 'package:flutter/cupertino.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../../step_check_view_model.dart';
import 'chart_widget.dart';

class TimeDisplayWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimeDisplayState();
  }
}

class TimeDisplayState extends State<TimeDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    var type = context
        .select<CheckViewModel, ChartLayoutType>((viewModel) => viewModel.type);
    return Text(
      _getTime(type),
      style: Styles.text8.merge(TextStyle(color: BeautyColors.blue01)),
      textAlign: TextAlign.center,
    );
  }

  String _getTime(ChartLayoutType type) {
    var currentTime = _getShowTime(type);
    switch (type) {
      case ChartLayoutType.day:
        {
          // 日
          return '${currentTime.year}.${currentTime.month}.${currentTime.day}';
        }
      case ChartLayoutType.week:
        {
          // 週
          var monday =
              currentTime.subtract(Duration(days: currentTime.weekday));
          var sunday =
              currentTime.subtract(Duration(days: currentTime.weekday - 6));
          if (monday.year != sunday.year) {
            return '${monday.year}.${monday.month}.${monday.day}~${sunday.year}.${sunday.month}.${sunday.day}';
          } else if (monday.month != sunday.month) {
            return '${monday.year}.${monday.month}.${monday.day}~${sunday.month}.${sunday.day}';
          }
          return '${monday.year}.${monday.month}.${monday.day}~${sunday.day}';
        }
      case ChartLayoutType.month:
        {
          // 月
          return '${currentTime.year}年${currentTime.month}月';
        }
      case ChartLayoutType.year:
        {
          // 年
          return '${currentTime.year}年';
        }
    }
    return '';
  }

  DateTime _getShowTime(ChartLayoutType type) {
    var currentTimeDurationDays = context.select<CheckViewModel, int>(
        (viewModel) => viewModel.currentTimeDurationDays);
    var time = DateTime.now();
    switch (type) {
      case ChartLayoutType.day:
        {
          time = time.subtract(Duration(days: currentTimeDurationDays));
          break;
        }
      case ChartLayoutType.week:
        {
          time = time.subtract(Duration(days: 7 * currentTimeDurationDays));
          break;
        }
      case ChartLayoutType.month:
        {
          time = DateTime(
              time.year, time.month - currentTimeDurationDays, time.day);
          break;
        }
      case ChartLayoutType.year:
        {
          time = DateTime(
              time.year - currentTimeDurationDays, time.month, time.day);
        }
    }
    return time;
  }
}
