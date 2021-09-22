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
  WeightTopViewModel viewModel = WeightTopViewModel();

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<WeightTopViewModel>(context);
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
          /// 週
          //用当前日期减去这周所在day, 得到周日的日期（比如12.6是周二，那么就当前日减2，得到周日的日子）
          var sunday =
              currentTime.subtract(Duration(days: currentTime.weekday));
          //保存周状态下当前的开始周日日期。
          viewModel.weightSundayDateTime = sunday;
          //同理思维得到这周六的日子
          var saturday =
              currentTime.subtract(Duration(days: currentTime.weekday - 6));
          if (sunday.year != saturday.year) {
            return '${sunday.year}.${sunday.month}.${sunday.day}~${saturday.year}.${saturday.month}.${saturday.day}';
          } else if (sunday.month != saturday.month) {
            return '${sunday.year}.${sunday.month}.${sunday.day}~${saturday.month}.${saturday.day}';
          }
          return '${sunday.year}.${sunday.month}.${sunday.day}~${saturday.day}';
        }
      case PolyLayoutType.month:
        {
          /// 月
          return '${currentTime.year}';
        }
      case PolyLayoutType.year:
        {
          /// 年
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
