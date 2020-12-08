
import 'package:flutter/cupertino.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';
import 'package:provider/provider.dart';

import '../weight_top_view_model.dart';
import 'poly_type_enum.dart';

class TimeDisplayWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimeDisplayState();
  }
}

class TimeDisplayState extends State<TimeDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    var type = context.select<WeightTopViewModel, PolyLayoutType>(
        (viewModel) => viewModel.polyType);
    return Text(
      _getTime(type),
      style: Styles.text8.merge(TextStyle(color: BeautyColors.blue01)),
      textAlign: TextAlign.center,
    );
  }

  String _getTime(PolyLayoutType type) {
    var currentTime = _getShowTime(type);
    switch (type) {
      case PolyLayoutType.week:
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
      case PolyLayoutType.month:
        {
          // 月
          return '${currentTime.year}';
        }
      case PolyLayoutType.year:
        {
          // 年
          return '${currentTime.year}';
        }
    }
    return '';
  }

  DateTime _getShowTime(PolyLayoutType type) {
    var currentTimeDurationDays = context.select<WeightTopViewModel, int>(
        (viewModel) => viewModel.currentTimeDurationDays);
    var time = DateTime.now();
    switch (type) {
      case PolyLayoutType.week:
        {
          time = time.subtract(Duration(days: 7 * currentTimeDurationDays));
          break;
        }
      case PolyLayoutType.month:
        {
          time = DateTime(
              time.year, time.month - currentTimeDurationDays, time.day);
          break;
        }
      case PolyLayoutType.year:
        {
          time = DateTime(
              time.year - currentTimeDurationDays, time.month, time.day);
        }
    }
    return time;
  }
}
